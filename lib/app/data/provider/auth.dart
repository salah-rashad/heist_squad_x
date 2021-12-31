import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:heist_squad_x/app/data/model/user_model.dart';
import 'package:heist_squad_x/app/routes/app_pages.dart';

import 'database.dart';

class Auth extends GetxController {
  RxBool _isSignedIn = false.obs;
  bool get isSignedIn => this._isSignedIn.value;
  set isSignedIn(bool value) => this._isSignedIn.value = value;

  /* ************** */

  static Auth get i => Get.find<Auth>();

  /* ************** */

  static FirebaseAuth auth = FirebaseAuth.instance;

  final Rxn<User> _firebaseUser = Rxn(auth.currentUser);
  User? get firebaseUser => this._firebaseUser.value;
  set firebaseUser(User? value) => this._firebaseUser.value = value;

  final _userData = UserModel().obs;
  UserModel get userData => this._userData.value;
  set userData(UserModel value) => this._userData.value = value;

  void listenToAuthChanges() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user == null) {
        isSignedIn = false;
        Fluttertoast.showToast(msg: "User signed out.");
      } else {
        isSignedIn = true;
        Fluttertoast.showToast(msg: "User logged in.");
        this.userData = (await Database.getUser(user.uid))!;
      }
      Get.until((route) => Get.currentRoute == Routes.HOME);

      firebaseUser = user;
    });
  }

  Future<void> createAccount(UserModel user, String password) async {
    try {
      await auth.createUserWithEmailAndPassword(
        email: user.email!,
        password: password,
      );

      Database.createUser(user);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> loginUser(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      } else {
        print(e);
      }
    }
  }
}

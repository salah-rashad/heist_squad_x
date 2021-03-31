import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:heist_squad_x/app/data/model/user_model.dart';
import 'package:heist_squad_x/app/data/provider/auth.dart';
import 'package:heist_squad_x/app/data/provider/database.dart';
import 'package:heist_squad_x/app/routes/app_pages.dart';

class AuthController extends GetxService {
  RxBool _isSignedIn = false.obs;

  bool get isSignedIn => this._isSignedIn.value;
  set isSignedIn(bool value) => this._isSignedIn.value = value;

  /* ************** */

  static AuthController get c => Get.find<AuthController>();

  /* ************** */

  final firebaseUser = Auth.auth.currentUser;
  UserModel user = UserModel();

  @override
  void onReady() {
    FirebaseAuth.instance.authStateChanges().listen((User user) async {
      if (user == null) {
        isSignedIn = false;
        Fluttertoast.showToast(msg: "User signed out.");
      } else {
        isSignedIn = true;
        Fluttertoast.showToast(msg: "User logged in.");
        this.user = await Database.getUser(user.uid);
      }
      Get.until((route) => Get.currentRoute == Routes.HOME);
    });

    super.onReady();
  }
}

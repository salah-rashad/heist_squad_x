import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:heist_squad_x/app/data/provider/auth.dart';

class AuthController extends GetxController {
  RxBool _isSignedIn = false.obs;

  bool get isSignedIn => this._isSignedIn.value;
  set isSignedIn(bool value) => this._isSignedIn.value = value;

  /* ************** */

  
  final firebaseUser = Auth.auth.currentUser;


  @override
  void onInit() {
    FirebaseAuth.instance.authStateChanges().listen((User user) {
      if (user == null) {
        isSignedIn = false;
      } else {
        isSignedIn = true;
      }
    });

    super.onInit();
  }
}

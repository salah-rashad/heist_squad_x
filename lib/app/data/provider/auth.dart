import 'package:firebase_auth/firebase_auth.dart';
import 'package:heist_squad_x/app/data/model/user_model.dart';
import 'package:heist_squad_x/app/data/provider/database.dart';

class AuthProvider {
  AuthProvider._();
  
  static FirebaseAuth auth = FirebaseAuth.instance;

  static Future<void> createAccount(UserModel user, String password) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: user.email, password: password);

      DatabaseProvider.createUser(userCredential.user.uid, user);
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
}

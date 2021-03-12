import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:heist_squad_x/app/data/model/user_model.dart';

class DatabaseProvider {
  DatabaseProvider._();

  static FirebaseFirestore cloud = FirebaseFirestore.instance;

  static Future<void> createUser(String uid, UserModel user) async {
    try {
      cloud
          .collection("users")
          .doc(uid)
          .set(user.toJson())
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
    } catch (e) {}
  }
}

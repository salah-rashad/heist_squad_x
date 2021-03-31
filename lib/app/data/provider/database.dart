import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:heist_squad_x/app/data/model/room_model.dart';
import 'package:heist_squad_x/app/data/model/user_model.dart';

class Database {
  Database._();

  static FirebaseFirestore cloud = FirebaseFirestore.instance;

  static final users = cloud.collection("users");
  static final rooms = cloud.collection("rooms");

  static Future<void> createUser(UserModel user) async {
    try {
      users
          .doc(user.uid)
          .set(user.toJson())
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
    } catch (e) {
      print(e);
    }
  }

  static Future<UserModel> getUser(String uid) async {
    try {
      return users
          .doc(uid)
          .get()
          .then((data) => UserModel.fromSnapshot(data))
          .catchError((error) {
        print("Failed to get user: $error");
        return null;
      });
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Stream<QuerySnapshot> getOnlineUsers() {
    return users.where('active', isEqualTo: true).snapshots();
  }

  static Future<DocumentReference> createNewRoom(UserModel user) {
    return rooms.add(
      Room(
        name: user.nick + "'s Room",
        ownerId: user.uid,
        maxPlayers: 4,
        players: <String>[],
      ).toJson(),
    );
  }

  static Future<List<Room>> getRooms([int limit = 5]) async {
    try {
      var query = await rooms.orderBy("players").limit(limit).get();

      List<Room> roomsList = [];

      query.docs.forEach((doc) {
        roomsList.add(Room.fromSnapshot(doc));
      });

      return roomsList;
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Stream<DocumentSnapshot> streamRoom(String id) {
    return rooms.doc(id).snapshots();
  }
}

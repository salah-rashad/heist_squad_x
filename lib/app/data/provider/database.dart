import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:heist_squad_x/app/data/model/room_model.dart';
import 'package:heist_squad_x/app/data/model/user_model.dart';

class Database {
  Database._();

  static FirebaseFirestore cloud = FirebaseFirestore.instance;

  static final users = cloud.collection("users").withConverter<UserModel>(
        fromFirestore: (snapshot, options) => UserModel.fromSnapshot(snapshot),
        toFirestore: (value, options) => value.toMap(),
      );
  static final rooms = cloud.collection("rooms").withConverter<Room>(
        fromFirestore: (snapshot, options) => Room.fromSnapshot(snapshot),
        toFirestore: (value, options) => value.toMap(),
      );

  static Future<void> createUser(UserModel user) async {
    try {
      users
          .doc(user.uid)
          .set(user)
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
    } catch (e) {
      print(e);
    }
  }

  static Future<UserModel?> getUser(String uid) async {
    try {
      var doc = await users.doc(uid).get().catchError((error) {
        print("Failed to get user: $error");
      });
      return doc.data();
    } catch (e) {
      print(e);
    }
  }

  static Stream<QuerySnapshot<UserModel>> getOnlineUsers() {
    return users.where('active', isEqualTo: true).snapshots();
  }

  static Future<DocumentReference> createNewRoom(UserModel user) {
    final room = Room(
      name: (user.nick ?? "UnKnown") + "'s Room",
      ownerId: user.uid,
      ownerName: user.nick,
      maxPlayers: 4,
      players: <String>[],
    );

    return rooms.add(room);
  }

  static Future<List<Room>?> getRooms([int limit = 5]) async {
    try {
      var query = await rooms.orderBy("players").limit(limit).get();

      List<Room> roomsList = [];

      query.docs.forEach((doc) {
        roomsList.add(doc.data());
      });

      return roomsList;
    } catch (e) {
      print(e);
    }
  }

  static Stream<DocumentSnapshot<Room>> streamRoom(String id) {
    return rooms.doc(id).snapshots();
  }
}

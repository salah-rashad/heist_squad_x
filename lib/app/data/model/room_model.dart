import 'package:cloud_firestore/cloud_firestore.dart';

class Room {
  String? id;
  String? name;
  String? ownerId;
  String? ownerName;
  List? players;
  int? maxPlayers;
  bool? gameStarted;

  Room({
    this.id,
    required this.name,
    required this.ownerId,
    required this.ownerName,
    required this.maxPlayers,
    this.players,
    this.gameStarted = false,
  });

  Room.fromSnapshot(DocumentSnapshot<Map<String, dynamic>>? doc) {
    final data = doc!.data()!;
    id = doc.id;
    name = data['name'];
    ownerId = data['ownerId'];
    ownerName = data['ownerName'];
    players = data['players'];
    maxPlayers = data['maxPlayers'];
    gameStarted = data['gameStarted'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['ownerId'] = this.ownerId;
    data['ownerName'] = this.ownerName;
    data['players'] = this.players;
    data['maxPlayers'] = this.maxPlayers;
    data['gameStarted'] = this.gameStarted;

    return data;
  }
}

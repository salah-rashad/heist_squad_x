import 'package:cloud_firestore/cloud_firestore.dart';

class Room {
  String id, name, ownerId;
  List players;
  int maxPlayers;
  bool gameStarted;

  Room({
    this.id,
    this.name,
    this.ownerId,
    this.players,
    this.maxPlayers,
    this.gameStarted = false,
  });

  Room.fromSnapshot(DocumentSnapshot data) {
    this.id = data.id;
    this.name = data['name'];
    this.ownerId = data['ownerId'];
    this.players = data['players'];
    this.maxPlayers = data['maxPlayers'];
    this.gameStarted = data['gameStarted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['ownerId'] = this.ownerId;
    data['players'] = this.players;
    data['maxPlayers'] = this.maxPlayers;
    data['gameStarted'] = this.gameStarted;

    return data;
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:heist_squad_x/game/player/game_player.dart';

class UserModel {
  GamePlayer player;
  final String uid, nick, email;

  UserModel({
    this.uid,
    this.nick,
    this.email,
  });

  factory UserModel.fromSnapshot(DocumentSnapshot data) {
    return UserModel(
      uid: data.id,
      nick: data['nick'],
      email: data['email'],
    );
  }

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "nick": nick,
        "email": email,
      };
}

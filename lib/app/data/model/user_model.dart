import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:heist_squad_x/game/player/game_player.dart';

class UserModel {
  GamePlayer player;
  String uid, nick, email, weapon;
  int skinId;
  bool active;

  UserModel({
    this.uid,
    this.nick,
    this.email,
    this.weapon,
    this.skinId,
    this.active,
  });

  UserModel.fromSnapshot(DocumentSnapshot data) {
    this.uid = data.id;
    this.nick = data['nick'];
    this.email = data['email'];
    this.weapon = data['weapon'];
    this.skinId = data['skinId'];
    this.active = data['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data["uid"] = uid;
    data["nick"] = nick;
    data["email"] = email;
    data["weapon"] = weapon;
    data["skinId"] = skinId;
    data["active"] = active;

    return data;
  }
}

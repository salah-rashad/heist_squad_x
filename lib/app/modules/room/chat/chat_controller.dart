import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heist_squad_x/app/data/model/message_model.dart';
import 'package:heist_squad_x/app/data/model/room_model.dart';
import 'package:heist_squad_x/app/data/provider/auth.dart';
import 'package:heist_squad_x/app/data/service/connection_service.dart';
import 'package:heist_squad_x/app/data/service/game_socket_manager.dart';

class ChatController extends GetxController {
  final Room room;
  ChatController(this.room);

  final String nick = Auth.i.userData.nick!;

  ScrollController scrollController = ScrollController();
  TextEditingController messageController = new TextEditingController();

  RxList<Message> _messages = <Message>[].obs;

  List<Message> get messages => this._messages;
  set messages(List<Message> value) => this._messages.assignAll(value);

  @override
  void onInit() {
    Conn.connect(room.id!, onConnect: () => initSocket());
    super.onInit();
  }

  void initSocket() {
    try {
      GameSocketManager().send("JOIN_ROOM", [room.id, nick]);
      GameSocketManager().listen("RECEIVE_MESSAGE", (res) {
        Message msg = (res is String)
            ? Message(message: res, nickname: "*")
            : Message(
                roomId: res[0],
                nickname: res[1],
                message: res[2],
              );
        if (msg.nickname == Auth.i.userData.nick) {
          return;
        }

        messages.add(msg);
        try {
          scrollController.animateTo(scrollController.position.maxScrollExtent,
              duration: Duration(milliseconds: 200), curve: Curves.easeInBack);
        } catch (e) {
          print(e);
        }
      });
    } catch (e) {
      print(e);
    }
  }

  void sendMessage() {
    if (messageController.text.trim().isEmpty) return;
    try {
      GameSocketManager()
          .send("SEND_MESSAGE", [room.id, nick, messageController.text.trim()]);
      Message msg =
          Message(message: messageController.text.trim(), nickname: nick);

      messages.add(msg);
      try {
        scrollController.animateTo(scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 200), curve: Curves.easeInBack);
      } catch (e) {
        print(e);
      }

      messageController.clear();
    } catch (e) {
      print(e);
    }
  }
}

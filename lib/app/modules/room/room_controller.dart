import 'dart:async';

import 'package:bonfire/bonfire.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:heist_squad_x/app/data/model/room_model.dart';
import 'package:heist_squad_x/app/data/model/user_model.dart';
import 'package:heist_squad_x/app/data/provider/database.dart';
import 'package:heist_squad_x/app/data/service/auth_controller.dart';
import 'package:heist_squad_x/app/data/service/connection_service.dart';
import 'package:heist_squad_x/app/data/service/game_socket_manager.dart';
import 'package:heist_squad_x/app/modules/game_view/game_controller.dart';
import 'package:heist_squad_x/app/modules/game_view/game_view.dart';
import 'package:heist_squad_x/app/modules/room/chat/chat_controller.dart';

class RoomController extends GetxController {
  final Room initialRoom;
  RoomController(this.initialRoom);

  /* ***************** */

  RxBool _gameStarted = false.obs;

  bool get gameStarted => this._gameStarted.value;
  set gameStarted(bool value) => this._gameStarted.value = value;

  /* ***************** */

  Rx<Room> _room = Room().obs;

  Room get room => this._room.value;
  set room(Room value) => this._room.value = value;

  /* ***************** */

  RxBool _isLoading = false.obs;

  bool get isLoading => this._isLoading.value;
  set isLoading(bool value) => this._isLoading.value = value;

  /* ***************** */

  static RoomController get c => Get.find<RoomController>();

  StreamSubscription stream;

  UserModel get user => AuthController.c.user;

  /* ***************** */

  @override
  void onInit() {
    super.onInit();
    Get.put(Conn());
    Get.put(ChatController(this));
    room = initialRoom;
  }

  @override
  void onClose() {
    super.onClose();
    leaveRoom();
  }

  @override
  Future<void> onReady() async {
    super.onReady();

    stream = Database.streamRoom(initialRoom.id).listen((snapshot) async {
      room = Room.fromSnapshot(snapshot);
      await verifyUser();
      update();
    });
  }

  Future<void> verifyUser() async {
    if (AuthController.c.user.uid != null)
      await Database.rooms.doc(initialRoom.id).update({
        "players": FieldValue.arrayUnion([AuthController.c.user.uid])
      });
  }

  Future<void> leaveRoom() async {
    await stream.cancel();

    if (AuthController.c.user.uid != null)
      await Database.rooms.doc(initialRoom.id).update({
        "players": FieldValue.arrayRemove([AuthController.c.user.uid])
      });

    Conn.disconnectEverything();

    Get.delete<Game>(force: true);
  }

  void goGame() {
    if (GameSocketManager().connected) {
      isLoading = true;

      joinGame();
    } else {
      print('Server not connected, retrying to connect...');
      Conn.status = "Server not connected, retrying to connect...";
      // Conn.connect();
    }
  }

  void joinGame() {
    GameSocketManager().send('message', {
      'action': 'CREATE',
      'room': this.room.id,
      'data': {'nick': user.nick, 'skin': user.skinId}
    });
  }

  Future<void> start(data) async {
    if (data['data']['nick'] == user.nick) {
      GameSocketManager().cleanListeners();
      Get.put<Game>(
        Game(
          playersOn: data['data']['playersON'],
          nick: user.nick,
          playerId: data['data']['id'],
          idCharacter: user.skinId,
          position: Position(
            double.parse(data['data']['position']['x'].toString()),
            double.parse(data['data']['position']['y'].toString()),
          ),
        ),
        permanent: true,
      );

      await Get.to(
        () => GameView(this.room.id),
        preventDuplicates: true,
        transition: Transition.fade,
      );

      gameStarted = true;
    }
  }
}

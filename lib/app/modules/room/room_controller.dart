import 'dart:async';

import 'package:bonfire/bonfire.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:heist_squad_x/app/data/model/room_model.dart';
import 'package:heist_squad_x/app/data/model/user_model.dart';
import 'package:heist_squad_x/app/data/provider/auth.dart';
import 'package:heist_squad_x/app/data/provider/database.dart';
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

  final _room = Rxn<Room>();
  Room? get room => this._room.value;
  set room(Room? value) => this._room.value = value;

  /* ***************** */

  RxBool _isLoading = false.obs;
  bool get isLoading => this._isLoading.value;
  set isLoading(bool value) => this._isLoading.value = value;

  /* ***************** */

  late StreamSubscription stream;

  UserModel get userData => Auth.i.userData;

  /* ***************** */

  @override
  void onInit() {
    super.onInit();
    Get.put(Conn());
    Get.put(ChatController(initialRoom));
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

    stream = Database.streamRoom(initialRoom.id!).listen((doc) async {
      room = doc.data();
      await addUserInRoom();
      update();
    });
  }

  Future<void> addUserInRoom() async {
    if (Auth.i.userData.uid != null)
      await Database.rooms.doc(initialRoom.id).update({
        "players": FieldValue.arrayUnion([Auth.i.userData.uid])
      });
  }

  Future<void> leaveRoom() async {
    await stream.cancel();

    if (Auth.i.userData.uid != null)
      await Database.rooms.doc(initialRoom.id).update({
        "players": FieldValue.arrayRemove([Auth.i.userData.uid])
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
      'room': room?.id,
      'data': {'nick': userData.nick, 'skin': userData.skinId}
    });
  }

  Future<void> start(data) async {
    if (data['data']['nick'] == userData.nick) {
      GameSocketManager().cleanListeners();
      Get.put<Game>(
        Game(
          playersOn: data['data']['playersON'],
          nick: userData.nick,
          playerId: data['data']['id'],
          idCharacter: userData.skinId,
          position: Vector2(
            double.parse(data['data']['position']['x'].toString()),
            double.parse(data['data']['position']['y'].toString()),
          ),
        ),
        permanent: true,
      );

      await Get.to(
        () => GameView(this.room!.id!),
        preventDuplicates: true,
        transition: Transition.fade,
      );

      gameStarted = true;
    }
  }
}

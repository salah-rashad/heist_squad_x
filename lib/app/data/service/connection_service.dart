import 'package:get/get.dart';
import 'package:heist_squad_x/app/data/service/game_socket_manager.dart';
import 'package:heist_squad_x/app/modules/room/room_controller.dart';

class Conn extends GetxService {
  static Conn get c => Get.find<Conn>();

  static RxString _statusServer = "Connecting...".obs;

  static String get status => _statusServer.value;
  static set status(String value) => _statusServer.value = value;

  static void connect(String roomId, {Function onConnect}) {
    GameSocketManager().listenConnection((_) {
      status = 'CONNECTED';
      onConnect();
    });

    GameSocketManager().listenError((err) {
      if (err.toString().contains("errno = 7"))
        status =
            "ERROR: Couldn't connect to server, please check your internet connection.";
      else
        status = 'ERROR: $err';
    });

    GameSocketManager().listen('message', _listen);

    GameSocketManager().connect();
  }

  static void disconnectEverything() {
    GameSocketManager().close();
    GameSocketManager().cleanListeners();
    Conn.status = "Disconnected";
  }

  static void _listen(data) {
    if (data is Map && data['action'] == 'PLAYER_JOIN') {
      print("start game");
      RoomController.c.isLoading = false;
      RoomController.c.start(data);
    }
  }
}

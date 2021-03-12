import 'package:get/get.dart';
import 'package:heist_squad_x/app/data/service/socket_manager.dart';
import 'package:heist_squad_x/app/modules/person_select/person_select_controller.dart';

class Conn extends GetxService {
  static RxString _statusServer = "Connecting...".obs;

  static String get status => _statusServer.value;
  static set status(String value) => _statusServer.value = value;

  static void connect() {
    SocketManager().listenConnection((_) {
      status = 'CONNECTED';
    });

    SocketManager().listenError((err) {
      if (err.toString().contains("errno = 7"))
        status =
            "ERROR: Couldn't connect to server, please check your internet connection.";
      else
        status = 'ERROR: $err';
    });

    SocketManager().listen('message', _listen);

    SocketManager().connect();
  }

  static void disconnectEverything() {
    SocketManager().close();
    // SocketManager().cleanListeners();
    Conn.status = "Disconnected";
  }

  static void _listen(data) {
    if (data is Map && data['action'] == 'PLAYER_JOIN') {
      final psCtrl = Get.find<PersonSelectController>();

      psCtrl.loading = false;
      psCtrl.start(data);
    }
  }
}

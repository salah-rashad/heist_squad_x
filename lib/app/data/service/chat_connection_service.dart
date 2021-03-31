// import 'package:get/get.dart';
// import 'package:heist_squad_x/app/data/service/chat_socket_manager.dart';

// class ChatConnection extends GetxService {
//   static RxString _statusServer = "Connecting...".obs;

//   static String get status => _statusServer.value;
//   static set status(String value) => _statusServer.value = value;

//   static void connect() {
//     ChatSocketManager().listenConnection((_) {
//       status = 'CONNECTED';
//     });

//     ChatSocketManager().listenError((err) {
//       if (err.toString().contains("errno = 7"))
//         status =
//             "ERROR: Couldn't connect to server, please check your internet connection.";
//       else
//         status = 'ERROR: $err';
//     });

//     // ChatSocketManager().listen('message', _listen);

//     ChatSocketManager().connect();
//   }

//   static void disconnectEverything() {
//     ChatSocketManager().close();
//     ChatSocketManager().cleanListeners();
//     ChatConnection.status = "Disconnected";
//   }

//   // static void _listen(data) {
//   //   if (data is Map && data['action'] == 'PLAYER_JOIN') {
//   //     final psCtrl = Get.find<PersonSelectController>();

//   //     psCtrl.loading = false;
//   //     psCtrl.start(data);
//   //   }
//   // }
// }

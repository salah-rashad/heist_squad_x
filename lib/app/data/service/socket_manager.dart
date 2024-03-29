import 'package:flutter/cupertino.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

class SocketManager {
  static const LOG = 'SocketManager:';
  static final SocketManager _singleton = SocketManager._internal();
  static IO.Socket? socket;
  static String? baseUrl;
  late ValueChanged<bool> connectStatus;

  factory SocketManager() {
    return _singleton;
  }

  SocketManager._internal();

  static Future configure(String url) async {
    baseUrl = url;
    socket = IO.io(
        url,
        OptionBuilder()
            .setTransports(['websocket']) // for Flutter or Dart VM
            .disableAutoConnect() // disable auto-connection
            .build());
    socket!.on('connect', (value) {
      print('$LOG connected - $value');
    });
  }

  IO.Socket connect() {
    return socket!.connect();
  }

  void listenConnection(ValueChanged<dynamic> handler) {
    socket!.on('connect', (value) {
      print('$LOG connected');
      handler(value);
    });
  }

  void listenError(ValueChanged<dynamic> handler) {
    socket!.on('error', (value) {
      print('$LOG error - $value');
      handler(value);
    });
    socket!.on('connect_error', (value) {
      print('$LOG connect_error - $value');
      handler(value);
    });
    socket!.on('reconnect_error', (value) {
      print('$LOG reconnect_error - $value');
      handler(value);
    });
  }

  void listen(String event, ValueChanged<dynamic> handler) {
    socket!.on(event, handler);
  }

  void removeListen(String event, ValueChanged<dynamic> handler) {
    socket!.off(event, handler);
  }

  void send(String event, Map data) {
    if (connected) {
      print('$LOG send($event) - $data');
      socket!.emit(event, data);
    } else {
      print('$LOG not connected');
    }
  }

  void cleanListeners() {
    socket!.clearListeners();
  }

  void close() {
    socket!.disconnect();
  }

  bool get connected => socket!.connected;
}

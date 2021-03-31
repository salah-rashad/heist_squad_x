import 'package:get/get.dart';
import 'package:heist_squad_x/app/data/service/auth_controller.dart';
import 'package:heist_squad_x/app/data/service/connection_service.dart';

class InitialBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<Conn>(Conn());
    Get.lazyPut(() => AuthController());
  }
}

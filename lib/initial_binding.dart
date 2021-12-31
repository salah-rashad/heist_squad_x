import 'package:get/get.dart';
import 'package:heist_squad_x/app/data/provider/auth.dart';
import 'package:heist_squad_x/app/data/service/connection_service.dart';

class InitialBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(Auth(), permanent: true);
    Get.put(Conn(), permanent: true);
  }
}

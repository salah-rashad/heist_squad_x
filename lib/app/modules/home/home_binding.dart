import 'package:get/get.dart';
import 'package:heist_squad_x/app/modules/auth/login/login_controller.dart';
import 'package:heist_squad_x/app/modules/home/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<HomeController>(HomeController());
    Get.lazyPut<LoginController>(() => LoginController());
  }
}

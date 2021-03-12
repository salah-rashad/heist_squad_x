import 'package:get/get.dart';

import 'game_controller.dart';

class GameBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<Game>(Game());
  }
}

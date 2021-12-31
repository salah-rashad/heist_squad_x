import 'package:flame_splash_screen/flame_splash_screen.dart';
import 'package:get/get.dart';
import 'package:heist_squad_x/main.dart';

class SplashScreenController extends GetxController {
  late FlameSplashController splashController;

  @override
  void onInit() {
    splashController = FlameSplashController(
      fadeInDuration: 750.milliseconds,
      fadeOutDuration: 450.milliseconds,
      waitDuration: 2.seconds,
      autoStart: true,
    );

    super.onInit();
  }

  @override
  void onClose() {
    splashController.dispose();
    isSplash.value = false;
    super.onClose();
  }
}

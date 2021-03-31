import 'package:flame_splash_screen/flame_splash_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class SplashScreenController extends GetxController {
  FlameSplashController splashController;

  bool isPlaying = false;

  RxDouble paddingTop = MediaQuery.of(Get.context).viewPadding.top.obs;

  @override
  void onInit() {
    splashController = FlameSplashController(
      fadeInDuration: Duration(milliseconds: 750),
      fadeOutDuration: Duration(milliseconds: 450),
      waitDuration: Duration(seconds: 0),
      autoStart: true,
    );

    super.onInit();
  }

  @override
  void onClose() {
    splashController.dispose();
    super.onClose();
  }
}

import 'package:flame_splash_screen/flame_splash_screen.dart';
import 'package:flutter/animation.dart';
import 'package:get/get.dart';
import 'package:heist_squad_x/main.dart';

class SplashScreenController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late FlameSplashController splashController;
  late AnimationController animationController;

  @override
  void onInit() {
    super.onInit();
    animationController = AnimationController(
      vsync: this,
      duration: 1.seconds,
      animationBehavior: AnimationBehavior.preserve,
    );

    animationController.repeat(reverse: true);

    splashController = FlameSplashController(
      fadeInDuration: 750.milliseconds,
      fadeOutDuration: 450.milliseconds,
      waitDuration: 2.seconds,
      autoStart: false,
    );
  }

  @override
  void onReady() {
    super.onReady();
    splashController.start();
  }

  @override
  void onClose() {
    animationController.dispose();
    splashController.dispose();
    isSplash.value = false;
    super.onClose();
  }
}

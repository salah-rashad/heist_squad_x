import 'package:flame/flame.dart';
import 'package:flame/flame_audio.dart';
import 'package:flame_splash_screen/flame_splash_screen.dart';
import 'package:get/get.dart';
import 'package:heist_squad_x/app/data/service/connection_service.dart';

class SplashScreenController extends GetxController {
  FlameSplashController splashController;
  FlameAudio audio = FlameAudio();

  bool isPlaying = false;

  @override
  void onInit() {
    splashController = FlameSplashController(
      fadeInDuration: Duration(milliseconds: 750),
      fadeOutDuration: Duration(milliseconds: 450),
      waitDuration: Duration(seconds: 0),
      autoStart: true,
    );

    Conn.connect();

    super.onInit();
  }

  @override
  void onClose() {
    splashController.dispose();
    super.onClose();
  }

  playKeyboardTyping() {
    if (!isPlaying) {
      isPlaying = true;
      Flame.audio.play("keyboard_typing.mp3");
    }
  }
}

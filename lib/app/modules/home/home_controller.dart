import 'package:audioplayers/audioplayers.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:heist_squad_x/app/data/provider/auth.dart';

class HomeController extends GetxController {
  RxBool _bgmIsPlaying = false.obs;

  bool get bgmIsPlaying => this._bgmIsPlaying.value;
  set bgmIsPlaying(bool value) => this._bgmIsPlaying.value = value;

  @override
  Future<void> onReady() async {
    Auth.i.listenToAuthChanges();
    if (!kIsWeb) {
      await FlameAudio.bgm.play("menu_soundtrack.mp3");

      FlameAudio.bgm.audioPlayer!.onPlayerStateChanged.listen((state) {
        bgmIsPlaying = state == PlayerState.PLAYING;
        print(state);
      });
      if (FlameAudio.bgm.audioPlayer!.state == PlayerState.PLAYING) {
        bgmIsPlaying = true;
      } else {
        bgmIsPlaying = false;
      }
    }

    super.onReady();
  }

  @override
  void onClose() {
    FlameAudio.bgm.dispose();
    super.onClose();
  }
}

import 'package:flame/flame.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  RxBool _bgmIsPlaying = false.obs;

  bool get bgmIsPlaying => this._bgmIsPlaying.value;
  set bgmIsPlaying(bool value) => this._bgmIsPlaying.value = value;

  @override
  Future<void> onReady() async {
    // await Flame.bgm.play("menu_soundtrack.mp3");

    // Flame.bgm.audioPlayer.onPlayerStateChanged.listen((state) {
    //   bgmIsPlaying = state == AudioPlayerState.PLAYING;
    // });

    super.onReady();
  }

  @override
  void onClose() {
    Flame.bgm.dispose();
    super.onClose();
  }
}

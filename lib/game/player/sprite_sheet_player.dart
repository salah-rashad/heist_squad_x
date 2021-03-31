import 'package:bonfire/bonfire.dart';

class SpriteSheetPlayer {
  static SpriteSheet _create(String path) {
    return SpriteSheet(
    imageName: path,
    textureWidth: 48,
    textureHeight: 48,
    columns: 8,
    rows: 24,
  );
  }

  static SpriteSheet get player1 => _create("players/player_spritesheet.png");
  // static SpriteSheet get hero2 => _create('heroes/hero2.png');
  // static SpriteSheet get hero3 => _create('heroes/hero3.png');
  // static SpriteSheet get hero4 => _create('heroes/hero4.png');
  // static SpriteSheet get hero5 => _create('heroes/hero5.png');
}

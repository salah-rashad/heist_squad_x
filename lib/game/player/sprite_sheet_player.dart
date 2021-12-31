import 'package:bonfire/bonfire.dart';

class SpriteSheetPlayer {
  static Future<SpriteSheet> _create(String path) async {
    final Sprite sprite = await Sprite.load(path, srcSize: Vector2.all(48.0));
    return SpriteSheet.fromColumnsAndRows(
      image: sprite.image,
      columns: 8,
      rows: 24,
    );
  }

  static Future<SpriteSheet> player1() =>
      _create("players/player_spritesheet.png");
  // static SpriteSheet get hero2 => _create('heroes/hero2.png');
  // static SpriteSheet get hero3 => _create('heroes/hero3.png');
  // static SpriteSheet get hero4 => _create('heroes/hero4.png');
  // static SpriteSheet get hero5 => _create('heroes/hero5.png');
}

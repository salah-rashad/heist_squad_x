import 'package:bonfire/bonfire.dart';

class SpriteSheetHero {
  static Future<SpriteSheet> _create(String path) async {
    final Sprite sprite = await Sprite.load(path, srcSize: Vector2.all(32.0));
    return SpriteSheet.fromColumnsAndRows(
      image: sprite.image,
      columns: 3,
      rows: 8,
    );
  }

  static Future<SpriteSheet>  hero1() async => _create('heroes/hero1.png');
  static Future<SpriteSheet>  hero2() async => _create('heroes/hero2.png');
  static Future<SpriteSheet>  hero3() async => _create('heroes/hero3.png');
  static Future<SpriteSheet>  hero4() async => _create('heroes/hero4.png');
  static Future<SpriteSheet>  hero5()async => _create('heroes/hero5.png');
}

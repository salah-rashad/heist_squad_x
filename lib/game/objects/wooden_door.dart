import 'dart:ui';

import 'package:bonfire/bonfire.dart';
import 'package:heist_squad_x/game/objects/breakable.dart';
import 'package:heist_squad_x/game/utils/AxisD.dart';
import 'package:heist_squad_x/game/utils/LootableType.dart';
import 'package:heist_squad_x/game/utils/Weapon.dart';
import 'package:heist_squad_x/game/utils/game_extensions.dart';

class WoodenDoor extends Destroyable {
  double? breakTime;
  final Size hCollSize;
  final Size vCollSize;

  static const JSON_NAME = "wooden_door";

  WoodenDoor({
    Vector2? initPosition,
    AxisD? axisD,
    this.breakTime,
    double? height,
    double? width,
    required this.hCollSize,
    required this.vCollSize,
  }) : super(
          SimpleDirectionAnimation(
            idleLeft: _vertical,
            idleRight: _vertical,
            idleDown: _horizontal,
            idleUp: _horizontal,
            //
            runLeft: _vertical,
            runRight: _vertical,
            runDown: _horizontal,
            runUp: _horizontal,
            //
          ),
          Sprite.load(
              "tiled/tiles/indoor/wooden_door_${axisD?.getName()}_o.png"),
          height: height,
          width: width,
          initPosition: initPosition!,
          axisD: axisD,
          life: breakTime!,
          itemName: "Wooden Door",
          type: LType.door,
          canDestroyWeapons: [
            WeaponKey.hammer,
            WeaponKey.saw,
            WeaponKey.crowbar,
            WeaponKey.keys,
            WeaponKey.smallBomb,
            WeaponKey.largeBomb,
          ],
          hCollSize: hCollSize,
          vCollSize: vCollSize,
        );

  static Future<SpriteAnimation> get _horizontal => SpriteAnimation.load(
        "tiled/tiles/indoor/wooden_door_h.png",
        SpriteAnimationData.sequenced(
          amount: 1,
          textureSize: Vector2.all(48.0),
          stepTime: 0.1,
        ),
      );

  static Future<SpriteAnimation> get _vertical => SpriteAnimation.load(
        "tiled/tiles/indoor/wooden_door_v.png",
        SpriteAnimationData.sequenced(
          amount: 1,
          textureSize: Vector2.all(48.0),
          stepTime: 0.1,
        ),
      );
}

import 'package:bonfire/bonfire.dart';
import 'package:flutter/cupertino.dart';
import 'package:heist_squad_x/game/objects/breakable.dart';
import 'package:heist_squad_x/game/utils/AxisD.dart';
import 'package:heist_squad_x/game/utils/LootableType.dart';
import 'package:heist_squad_x/game/utils/Weapon.dart';
import 'package:heist_squad_x/game/utils/game_extensions.dart';

class Desk extends Destroyable {
  final Size hCollSize;
  final Size vCollSize;

  static const JSON_NAME = "desk";

  Desk({
    Direction? direction,
    AxisD? axisD,
    Vector2? initPosition,
    double? breakTime,
    double? height,
    double?  width ,
    required this.hCollSize,
    required this.vCollSize,
  }) : super(
          generateSDA("tiled/tiles/indoor/desk_*d*.png"),
          Sprite.load("tiled/tiles/indoor/desk_${direction!.getName()}_o.png"),
          direction: direction,
          initPosition: initPosition!,
          width: width,
          height: height,
          life: breakTime!,
          maxGain: 16,
          itemName: "Desk",
          type: LType.normal,
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
}

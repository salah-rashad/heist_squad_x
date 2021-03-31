import 'package:bonfire/bonfire.dart';
import 'package:bonfire/util/direction.dart';
import 'package:flutter/cupertino.dart';
import 'package:heist_squad_x/game/objects/breakable.dart';
import 'package:heist_squad_x/game/utils/AxisD.dart';
import 'package:heist_squad_x/game/utils/LootableType.dart';
import 'package:heist_squad_x/game/utils/Weapon.dart';
import 'package:heist_squad_x/game/utils/game_extensions.dart';
import 'package:heist_squad_x/main.dart';

class Desk extends Destroyable {
  final Direction direction;
  final AxisD axisD;
  final Position initPosition;
  final double breakTime;
  final double height;
  final double width;
  final Size hCollSize;
  final Size vCollSize;

  static const JSON_NAME = "desk";

  Desk({
    this.direction,
    this.axisD,
    this.initPosition,
    this.breakTime,
    this.height = tileSize,
    this.width = tileSize,
    this.hCollSize,
    this.vCollSize,
  }) : super(
          generateSDA("tiled/tiles/indoor/desk_*d*.png"),
          Sprite("tiled/tiles/indoor/desk_${direction.getName()}_o.png"),
          direction: direction,
          initPosition: initPosition,
          axisD: axisD,
          width: width,
          height: height,
          collision: generateFitCollision(
            direction,
            axisD,
            height,
            width,
            LType.normal,
            hCollSize: hCollSize,
            vCollSize: vCollSize,
          ),
          life: breakTime,
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
        );
}

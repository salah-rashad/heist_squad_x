import 'dart:ui';

import 'package:bonfire/bonfire.dart';
import 'package:bonfire/util/direction.dart';
import 'package:heist_squad_x/game/objects/breakable.dart';
import 'package:heist_squad_x/game/utils/AxisD.dart';
import 'package:heist_squad_x/game/utils/LootableType.dart';
import 'package:heist_squad_x/game/utils/Weapon.dart';
import 'package:heist_squad_x/game/utils/game_extensions.dart';
import 'package:heist_squad_x/main.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Cupboard extends Destroyable {
  final Direction direction;
  final AxisD axisD;
  final Position initPosition;
  final double breakTime;
  final double height;
  final double width;
  final Size hCollSize;
  final Size vCollSize;

  static const JSON_NAME = "cupboard";

  Cupboard({
    this.direction,
    this.axisD,
    this.initPosition,
    this.breakTime,
    this.height = tileSize,
    this.width = tileSize,
    this.hCollSize,
    this.vCollSize,
  }) : super(
          generateSDA("tiled/tiles/indoor/cupboard_*d*.png"),
          Sprite("tiled/tiles/indoor/cupboard_${direction.getName()}_o.png"),
          direction: direction,
          height: height,
          width: width,
          initPosition: initPosition,
          axisD: axisD,
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
          maxGain: 4,
          itemName: "Cupboard",
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

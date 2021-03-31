import 'dart:ui';

import 'package:bonfire/bonfire.dart';
import 'package:bonfire/util/direction.dart';
import 'package:flame/animation.dart';
import 'package:flutter/foundation.dart';
import 'package:heist_squad_x/game/objects/breakable.dart';
import 'package:heist_squad_x/game/utils/AxisD.dart';
import 'package:heist_squad_x/game/utils/LootableType.dart';
import 'package:heist_squad_x/game/utils/Weapon.dart';
import 'package:heist_squad_x/game/utils/game_extensions.dart';
import 'package:heist_squad_x/main.dart';

class WoodenDoor extends Destroyable {
  final Direction direction;
  final AxisD axisD;
  final Position initPosition;
  double breakTime;
  final double height;
  final double width;
  final Size hCollSize;
  final Size vCollSize;

  static const JSON_NAME = "wooden_door";

  WoodenDoor({
    this.direction,
    this.axisD,
    this.initPosition,
    this.breakTime,
    this.height = tileSize,
    this.width = tileSize,
    this.hCollSize,
    this.vCollSize,
  }) : super(
            SimpleDirectionAnimation(
              idleLeft: _vertical,
              idleRight: _vertical,
              idleBottom: _horizontal,
              idleTop: _horizontal,
              //
              runLeft: _vertical,
              runRight: _vertical,
              runBottom: _horizontal,
              runTop: _horizontal,
              //
            ),
            Sprite("tiled/tiles/indoor/wooden_door_${axisD.getName()}_o.png"),
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
              LType.door,
              hCollSize: hCollSize,
              vCollSize: vCollSize,
            ),
            life: breakTime,
            itemName: "Wooden Door",
            type: LType.door,
            canDestroyWeapons: [
              WeaponKey.hammer,
              WeaponKey.saw,
              WeaponKey.crowbar,
              WeaponKey.keys,
              WeaponKey.smallBomb,
              WeaponKey.largeBomb,
            ]);

  static Animation get _horizontal => Animation.sequenced(
        "tiled/tiles/indoor/wooden_door_h.png",
        1,
        textureHeight: 48.0,
        textureWidth: 48.0,
      );

  static Animation get _vertical => Animation.sequenced(
        "tiled/tiles/indoor/wooden_door_v.png",
        1,
        textureHeight: 48.0,
        textureWidth: 48.0,
      );
}

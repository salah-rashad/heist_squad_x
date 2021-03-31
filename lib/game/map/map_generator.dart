import 'dart:ui';

import 'package:bonfire/bonfire.dart';
import 'package:heist_squad_x/game/map/tiled_world_map.dart';
import 'package:heist_squad_x/game/objects/wooden_door.dart';
import 'package:heist_squad_x/game/objects/desk.dart';
import 'package:heist_squad_x/game/objects/cupboard.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../main.dart';

class MapGenerator {
  final Size forceTileSize;
  final bool enableServerCache;
  MapGenerator({
    this.forceTileSize = const Size(tileSize, tileSize),
    this.enableServerCache = false,
  });

  CustomTiledMap get level1 => CustomTiledMap(
        'tiled/maps/hs_level1.json',
        forceTileSize: Size(48.0.r, 48.0.r),
        enableServerCache: this.enableServerCache,
      )
        ..registerObj(
          WoodenDoor.JSON_NAME,
          (x, y, width, height, direction, axisD) => WoodenDoor(
            // direction: direction,
            axisD: axisD,
            initPosition: Position(x, y),
            height: height,
            width: width,
            breakTime: 5,
            hCollSize: Size(tileSize.r, 21.0909.r),
            vCollSize: Size(21.0909.r, tileSize.r),
          ),
        )
        ..registerObj(
          Desk.JSON_NAME,
          (x, y, width, height, direction, axisD) => Desk(
            direction: direction,
            // axisD: axisD,
            initPosition: Position(x, y),
            height: height,
            width: width,
            breakTime: 15,
            hCollSize: Size(tileSize.r, tileSize.r),
            vCollSize: Size(tileSize.r, tileSize.r),
          ),
        )
        ..registerObj(
          Cupboard.JSON_NAME,
          (x, y, width, height, direction, axisD) => Cupboard(
            direction: direction,
            // axisD: axisD,
            initPosition: Position(x, y),
            height: height,
            width: width,
            breakTime: 7,
            hCollSize: Size(tileSize.r, 20.0.r),
            vCollSize: Size(20.0.r, tileSize.r),
          ),
        );
}

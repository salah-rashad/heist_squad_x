import 'dart:ui';

import 'package:bonfire/bonfire.dart';
import 'package:heist_squad_x/game/objects/wooden_door.dart';
import 'package:heist_squad_x/game/objects/desk.dart';
import 'package:heist_squad_x/game/objects/cupboard.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heist_squad_x/game/utils/game_extensions.dart';

import '../../main.dart';

class MapGenerator {
  final Size? forceTileSize;
  final bool enableServerCache;
  MapGenerator({
    this.forceTileSize,
    this.enableServerCache = false,
  });

  TiledWorldMap get level1 => TiledWorldMap(
        'tiled/maps/hs_level1.json',
        forceTileSize: forceTileSize ?? Size(tileSize, tileSize),
        objectsBuilder: {
          WoodenDoor.JSON_NAME: (p) => WoodenDoor(
                axisD: p.type?.getAxisD(),
                initPosition: p.position,
                height: p.size.height,
                width: p.size.width,
                breakTime: 5,
                hCollSize: Size(tileSizeResponsive, 21.0909.w),
                vCollSize: Size(21.0909.w, tileSizeResponsive),
              ),
          Desk.JSON_NAME: (p) => Desk(
                direction: p.type!.getDirection(),
                initPosition: p.position,
                height: p.size.height,
                width: p.size.width,
                breakTime: 15,
                hCollSize: Size.square(tileSizeResponsive),
                vCollSize: Size.square(tileSizeResponsive),
              ),
          Cupboard.JSON_NAME: (p) => Cupboard(
                direction: p.type!.getDirection(),
                initPosition: p.position,
                height: p.size.height,
                width: p.size.width,
                breakTime: 7,
                hCollSize: Size(tileSizeResponsive, 20.0.w),
                vCollSize: Size(20.0.w, tileSizeResponsive),
              ),
        },
      );
}

import 'dart:ui';

import 'package:bonfire/bonfire.dart';
import 'package:heist_squad_x/game/objects/breakable.dart';
import 'package:heist_squad_x/game/utils/LootableType.dart';
import 'package:heist_squad_x/game/utils/Weapon.dart';
import 'package:heist_squad_x/game/utils/game_extensions.dart';

class Cupboard extends Destroyable {
  static const JSON_NAME = "cupboard";

  Cupboard({
    Direction? direction,
    Vector2? initPosition,
    double? breakTime,
    double? height,
    double? width,
    Size? hCollSize,
    Size? vCollSize,
  }) : super(
          generateSDA("tiled/tiles/indoor/cupboard_*d*.png"),
          Sprite.load(
              "tiled/tiles/indoor/cupboard_${direction?.getName()}_o.png"),
          direction: direction,
          height: height,
          width: width,
          initPosition: initPosition!,
          life: breakTime!,
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
          vCollSize: vCollSize!,
          hCollSize: hCollSize!,
        );
}

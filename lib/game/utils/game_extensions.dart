import 'dart:ui';

import 'package:bonfire/bonfire.dart';
import 'package:bonfire/util/direction.dart';
import 'package:flame/anchor.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heist_squad_x/game/player/game_player.dart';

import 'AxisD.dart';
import 'Weapon.dart';

mixin GameExtensions {}

extension DirectionExtensions on Direction {
  String getName() {
    return this.toString().replaceAll('Direction.', '');
  }

  Anchor toAnchor() {
    switch (this) {
      case Direction.left:
        return Anchor.centerLeft;
        break;
      case Direction.right:
        return Anchor.centerRight;
        break;
      case Direction.top:
        return Anchor.topCenter;
        break;
      case Direction.bottom:
        return Anchor.bottomCenter;
        break;
      case Direction.topLeft:
        return Anchor.topLeft;
        break;
      case Direction.topRight:
        return Anchor.topRight;
        break;
      case Direction.bottomLeft:
        return Anchor.bottomLeft;
        break;
      case Direction.bottomRight:
        return Anchor.bottomRight;
        break;
      default:
        return Anchor.center;
    }
  }
}

extension AxisDirectionExtensions on AxisD {
  String getName() {
    return this.toString().replaceAll('AxisD.', '');
  }
}

extension WeaponEnumExtensions on WeaponKey {
  String getName() {
    return this.toString().replaceAll('WeaponKey.', '');
  }
}

extension StringExtensions on String {
  Direction getDirection({bool nullOk = false}) {
    switch (this) {
      case 'left':
        return Direction.left;
        break;
      case 'right':
        return Direction.right;
        break;
      case 'top':
        return Direction.top;
        break;
      case 'bottom':
        return Direction.bottom;
        break;
      default:
        return nullOk ? null : Direction.left;
    }
  }

  AxisD getAxisD({bool nullOk = false}) {
    switch (this) {
      case 'h':
        return AxisD.h;
        break;
      case 'v':
        return AxisD.v;
        break;

      default:
        return nullOk ? null : AxisD.h;
    }
  }
}

extension PlayerExtensions on GamePlayer {
  bool isCloseTo(Rect rect) {
    Rect coll = this.rectCollision;

    Rect vTop = Rect.fromLTWH(
      coll.topCenter.dx,
      coll.topCenter.dy - 4.0.r,
      1.0.r, // Width
      4.0.r, // Height
    );

    Rect vBottom = Rect.fromLTWH(
      coll.bottomCenter.dx,
      coll.bottomCenter.dy,
      1.0.r, // Width
      4.0.r, // Height
    );

    Rect vRight = Rect.fromLTWH(
      coll.centerRight.dx,
      coll.centerRight.dy - 4.0.r,
      4.0.r, // Width
      1.0.r, // Height
    );

    Rect vLeft = Rect.fromLTWH(
      coll.centerLeft.dx,
      coll.centerLeft.dy,
      4.0.r, // Width
      1.0.r, // Height
    );

    if (vTop.overlaps(rect) ||
        vBottom.overlaps(rect) ||
        vRight.overlaps(rect) ||
        vLeft.overlaps(rect)) {
      return true;
    } else
      return false;
  }
}

extension TextConfigExtensions on TextConfig {
  TextStyle toTextStyle() {
    return TextStyle(
      color: this.color,
      fontSize: this.fontSize,
      fontFamily: this.fontFamily,
      height: lineHeight,
    );
  }
}

// extension SpriteSheetExtensions on SpriteSheet {
//   Animation createAnimation(int row,
//       {double stepTime, bool loop = true, int from = 0, int to}) {
//     final spriteRow = _sprites[row];

//     assert(spriteRow != null, 'There is no row for $row index');

//     to ??= spriteRow.length;

//     final spriteList = spriteRow.sublist(from, to);

//     return Animation.spriteList(
//       spriteList,
//       stepTime: stepTime,
//       loop: loop,
//     );
//   }
// }

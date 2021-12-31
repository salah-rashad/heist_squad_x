import 'dart:ui';

import 'package:bonfire/bonfire.dart';
import 'package:bonfire/util/mixins/direction_animation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heist_squad_x/game/player/game_player.dart';

import 'AxisD.dart';
import 'Weapon.dart';

mixin GameExtensions {}

extension DirectionExtensions on Direction {
  String getName() {
    var s = this.toString().replaceAll('Direction.', '');
    if (s == "down")
      return "bottom";
    else if (s == "up")
      return "top";
    else
      return s;
  }

  Anchor toAnchor() {
    switch (this) {
      case Direction.left:
        return Anchor.centerLeft;
      case Direction.right:
        return Anchor.centerRight;
      case Direction.up:
        return Anchor.topCenter;
      case Direction.down:
        return Anchor.bottomCenter;
      case Direction.upLeft:
        return Anchor.topLeft;
      case Direction.upRight:
        return Anchor.topRight;
      case Direction.downLeft:
        return Anchor.bottomLeft;
      case Direction.downRight:
        return Anchor.bottomRight;
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
  Direction getDirection() {
    switch (this) {
      case 'left':
        return Direction.left;
      case 'right':
        return Direction.right;

      case 'top':
        return Direction.up;

      case 'bottom':
        return Direction.down;
      default:
        return Direction.left;
    }
  }

  AxisD getAxisD() {
    switch (this) {
      case 'h':
        return AxisD.h;
      case 'v':
        return AxisD.v;

      default:
        return AxisD.h;
    }
  }
}

extension PlayerExtensions on GamePlayer {
  bool isCloseTo(Rect rect) {
    Rect coll = this.rectCollision.rect;

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

extension ExtDirectionAnimation on DirectionAnimation {
  SpriteAnimation? getCurrentAnimation() {
    switch (animation?.currentType ?? SimpleAnimationEnum.idleLeft) {
      case SimpleAnimationEnum.idleLeft:
        return animation?.idleLeft;
      case SimpleAnimationEnum.idleRight:
        return animation?.idleRight;
      case SimpleAnimationEnum.idleUp:
        return animation?.idleUp;
      case SimpleAnimationEnum.idleDown:
        return animation?.idleDown;
      case SimpleAnimationEnum.idleTopLeft:
        return animation?.idleUpLeft;
      case SimpleAnimationEnum.idleTopRight:
        return animation?.idleUpRight;
      case SimpleAnimationEnum.idleDownLeft:
        return animation?.idleDownLeft;
      case SimpleAnimationEnum.idleDownRight:
        return animation?.idleDownRight;
      case SimpleAnimationEnum.runUp:
        return animation?.runUp;
      case SimpleAnimationEnum.runRight:
        return animation?.runRight;
      case SimpleAnimationEnum.runDown:
        return animation?.runDown;
      case SimpleAnimationEnum.runLeft:
        return animation?.runLeft;
      case SimpleAnimationEnum.runUpLeft:
        return animation?.runUpLeft;
      case SimpleAnimationEnum.runUpRight:
        return animation?.runUpRight;
      case SimpleAnimationEnum.runDownLeft:
        return animation?.runDownLeft;
      case SimpleAnimationEnum.runDownRight:
        return animation?.runDownRight;
      case SimpleAnimationEnum.custom:
        return animation?.idleLeft;
      default:
        return animation?.idleLeft;
    }
  }
}

/* extension TextConfigExtensions on TextConfig {
  TextStyle toTextStyle() {
    return TextStyle(
      color: this.color,
      fontSize: this.fontSize,
      fontFamily: this.fontFamily,
      height: lineHeight,
    );
  }
} */

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

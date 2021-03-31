import 'dart:async';
import 'dart:ui';

import 'package:bonfire/bonfire.dart';
import 'package:bonfire/util/collision/object_collision.dart';
import 'package:flame/animation.dart' as FlameAnimation;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:heist_squad_x/app/theme/app_theme.dart';
import 'package:heist_squad_x/app/theme/color_theme.dart';
import 'package:heist_squad_x/game/interface/lootable_dialog.dart';
import 'package:heist_squad_x/game/objects/lootable.dart';
import 'package:heist_squad_x/game/player/game_player.dart';
import 'package:heist_squad_x/game/utils/AxisD.dart';
import 'package:heist_squad_x/game/utils/LootableType.dart';
import 'package:heist_squad_x/game/utils/Weapon.dart';
import 'package:heist_squad_x/game/utils/game_extensions.dart';
import 'package:heist_squad_x/game/weapon/weapon.dart';
import 'package:heist_squad_x/main.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Destroyable extends SimpleEnemy with TapGesture, ObjectCollision {
  bool isClose = false;

  int _timeLeft = 0;
  Timer destroyTimer;

  bool isBeingDestroyed = false;

  int currentGain;
  final int maxGain;

  Position initPosition;
  final double height;
  final double width;
  final SimpleDirectionAnimation animation;
  final Sprite destroyedSprite;
  final CollisionArea collision;
  final List<WeaponKey> canDestroyWeapons;

  final Direction direction;
  final AxisD axisD;
  final String itemName;
  final LType type;

  Destroyable(
    this.animation,
    this.destroyedSprite, {
    this.height = tileSize,
    this.width = tileSize,
    double life = 100,
    this.maxGain = 0,
    this.collision,
    @required this.direction,
    @required this.axisD,
    this.itemName,
    this.canDestroyWeapons,
    this.type = LType.normal,
    this.initPosition,
  }) : super(
          initPosition: initPosition.minus(Position(0, tileSize.r)),
          height: height.r,
          width: width.r,
          life: life,
          speed: tileSize.r,
          initDirection: direction,
          animation: animation,
        ) {
    setupCollision(
      CollisionConfig(
        collisions: [
          collision,
        ],
      ),
    );

    switch (axisD) {
      case AxisD.v:
        this.animation.current = this.animation.idleRight;
        break;
      case AxisD.h:
        this.animation.current = this.animation.idleTop;
        break;
    }

    switch (direction) {
      case Direction.left:
        this.animation.current = this.animation.idleLeft;
        break;
      case Direction.right:
        this.animation.current = this.animation.idleRight;
        break;
      case Direction.top:
        this.animation.current = this.animation.idleTop;
        break;
      case Direction.bottom:
        this.animation.current = this.animation.idleBottom;
        break;
      case Direction.topLeft:
        this.animation.current = this.animation.idleTopLeft;
        break;
      case Direction.topRight:
        this.animation.current = this.animation.idleTopRight;
        break;
      case Direction.bottomLeft:
        this.animation.current = this.animation.idleBottomLeft;
        break;
      case Direction.bottomRight:
        this.animation.current = this.animation.idleBottomRight;
        break;
    }
  }

  @override
  void update(double dt) {
    if (isDead) return;
    playerSight(
      onSight: (player) {
        if (player is GamePlayer) isClose = true;
      },
      notOnSight: () => isClose = false,
    );

    super.update(dt);
  }

  @override
  void render(Canvas canvas) {
    if (this.isVisibleInCamera() && isClose) {
      drawLifeBar(
        canvas,
        strokeWidth: 4,
      );
    }
    super.render(canvas);
  }

  void drawLifeBar(
    Canvas canvas, {
    bool autoPosition = true,
    bool drawInBottom = false,
    double padding = 5,
    double strokeWidth = 2,
  }) {
    padding = padding.r;
    strokeWidth = strokeWidth.r;

    if (this.position == null) return;
    double yPosition = rectCollision.top - padding;

    if (drawInBottom) {
      yPosition = rectCollision.bottom + padding;
    }

    if (autoPosition) {
      if (this.directionThatPlayerIs() == Direction.top)
        yPosition = rectCollision.bottom + padding;
      else
        yPosition = rectCollision.top - padding;
    }

    canvas.drawLine(
        Offset(position.left, yPosition),
        Offset(position.left + position.width, yPosition),
        Paint()
          ..color = Colors.black
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.fill
          ..strokeCap = StrokeCap.round);

    double currentBarLife = (life * position.width) / maxLife;

    canvas.drawLine(
        Offset(position.left, yPosition),
        Offset(position.left + currentBarLife, yPosition),
        Paint()
          ..color = _getColorLife(currentBarLife)
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.fill
          ..strokeCap = StrokeCap.round);
  }

  Color _getColorLife(double currentBarLife) {
    if (currentBarLife > width - (width / 3)) {
      return Colors.green;
    }
    if (currentBarLife > (width / 3)) {
      return Colors.yellow;
    } else {
      return Colors.red;
    }
  }

  @override
  void receiveDamage(double damage, from) {
    if (!isDead) {
      showDamage(
        1,
        config: TextConfig(
          fontSize: 22.0.sp,
          color: Palette.RED,
          fontFamily: AppTheme.appTheme.textTheme.bodyText1.fontFamily,
        ),
        // onlyUp: true,
        gravity: 0.3,
        initVelocityTop: -7,
      );
      if (life > 0) {
        this.life -= 1;
        if (life <= 0) {
          die();
        }
      }
    }
  }

  @override
  void die() {
    gameRef.add(
      AnimatedObjectOnce(
        animation: FlameAnimation.Animation.sequenced(
          "smoke_explosin.png",
          6,
          textureWidth: this.width,
          textureHeight: this.height,
        ),
        position: position,
      ),
    );
    gameRef.addGameComponent(
      GameDecorationWithCollision(
        this.destroyedSprite,
        initPosition,
        height: this.height,
        width: this.width,
        collisions: [type == LType.door ? null : collision],
      ),
    );

    if (type == LType.normal) {
      gameRef.addGameComponent(
        Lootable(
          maxGain,
          width: this.width,
          height: this.height,
          collision: this.collision,
          initPosition: this.initPosition,
          direction: this.direction,
          axisD: this.axisD,
        ),
      );
    }
    remove();
    super.die();
  }

  @override
  void onTap() {
    if (isClose) {
      GamePlayer player = gameRef.player;

      _showDialogLootable(this, player);

      switch (axisD) {
        case AxisD.h:
          if (directionThatPlayerIs() == Direction.top) {
            if (player.lastDirection == Direction.bottom) return;

            player.joystickChangeDirectional(
              JoystickDirectionalEvent(
                  directional: JoystickMoveDirectional.MOVE_DOWN),
            );
          }
          if (directionThatPlayerIs() == Direction.bottom) {
            if (player.lastDirection == Direction.top) return;

            player.joystickChangeDirectional(
              JoystickDirectionalEvent(
                  directional: JoystickMoveDirectional.MOVE_UP),
            );
          }
          break;
        case AxisD.v:
          if (directionThatPlayerIs() == Direction.right) {
            if (player.lastDirection == Direction.left) return;
            player.joystickChangeDirectional(
              JoystickDirectionalEvent(
                  directional: JoystickMoveDirectional.MOVE_DOWN),
            );
          }
          if (directionThatPlayerIs() == Direction.left) {
            if (player.lastDirection == Direction.right) return;
            player.joystickChangeDirectional(
              JoystickDirectionalEvent(
                  directional: JoystickMoveDirectional.MOVE_UP),
            );
          }
          break;
      }

      if (player.lastDirection == direction) return;

      switch (direction) {
        case Direction.left:
          if (directionThatPlayerIs() == Direction.right)
            player.joystickChangeDirectional(JoystickDirectionalEvent(
                directional: JoystickMoveDirectional.MOVE_LEFT));
          break;
        case Direction.right:
          if (directionThatPlayerIs() == Direction.left)
            player.joystickChangeDirectional(JoystickDirectionalEvent(
                directional: JoystickMoveDirectional.MOVE_RIGHT));
          break;
        case Direction.top:
          if (directionThatPlayerIs() == Direction.bottom)
            player.joystickChangeDirectional(JoystickDirectionalEvent(
                directional: JoystickMoveDirectional.MOVE_UP));
          break;
        case Direction.bottom:
          if (directionThatPlayerIs() == Direction.top)
            player.joystickChangeDirectional(JoystickDirectionalEvent(
                directional: JoystickMoveDirectional.MOVE_DOWN));
          break;
        case Direction.topLeft:
          break;
        case Direction.topRight:
          break;
        case Direction.bottomLeft:
          break;
        case Direction.bottomRight:
          break;
      }

      Future.delayed(
          Duration(milliseconds: 100),
          () => player.joystickChangeDirectional(JoystickDirectionalEvent(
              directional: JoystickMoveDirectional.IDLE)));
    }
  }

  void playerSight({
    Function(Player) onSight,
    Function() notOnSight,
  }) {
    GamePlayer player = gameRef.player;
    if (player == null || this.position == null) return;

    if (player.isDead) {
      if (notOnSight != null) notOnSight();
      return;
    }

    void checkOnSight() {
      if (onSight != null) onSight(player);
    }

    if (player.isCloseTo(this.rectCollision)) {
      switch (axisD) {
        case AxisD.h:
          if (directionThatPlayerIs() == Direction.top ||
              directionThatPlayerIs() == Direction.bottom) {
            checkOnSight();
          }
          break;
        case AxisD.v:
          if (directionThatPlayerIs() == Direction.right ||
              directionThatPlayerIs() == Direction.left) {
            checkOnSight();
          }
          break;
      }

      switch (direction) {
        case Direction.left:
          if (directionThatPlayerIs() == Direction.right) {
            checkOnSight();
          }
          break;
        case Direction.right:
          if (directionThatPlayerIs() == Direction.left) {
            checkOnSight();
          }
          break;
        case Direction.top:
          if (directionThatPlayerIs() == Direction.bottom) {
            checkOnSight();
          }
          break;
        case Direction.bottom:
          if (directionThatPlayerIs() == Direction.top) {
            checkOnSight();
          }
          break;
        case Direction.topLeft:
          break;
        case Direction.topRight:
          break;
        case Direction.bottomLeft:
          break;
        case Direction.bottomRight:
          break;
      }
    } else {
      if (notOnSight != null) notOnSight();
    }
  }

  void showDamage(
    double amount, {
    TextConfig config,
    double initVelocityTop = -5,
    double gravity = 0.5,
    double maxDownSize = 20,
    DirectionTextDamage direction = DirectionTextDamage.RANDOM,
    bool onlyUp = false,
  }) {
    gameRef.add(
      TextDamageComponent(
        "-${amount.toInt()}",
        Position(position.center.dx, position.top),
        config: config ?? TextConfig(fontSize: 14.sp, color: Colors.white),
        initVelocityTop: initVelocityTop,
        gravity: gravity,
        direction: direction,
        onlyUp: onlyUp,
        maxDownSize: maxDownSize,
      ),
    );
  }

  //! Start Destoying

  void startDestoying(GamePlayer player, WeaponKey selectedWeapon) {
    if (this.isBeingDestroyed) {
      Fluttertoast.showToast(msg: "Timer: already started");
      return;
    }
    player.playWeaponAnim(selectedWeapon);
    const oneSec = const Duration(seconds: 1);
    destroyTimer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        this.isBeingDestroyed = true;
        if (!isClose) return stopDestroying(player, timer);
        if (this.life <= 1) {
          this.receiveDamage(1, player);
          stopDestroying(player, timer);
        } else {
          this.receiveDamage(1, player);
        }

        this._timeLeft = life.toInt();
      },
    );
  }

  void stopDestroying(GamePlayer player, Timer timer) {
    timer.cancel();
    player.isLooting = false;
    this.isBeingDestroyed = false;
    player.idle(forceAddAnimation: true);
  }

  void _showDialogLootable(Destroyable destroyable, GamePlayer player) {
    if (player.isLooting &&
        destroyable.destroyTimer != null &&
        destroyable.destroyTimer.isActive) {
      destroyable.stopDestroying(player, destroyable.destroyTimer);
      return;
    }
    Get.dialog(
      LootableDialog(player, destroyable),
      barrierDismissible: true,
    );
  }
}

/// [pathWithPrefix] must be like this example: `"tiled/tiles/indoor/desk_*d*.png"`
/// while `*d*` is a [prefix] that will be replaced with the direction name.
SimpleDirectionAnimation generateSDA(
  String pathWithPrefix, {
  String prefix = "*d*",
  textureHeight: 48.0,
  textureWidth: 48.0,
}) {
  String getFinalPath(Direction d) {
    return pathWithPrefix.replaceAll(prefix, d.getName());
  }

  return SimpleDirectionAnimation(
    idleLeft: FlameAnimation.Animation.sequenced(
      getFinalPath(Direction.left),
      1,
      textureHeight: textureHeight,
      textureWidth: textureWidth,
    ),
    idleRight: FlameAnimation.Animation.sequenced(
      getFinalPath(Direction.right),
      1,
      textureHeight: textureHeight,
      textureWidth: textureWidth,
    ),
    idleBottom: FlameAnimation.Animation.sequenced(
      getFinalPath(Direction.bottom),
      1,
      textureHeight: textureHeight,
      textureWidth: textureWidth,
    ),
    idleTop: FlameAnimation.Animation.sequenced(
      getFinalPath(Direction.top),
      1,
      textureHeight: textureHeight,
      textureWidth: textureWidth,
    ),
    //
    runLeft: FlameAnimation.Animation.sequenced(
      getFinalPath(Direction.left),
      1,
      textureHeight: textureHeight,
      textureWidth: textureWidth,
    ),
    runRight: FlameAnimation.Animation.sequenced(
      getFinalPath(Direction.right),
      1,
      textureHeight: textureHeight,
      textureWidth: textureWidth,
    ),
    runBottom: FlameAnimation.Animation.sequenced(
      getFinalPath(Direction.bottom),
      1,
      textureHeight: textureHeight,
      textureWidth: textureWidth,
    ),
    runTop: FlameAnimation.Animation.sequenced(
      getFinalPath(Direction.top),
      1,
      textureHeight: textureHeight,
      textureWidth: textureWidth,
    ),
    //
  );
}

/* enum PositionAlign {
  right,
  left,
  top,
  bottom,
  center,
}

Position generatePosition(
    AxisD axisD,
    Direction direction,
    Position initPosition,
    double height,
    double width,
    Collision _hCollision,
    Collision _vCollision,
    LType type,
    {PositionAlign alignment = PositionAlign.center}) {
  double x;
  double y;
  Position finalPosition;

  Rect rect = Rect.fromCenter(
    center: Offset(initPosition.x, initPosition.y),
    height: tileSize,
    width: tileSize,
  );

  Offset hCollCenter = Offset(
    _hCollision.width * 0.5,
    _hCollision.height * 0.5,
  );

  Offset vCollCenter = Offset(
    _vCollision.width * 0.5,
    _vCollision.height * 0.5,
  );

  if (axisD == AxisD.h) {
    switch (alignment) {
      case PositionAlign.left:
        finalPosition = Position(_hCollision.width * 0.5, height * 0.5);
        finalPosition = Position(
            rect.centerLeft.dx - _hCollision.width * 0.5, rect.center.dy);
        break;
      case PositionAlign.right:
        finalPosition =
            Position(width - _hCollision.width * 0.5, rect.center.dy);
        break;
      case PositionAlign.center:
        finalPosition =
            Position(rect.center.dx, rect.center.dy + hCollCenter.dy);
        break;

      case PositionAlign.top:
        finalPosition = Position(width * 0.5, _hCollision.height);
        break;
      case PositionAlign.bottom:
        finalPosition =
            Position(width * 0.5, height - _hCollision.height * 0.5);
        break;
    }
  } else if (axisD == AxisD.v) {
    switch (alignment) {
      case PositionAlign.left:
        finalPosition = Position(_vCollision.width * 0.5, height * 0.5);
        break;
      case PositionAlign.right:
        finalPosition = Position(width - _vCollision.width * 0.5, height * 0.5);
        break;
      case PositionAlign.center:
        finalPosition = Position(width * 0.5, height * 0.5);
        break;

      case PositionAlign.top:
        finalPosition = Position(width * 0.5, _vCollision.height);
        break;
      case PositionAlign.bottom:
        finalPosition =
            Position(width * 0.5, height - _vCollision.height * 0.5);
        break;
    }
  }

  switch (direction) {
    case Direction.left:
      finalPosition = Position(width - _vCollision.width * 0.5, height * 0.5);
      break;
    case Direction.right:
      // TODO: Handle this case.
      break;
    case Direction.top:
      finalPosition = Position(rect.bottomCenter.dx, rect.bottomCenter.dy);

      break;
    case Direction.bottom:
      finalPosition = Position(rect.topCenter.dx, rect.center.dy);
      break;
    case Direction.topLeft:
      // TODO: Handle this case.
      break;
    case Direction.topRight:
      // TODO: Handle this case.
      break;
    case Direction.bottomLeft:
      // TODO: Handle this case.
      break;
    case Direction.bottomRight:
      // TODO: Handle this case.
      break;
  }

  if (axisD == AxisD.h) {
    x = initPosition.x;
    y = finalPosition.y - tileSize;
    if (type == LType.door) y += 6;
  } else if (axisD == AxisD.v) {
    // TODO: test this later
    x = (finalPosition.x) - vCollCenter.dx;
    y = finalPosition.y - tileSize;
  } else {
    x = finalPosition.x;
    y = finalPosition.y - tileSize;
  }

  return Position(x, y);
} */

CollisionArea generateFitCollision(
  Direction direction,
  AxisD axisD,
  double height,
  double width,
  LType type, {
  @required Size hCollSize,
  @required Size vCollSize,
}) {
  CollisionArea _hCollision = CollisionArea(
    width: hCollSize.width,
    height: hCollSize.height,
    align: generateAlign(
      axisD,
      direction,
      height,
      width,
      type,
      hCollSize: hCollSize,
      vCollSize: vCollSize,
    ),
  );

  CollisionArea _vCollision = CollisionArea(
    width: vCollSize.width,
    height: vCollSize.height,
    align: generateAlign(
      axisD,
      direction,
      height,
      width,
      type,
      hCollSize: hCollSize,
      vCollSize: vCollSize,
    ),
  );
  switch (axisD) {
    case AxisD.h:
      return _hCollision;
      break;
    case AxisD.v:
      return _vCollision;
      break;
  }

  switch (direction) {
    case Direction.left:
      return _vCollision;
      break;
    case Direction.right:
      return _vCollision;
      break;
    case Direction.top:
      return _hCollision;
      break;
    case Direction.bottom:
      return _hCollision;
      break;
    default:
      return _hCollision;
  }
}

Offset generateAlign(
  AxisD axisD,
  Direction direction,
  double height,
  double width,
  LType type, {
  Size hCollSize,
  Size vCollSize,
}) {
  Offset finalOffset;

  switch (axisD) {
    case AxisD.h:
      finalOffset = Offset(0, height * 0.5 - hCollSize.height * 0.5);

      if (type == LType.door)
        finalOffset = Offset(finalOffset.dx, finalOffset.dy + 2.5);
      break;
    case AxisD.v:
      finalOffset = Offset(width * 0.5 - vCollSize.width * 0.5, 0);
      if (type == LType.door)
        finalOffset = Offset(finalOffset.dx + 2.5, finalOffset.dy);
      break;
  }

  switch (direction) {
    case Direction.left:
      finalOffset = Offset(width - vCollSize.width, 0);
      break;
    case Direction.right:
      finalOffset = Offset(0, 0);
      break;
    case Direction.top:
      finalOffset = Offset(0, height - hCollSize.height);
      break;
    case Direction.bottom:
      finalOffset = Offset(0, 0);
      break;
    case Direction.topLeft:
      break;
    case Direction.topRight:
      break;
    case Direction.bottomLeft:
      break;
    case Direction.bottomRight:
      break;
  }

  return finalOffset;
}

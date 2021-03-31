import 'dart:async';
import 'dart:ui';

import 'package:bonfire/bonfire.dart';
import 'package:bonfire/util/collision/object_collision.dart';
import 'package:flame/anchor.dart';
import 'package:flame/animation.dart' as FlameAnimation;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:heist_squad_x/app/theme/app_theme.dart';
import 'package:heist_squad_x/app/theme/color_theme.dart';
import 'package:heist_squad_x/game/player/game_player.dart';
import 'package:heist_squad_x/game/utils/AxisD.dart';
import 'package:heist_squad_x/game/utils/Weapon.dart';
import 'package:heist_squad_x/game/utils/game_extensions.dart';

class Lootable extends GameDecoration with TapGesture, ObjectCollision {
  bool isClose = false;

  Timer lootTimer;

  bool isBeingLooted = false;
  bool isLooted = false;

  int currentGain;
  final int maxGain;
  final double height;
  final double width;
  final bool frontFromPlayer;
  final Position initPosition;
  final Sprite sprite;

  final Direction direction;
  final AxisD axisD;

  TextConfig _textConfig;

  Lootable(
    this.maxGain, {
    this.sprite,
    @required this.initPosition,
    @required this.height,
    @required this.width,
    this.frontFromPlayer = false,
    FlameAnimation.Animation animation,
    CollisionArea collision,
    this.direction,
    this.axisD,
  }) : super(
          height: height,
          position: initPosition,
          width: width,
          animation: animation,
          frontFromPlayer: frontFromPlayer,
          sprite: sprite,
        ) {
    currentGain = maxGain;
    _textConfig = TextConfig(
      fontSize: 12.sp,
      color: isClose ? Palette.BLUE : Palette.WHITE,
      fontFamily: AppTheme.appTheme.textTheme.bodyText1.fontFamily,
      textAlign: TextAlign.center,
    );

    setupCollision(
      CollisionConfig(
        collisions: [
          collision,
        ],
      ),
    );
  }

  @override
  void render(Canvas c) {
    super.render(c);

    if (this.isVisibleInCamera()) {
      String text = "$currentGain KG";

      _textConfig.render(
        c,
        isClose ? "Loot\n$text" : text,
        Position(
          rectCollision.center.dx,
          rectCollision.center.dy,
        ),
        anchor: isClose ? directionThatPlayerIs().toAnchor() : Anchor.center,
      );
    }
  }

  @override
  void update(double dt) {
    // if (isLooted) return;
    playerSight(
      onSight: (player) {
        if (player is GamePlayer) isClose = true;
      },
      notOnSight: () => isClose = false,
    );

    if (isClose) {
      _textConfig = _textConfig.withColor(Palette.WHITE);
    } else {
      _textConfig = _textConfig.withColor(Palette.WHITE24);
    }
    super.update(dt);
  }

  @override
  void onTap() {
    if (isClose) {
      GamePlayer player = gameRef.player;

      if (!isBeingLooted) startLooting(player);

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

  //! Start Destoying

  void startLooting(GamePlayer player) {
    if (player.load >= player.maxLoad) {
      Fluttertoast.showToast(
        msg: "You are fully loaded, empty your bag first.",
        textColor: Palette.RED,
        toastLength: Toast.LENGTH_LONG,
      );
      return;
    }

    if (this.isBeingLooted) {
      Fluttertoast.showToast(msg: "Timer: already started");
      return;
    }
    player.playWeaponAnim(WeaponKey.loot);
    const oneSec = const Duration(seconds: 1);
    lootTimer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        this.isBeingLooted = true;
        if (!isClose) return stopLooting(player, timer);
        if (player.life <= 0 ||
            player.load >= player.maxLoad - 1 ||
            this.currentGain <= 1) {
          this.loot(1, player);
          stopLooting(player, timer);
        } else {
          this.loot(1, player);
        }

        // this._timeLeft = currentGain.toInt();
      },
    );
  }

  void stopLooting(GamePlayer player, Timer timer) {
    timer.cancel();
    player.isLooting = false;
    this.isBeingLooted = false;
    player.idle(forceAddAnimation: true);
  }

  void loot(int amount, GamePlayer player) {
    if (!isLooted) {
      showLoot(amount,
          config: TextConfig(
            fontSize: 22.0.sp,
            color: Palette.GREEN,
            fontFamily: AppTheme.appTheme.textTheme.bodyText1.fontFamily,
          ),
          // onlyUp: true,
          gravity: 0.3,
          initVelocityTop: -7,
          onlyUp: true);
      if (currentGain > 0) {
        this.currentGain -= amount;
        player.increaseLoad(amount);
        if (currentGain <= 0) {
          isLooted = true;
          remove();
        }
      }
    }
  }

  void showLoot(
    int amount, {
    TextConfig config,
    double initVelocityTop = -5,
    double gravity = 0.5,
    double maxDownSize = 20,
    DirectionTextDamage direction = DirectionTextDamage.RANDOM,
    bool onlyUp = false,
  }) {
    gameRef.add(
      TextDamageComponent(
        "+${amount.toInt()}",
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
}

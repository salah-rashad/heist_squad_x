import 'dart:async';

import 'package:bonfire/bonfire.dart' hide Timer;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:heist_squad_x/app/theme/app_theme.dart';
import 'package:heist_squad_x/app/theme/color_theme.dart';
import 'package:heist_squad_x/game/objects/breakable.dart';
import 'package:heist_squad_x/game/player/game_player.dart';
import 'package:heist_squad_x/game/utils/AxisD.dart';
import 'package:heist_squad_x/game/utils/LootableType.dart';
import 'package:heist_squad_x/game/utils/Weapon.dart';
import 'package:heist_squad_x/game/utils/game_extensions.dart';

class Lootable extends GameDecoration with TapGesture, ObjectCollision {
  bool isClose = false;

  Timer? lootTimer;

  bool isBeingLooted = false;
  bool isLooted = false;

  int? currentGain;
  final int? maxGain;
  final double height;
  final double width;
  final Vector2 initPosition;
  final Sprite? sprite;

  final Direction? direction;
  final AxisD? axisD;

  final Size hCollSize;
  final Size vCollSize;

  TextPaint? _textPaint;

  Lootable(
    this.maxGain, {
    this.sprite,
    required this.initPosition,
    required this.height,
    required this.width,
    SpriteAnimation? animation,
    CollisionArea? collision,
    this.direction,
    this.axisD,
    required this.hCollSize,
    required this.vCollSize,
  }) : super(
          height: height,
          position: initPosition,
          width: width,
          animation: animation,
          sprite: sprite,
        ) {
    currentGain = maxGain;
    _textPaint = TextPaint(
      style: TextStyle(
        fontSize: 12.sp,
        color: isClose ? Palette.BLUE : Palette.WHITE,
        fontFamily: AppTheme.appTheme.textTheme.bodyText1!.fontFamily,
      ),
      // textAlign: TextAlign.center,
    );

    setupCollision(
      CollisionConfig(
        collisions: [
          generateFitCollision(
            direction!,
            axisD!,
            height,
            width,
            LType.normal,
            hCollSize: hCollSize,
            vCollSize: vCollSize,
          ),
        ],
      ),
    );
  }

  @override
  void render(Canvas c) {
    super.render(c);

    if (isVisible) {
      String text = "$currentGain KG";

      _textPaint?.render(
        c,
        isClose ? "Loot\n$text" : text,
        Vector2(
          rectCollision.center.dx,
          rectCollision.center.dy,
        ),
        anchor: isClose ? directionThePlayerIsIn()!.toAnchor() : Anchor.center,
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
      _textPaint =
          _textPaint?.copyWith((style) => style.copyWith(color: Palette.WHITE));
    } else {
      _textPaint = _textPaint
          ?.copyWith((style) => style.copyWith(color: Palette.WHITE24));
    }
    super.update(dt);
  }

  @override
  void onTap() {
    if (isClose) {
      GamePlayer? player = gameRef.player as GamePlayer?;

      if (!isBeingLooted) startLooting(player!);

      switch (axisD) {
        case AxisD.h:
          if (directionThePlayerIsIn() == Direction.up) {
            if (player?.lastDirection == Direction.down) return;

            player?.joystickChangeDirectional(
              JoystickDirectionalEvent(
                  directional: JoystickMoveDirectional.MOVE_DOWN),
            );
          }
          if (directionThePlayerIsIn() == Direction.down) {
            if (player?.lastDirection == Direction.up) return;

            player?.joystickChangeDirectional(
              JoystickDirectionalEvent(
                  directional: JoystickMoveDirectional.MOVE_UP),
            );
          }
          break;
        default:
          if (directionThePlayerIsIn() == Direction.right) {
            if (player!.lastDirection == Direction.left) return;
            player.joystickChangeDirectional(
              JoystickDirectionalEvent(
                  directional: JoystickMoveDirectional.MOVE_DOWN),
            );
          }
          if (directionThePlayerIsIn() == Direction.left) {
            if (player!.lastDirection == Direction.right) return;
            player.joystickChangeDirectional(
              JoystickDirectionalEvent(
                  directional: JoystickMoveDirectional.MOVE_UP),
            );
          }
          break;
      }

      if (player!.lastDirection == direction) return;

      switch (direction) {
        case Direction.right:
          if (directionThePlayerIsIn() == Direction.left)
            player.joystickChangeDirectional(JoystickDirectionalEvent(
                directional: JoystickMoveDirectional.MOVE_RIGHT));
          break;
        case Direction.down:
          if (directionThePlayerIsIn() == Direction.down)
            player.joystickChangeDirectional(JoystickDirectionalEvent(
                directional: JoystickMoveDirectional.MOVE_UP));
          break;
        case Direction.up:
          if (directionThePlayerIsIn() == Direction.up)
            player.joystickChangeDirectional(JoystickDirectionalEvent(
                directional: JoystickMoveDirectional.MOVE_DOWN));
          break;
        case Direction.upLeft:
          break;
        case Direction.upRight:
          break;
        case Direction.downLeft:
          break;
        case Direction.downRight:
          break;
        default:
          if (directionThePlayerIsIn() == Direction.right)
            player.joystickChangeDirectional(JoystickDirectionalEvent(
                directional: JoystickMoveDirectional.MOVE_LEFT));
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
    if (player.load >= player.maxLoad!) {
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
            player.load >= player.maxLoad! - 1 ||
            this.currentGain! <= 1) {
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
    player.idle();
  }

  void loot(int amount, GamePlayer player) {
    if (!isLooted) {
      showLoot(amount,
          config: TextStyle(
            fontSize: 22.0.sp,
            color: Palette.GREEN,
            fontFamily: AppTheme.appTheme.textTheme.bodyText1?.fontFamily,
          ),
          // onlyUp: true,
          gravity: 0.3,
          initVelocityTop: -7,
          onlyUp: true);
      if (currentGain != null && currentGain! > 0) {
        currentGain = currentGain! - amount;
        player.increaseLoad(amount);
        if (currentGain! <= 0) {
          isLooted = true;
          remove(this);
        }
      }
    }
  }

  void showLoot(
    int amount, {
    TextStyle? config,
    double initVelocityTop = -5,
    double gravity = 0.5,
    double maxDownSize = 20,
    DirectionTextDamage direction = DirectionTextDamage.RANDOM,
    bool onlyUp = false,
  }) {
    gameRef.add(
      TextDamageComponent(
        "+${amount.toInt()}",
        Vector2(position.center.dx, position.top),
        config: config ?? TextStyle(fontSize: 14.sp, color: Colors.white),
        initVelocityTop: initVelocityTop,
        gravity: gravity,
        direction: direction,
        onlyUp: onlyUp,
        maxDownSize: maxDownSize,
      ),
    );
  }

  void playerSight({
    Function(Player)? onSight,
    Function()? notOnSight,
  }) {
    GamePlayer? player = (gameRef.player as GamePlayer?);
    if (player == null) return;

    if (player.isDead) {
      if (notOnSight != null) notOnSight();
      return;
    }

    void checkOnSight() {
      if (onSight != null) onSight(player);
    }

    if (player.isCloseTo(this.rectCollision.rect)) {
      switch (axisD) {
        case AxisD.h:
          if (directionThePlayerIsIn() == Direction.up ||
              directionThePlayerIsIn() == Direction.down) {
            checkOnSight();
          }
          break;
        default:
          if (directionThePlayerIsIn() == Direction.right ||
              directionThePlayerIsIn() == Direction.left) {
            checkOnSight();
          }
          break;
      }

      switch (direction) {
        case Direction.right:
          if (directionThePlayerIsIn() == Direction.left) {
            checkOnSight();
          }
          break;
        case Direction.up:
          if (directionThePlayerIsIn() == Direction.down) {
            checkOnSight();
          }
          break;
        case Direction.down:
          if (directionThePlayerIsIn() == Direction.up) {
            checkOnSight();
          }
          break;
        case Direction.upLeft:
          break;
        case Direction.upRight:
          break;
        case Direction.downLeft:
          break;
        case Direction.downRight:
          break;
        default:
          if (directionThePlayerIsIn() == Direction.right) {
            checkOnSight();
          }
          break;
      }
    } else {
      if (notOnSight != null) notOnSight();
    }
  }

  @override
  void onTapCancel() {}

  @override
  void onTapDown(int pointer, Offset position) {}

  @override
  void onTapUp(int pointer, Offset position) {}
}

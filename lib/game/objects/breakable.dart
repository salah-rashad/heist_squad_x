import 'dart:async';

import 'package:bonfire/bonfire.dart' hide Timer;
import 'package:bonfire/tiled/model/tiled_object_properties.dart';
import 'package:flutter/material.dart' hide Animation;
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
import 'package:heist_squad_x/main.dart';

class Destroyable extends SimpleEnemy with TapGesture, ObjectCollision {
  bool isClose = false;

  Timer? destroyTimer;

  bool isBeingDestroyed = false;

  int? currentGain;
  final int? maxGain;

  Vector2 initPosition;
  final SimpleDirectionAnimation animation;
  final Future<Sprite>? destroyedSprite;
  final List<WeaponKey>? canDestroyWeapons;

  final Direction? direction;
  final AxisD? axisD;
  final String? itemName;
  final LType? type;

  final Size hCollSize;
  final Size vCollSize;

  List<CollisionArea>? get collisions => collisionConfig?.collisions.toList();

  Destroyable(
    this.animation,
    this.destroyedSprite, {
    double? height,
    double? width,
    double life = 100,
    this.maxGain = 0,
    this.direction,
    this.axisD,
    this.itemName,
    this.canDestroyWeapons,
    this.type = LType.normal,
    required this.initPosition,
    required this.hCollSize,
    required this.vCollSize,
  }) : super(
          position: initPosition..sub(Vector2(0, tileSizeResponsive)),
          height: height ?? tileSizeResponsive,
          width: width ?? tileSizeResponsive,
          life: life,
          speed: tileSize,
          initDirection: direction!,
          animation: animation,
        ) {
    setupCollision(
      CollisionConfig(
        collisions: [
          generateFitCollision(
            direction!,
            axisD!,
            height ?? tileSizeResponsive,
            width ?? tileSizeResponsive,
            type!,
            hCollSize: hCollSize,
            vCollSize: vCollSize,
          ),
        ],
      ),
    );

    switch (axisD) {
      case AxisD.v:
        animation.play(SimpleAnimationEnum.idleRight);
        break;
      case AxisD.h:
        animation.play(SimpleAnimationEnum.idleUp);
        break;
      default:
        animation.play(SimpleAnimationEnum.idleRight);
    }

    switch (direction) {
      case Direction.left:
        animation.playOnce(animation.idleLeft!.asFuture());
        break;
      case Direction.right:
        animation.playOnce(animation.idleRight!.asFuture());
        break;
      case Direction.up:
        animation.playOnce(animation.idleUp!.asFuture());
        break;
      case Direction.down:
        animation.playOnce(animation.idleDown!.asFuture());
        break;
      case Direction.upLeft:
        animation.playOnce(animation.idleUpLeft!.asFuture());
        break;
      case Direction.upRight:
        animation.playOnce(animation.idleUpRight!.asFuture());
        break;
      case Direction.downLeft:
        animation.playOnce(animation.idleDownLeft!.asFuture());
        break;
      case Direction.downRight:
        animation.playOnce(animation.idleDownRight!.asFuture());
        break;

      default:
        animation.playOnce(animation.idleLeft!.asFuture());
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
    if (isVisible && isClose) {
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

    double yPosition = rectCollision.top - padding;

    if (drawInBottom) {
      yPosition = rectCollision.bottom + padding;
    }

    if (autoPosition) {
      if (this.directionThePlayerIsIn() == Direction.up)
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
        config: TextStyle(
          fontSize: 22.0.sp,
          color: Palette.RED,
          fontFamily: AppTheme.appTheme.textTheme.bodyText1!.fontFamily,
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
        animation: SpriteAnimation.load(
          "smoke_explosin.png",
          SpriteAnimationData.sequenced(
            amount: 6,
            stepTime: 0.1,
            textureSize: this.vectorPosition,
          ),
        ),
        position: position,
      ),
    );

    gameRef.add(
      GameDecorationWithCollision.withSprite(
        destroyedSprite!,
        initPosition,
        height: this.height,
        width: this.width,
        collisions: type == LType.door ? null : collisions,
      ),
    );

    if (type == LType.normal) {
      gameRef.add(
        Lootable(
          maxGain,
          width: this.width,
          height: this.height,
          collision: this.collisions![0],
          initPosition: this.initPosition,
          direction: this.direction,
          axisD: this.axisD,
          vCollSize: vCollSize,
          hCollSize: hCollSize,
        ),
      );
    }
    remove(this);
    super.die();
  }

  @override
  void onTap() {
    if (isClose) {
      GamePlayer? player = gameRef.player as GamePlayer?;

      _showDialogLootable(this, player!);

      switch (axisD) {
        case AxisD.h:
          if (directionThePlayerIsIn() == Direction.up) {
            if (player.lastDirection == Direction.down) return;

            player.joystickChangeDirectional(
              JoystickDirectionalEvent(
                  directional: JoystickMoveDirectional.MOVE_DOWN),
            );
          }
          if (directionThePlayerIsIn() == Direction.down) {
            if (player.lastDirection == Direction.up) return;

            player.joystickChangeDirectional(
              JoystickDirectionalEvent(
                  directional: JoystickMoveDirectional.MOVE_UP),
            );
          }
          break;
        default:
          if (directionThePlayerIsIn() == Direction.right) {
            if (player.lastDirection == Direction.left) return;
            player.joystickChangeDirectional(
              JoystickDirectionalEvent(
                  directional: JoystickMoveDirectional.MOVE_DOWN),
            );
          }
          if (directionThePlayerIsIn() == Direction.left) {
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
        case Direction.right:
          if (directionThePlayerIsIn() == Direction.left)
            player.joystickChangeDirectional(JoystickDirectionalEvent(
                directional: JoystickMoveDirectional.MOVE_RIGHT));
          break;
        case Direction.up:
          if (directionThePlayerIsIn() == Direction.down)
            player.joystickChangeDirectional(JoystickDirectionalEvent(
                directional: JoystickMoveDirectional.MOVE_UP));
          break;
        case Direction.down:
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

  void playerSight({
    Function(Player)? onSight,
    Function()? notOnSight,
  }) {
    GamePlayer? player = gameRef.player as GamePlayer?;
    if (player == null) return;

    if (player.isDead) {
      if (notOnSight != null) notOnSight();
      return;
    }

    void checkOnSight() {
      if (onSight != null) onSight(player);
    }

    if (player.isCloseTo(this.collisions![0].rect)) {
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

  void showDamage(
    double amount, {
    TextStyle? config,
    double initVelocityTop = -5,
    double gravity = 0.5,
    double maxDownSize = 20,
    DirectionTextDamage direction = DirectionTextDamage.RANDOM,
    bool onlyUp = false,
  }) {
    gameRef.add(
      TextDamageComponent(
        "-${amount.toInt()}",
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
      },
    );
  }

  void stopDestroying(GamePlayer player, Timer timer) {
    timer.cancel();
    player.isLooting = false;
    this.isBeingDestroyed = false;
    player.idle();
  }

  void _showDialogLootable(Destroyable destroyable, GamePlayer player) {
    if (player.isLooting &&
        destroyable.destroyTimer != null &&
        destroyable.destroyTimer!.isActive) {
      destroyable.stopDestroying(player, destroyable.destroyTimer!);
      return;
    }
    Get.dialog(
      LootableDialog(player, destroyable),
      barrierDismissible: true,
    );
  }

  @override
  void onTapCancel() {
    // TODO: implement onTapCancel
  }

  @override
  void onTapDown(int pointer, Offset position) {
    // TODO: implement onTapDown
  }

  @override
  void onTapUp(int pointer, Offset position) {
    // TODO: implement onTapUp
  }
}

/// [pathWithPrefix] must be like this example: `"tiled/tiles/indoor/desk_*d*.png"`
/// while `*d*` is a [prefix] that will be replaced with the direction name.
SimpleDirectionAnimation generateSDA(
  String pathWithPrefix, {
  String prefix = "*d*",
  double textureHeight = 48.0,
  double textureWidth = 48.0,
}) {
  String getFinalPath(Direction d) {
    return pathWithPrefix.replaceAll(prefix, d.getName());
  }

  return SimpleDirectionAnimation(
    idleLeft: SpriteAnimation.load(
      getFinalPath(Direction.left),
      SpriteAnimationData.sequenced(
        amount: 1,
        textureSize: Vector2(textureWidth, textureHeight),
        stepTime: 0.1,
      ),
    ),
    idleRight: SpriteAnimation.load(
      getFinalPath(Direction.right),
      SpriteAnimationData.sequenced(
        amount: 1,
        textureSize: Vector2(textureWidth, textureHeight),
        stepTime: 0.1,
      ),
    ),
    idleDown: SpriteAnimation.load(
      getFinalPath(Direction.down),
      SpriteAnimationData.sequenced(
        amount: 1,
        textureSize: Vector2(textureWidth, textureHeight),
        stepTime: 0.1,
      ),
    ),
    idleUp: SpriteAnimation.load(
      getFinalPath(Direction.up),
      SpriteAnimationData.sequenced(
        amount: 1,
        textureSize: Vector2(textureWidth, textureHeight),
        stepTime: 0.1,
      ),
    ),
    //
    runLeft: SpriteAnimation.load(
      getFinalPath(Direction.left),
      SpriteAnimationData.sequenced(
        amount: 1,
        textureSize: Vector2(textureWidth, textureHeight),
        stepTime: 0.1,
      ),
    ),
    runRight: SpriteAnimation.load(
      getFinalPath(Direction.right),
      SpriteAnimationData.sequenced(
        amount: 1,
        textureSize: Vector2(textureWidth, textureHeight),
        stepTime: 0.1,
      ),
    ),
    runDown: SpriteAnimation.load(
      getFinalPath(Direction.down),
      SpriteAnimationData.sequenced(
        amount: 1,
        textureSize: Vector2(textureWidth, textureHeight),
        stepTime: 0.1,
      ),
    ),
    runUp: SpriteAnimation.load(
      getFinalPath(Direction.left),
      SpriteAnimationData.sequenced(
        amount: 1,
        textureSize: Vector2(textureWidth, textureHeight),
        stepTime: 0.1,
      ),
    ),
    //
  );
}

CollisionArea generateFitCollision(
  Direction? direction,
  AxisD? axisD,
  double height,
  double width,
  LType type, {
  required Size hCollSize,
  required Size vCollSize,
}) {
  CollisionArea _hCollision = CollisionArea.rectangle(
    size: Size(hCollSize.width, hCollSize.height),
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

  CollisionArea _vCollision = CollisionArea.rectangle(
    size: Size(vCollSize.width, vCollSize.height),
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

  if (axisD != null) {
    switch (axisD) {
      case AxisD.h:
        return _hCollision;

      case AxisD.v:
        return _vCollision;
    }
  } else {
    switch (direction) {
      case Direction.left:
        return _vCollision;
      case Direction.right:
        return _vCollision;
      case Direction.up:
        return _hCollision;
      case Direction.down:
        return _hCollision;
      default:
        return _hCollision;
    }
  }
}

Vector2 generateAlign(
  AxisD? axisD,
  Direction? direction,
  double height,
  double width,
  LType type, {
  Size? hCollSize,
  Size? vCollSize,
}) {
  Vector2 finalOffset;

  switch (axisD) {
    case AxisD.h:
      finalOffset = Vector2(0, height * 0.5 - hCollSize!.height * 0.5);

      if (type == LType.door)
        finalOffset = Vector2(finalOffset.x, finalOffset.y + 2.5);
      break;
    default:
      finalOffset = Vector2(width * 0.5 - vCollSize!.width * 0.5, 0);
      if (type == LType.door)
        finalOffset = Vector2(finalOffset.x + 2.5, finalOffset.y);
      break;
  }

  switch (direction) {
    case Direction.right:
      finalOffset = Vector2(0, 0);
      break;
    case Direction.up:
      finalOffset = Vector2(0, height - hCollSize!.height);
      break;
    case Direction.down:
      finalOffset = Vector2(0, 0);
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
      finalOffset = Vector2(width - vCollSize!.width, 0);
      break;
  }

  return finalOffset;
}

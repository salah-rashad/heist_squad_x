import 'dart:ui';

import 'package:bonfire/bonfire.dart' hide TiledWorldMap;
import 'package:bonfire/util/collision/object_collision.dart';
import 'package:flame/animation.dart' as FlameAnimation;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:heist_squad_x/app/data/service/game_socket_manager.dart';
import 'package:heist_squad_x/app/theme/app_theme.dart';
import 'package:heist_squad_x/app/theme/color_theme.dart';
import 'package:heist_squad_x/game/objects/breakable.dart';
import 'package:heist_squad_x/game/utils/Weapon.dart';
import 'package:heist_squad_x/game/utils/game_extensions.dart';
import 'package:heist_squad_x/main.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flame/anchor.dart';
import 'other_anim.dart';

class GamePlayer extends SimplePlayer with Lighting, ObjectCollision {
  final Position initPosition;
  final int id;
  final String nick;
  double load = 0.0;
  double maxLoad = 20.0;
  JoystickMoveDirectional currentDirection;
  String directionEvent = 'IDLE';
  String lastActionAnim;
  String currentRoomId;
  bool isLooting = false;
  List<Destroyable> lootables = <Destroyable>[];
  final List<WeaponKey> weapons;
  List<Destroyable> closeLootables;

  TextConfig _textConfig;

  bool isMainPlayer = false;

  GamePlayer({
    this.id,
    this.nick,
    this.initPosition,
    this.currentRoomId,
    this.weapons,
    this.maxLoad,
    @required SpriteSheet spriteSheet,
  }) : super(
          animation: SimpleDirectionAnimation(
            idleBottom:
                spriteSheet.createAnimation(1, stepTime: 0.1, from: 5, to: 6),
            idleLeft:
                spriteSheet.createAnimation(0, stepTime: 0.1, from: 1, to: 2),
            idleRight:
                spriteSheet.createAnimation(1, stepTime: 0.1, from: 1, to: 2),
            idleTop:
                spriteSheet.createAnimation(0, stepTime: 0.1, from: 5, to: 6),
            runBottom:
                spriteSheet.createAnimation(1, stepTime: 0.1, from: 4, to: 8),
            runLeft:
                spriteSheet.createAnimation(0, stepTime: 0.1, from: 0, to: 4),
            runRight:
                spriteSheet.createAnimation(1, stepTime: 0.1, from: 0, to: 4),
            runTop:
                spriteSheet.createAnimation(0, stepTime: 0.1, from: 4, to: 8),
            others: {
              ActionAnim.LootRight: spriteSheet.createAnimation(21,
                  stepTime: 0.1, from: 1, to: 4),
              ActionAnim.LootLeft: spriteSheet.createAnimation(20,
                  stepTime: 0.1, from: 1, to: 4),
              ActionAnim.LootTop: spriteSheet.createAnimation(20,
                  stepTime: 0.1, from: 5, to: 8),
              ActionAnim.LootBottom: spriteSheet.createAnimation(21,
                  stepTime: 0.1, from: 5, to: 8),
              /////////////////////////
              ActionAnim.CrowbarRight: spriteSheet.createAnimation(17,
                  stepTime: 0.1, from: 1, to: 4),
              ActionAnim.CrowbarLeft: spriteSheet.createAnimation(16,
                  stepTime: 0.1, from: 1, to: 4),
              ActionAnim.CrowbarTop: spriteSheet.createAnimation(16,
                  stepTime: 0.1, from: 5, to: 8),
              ActionAnim.CrowbarBottom: spriteSheet.createAnimation(17,
                  stepTime: 0.1, from: 5, to: 8),
              /////////////////////////
              ActionAnim.HammerRight:
                  spriteSheet.createAnimation(5, stepTime: 0.1, from: 0, to: 4),
              ActionAnim.HammerLeft:
                  spriteSheet.createAnimation(4, stepTime: 0.1, from: 0, to: 4),
              ActionAnim.HammerTop:
                  spriteSheet.createAnimation(4, stepTime: 0.1, from: 4, to: 8),
              ActionAnim.HammerBottom:
                  spriteSheet.createAnimation(5, stepTime: 0.1, from: 4, to: 8),
              /////////////////////////
              ActionAnim.KeysRight:
                  spriteSheet.createAnimation(7, stepTime: 0.1, from: 0, to: 4),
              ActionAnim.KeysLeft:
                  spriteSheet.createAnimation(6, stepTime: 0.1, from: 0, to: 4),
              ActionAnim.KeysTop:
                  spriteSheet.createAnimation(6, stepTime: 0.1, from: 4, to: 8),
              ActionAnim.KeysBottom:
                  spriteSheet.createAnimation(7, stepTime: 0.1, from: 4, to: 8),
              /////////////////////////
              ActionAnim.KnifeRight:
                  spriteSheet.createAnimation(9, stepTime: 0.1, from: 0, to: 4),
              ActionAnim.KnifeLeft:
                  spriteSheet.createAnimation(8, stepTime: 0.1, from: 0, to: 4),
              ActionAnim.KnifeTop:
                  spriteSheet.createAnimation(8, stepTime: 0.1, from: 4, to: 8),
              ActionAnim.KnifeBottom:
                  spriteSheet.createAnimation(9, stepTime: 0.1, from: 4, to: 8),
              /////////////////////////
              ActionAnim.DrillRight: spriteSheet.createAnimation(11,
                  stepTime: 0.1, from: 0, to: 4),
              ActionAnim.DrillLeft: spriteSheet.createAnimation(10,
                  stepTime: 0.1, from: 0, to: 4),
              ActionAnim.DrillTop: spriteSheet.createAnimation(10,
                  stepTime: 0.1, from: 4, to: 8),
              ActionAnim.DrillBottom: spriteSheet.createAnimation(11,
                  stepTime: 0.1, from: 4, to: 8),
              /////////////////////////
              ActionAnim.OscillatorRight: spriteSheet.createAnimation(13,
                  stepTime: 0.1, from: 0, to: 4),
              ActionAnim.OscillatorLeft: spriteSheet.createAnimation(12,
                  stepTime: 0.1, from: 0, to: 4),
              ActionAnim.OscillatorTop: spriteSheet.createAnimation(12,
                  stepTime: 0.1, from: 4, to: 8),
              ActionAnim.OscillatorBottom: spriteSheet.createAnimation(13,
                  stepTime: 0.1, from: 4, to: 8),
              /////////////////////////
              ActionAnim.ComputerRight: spriteSheet.createAnimation(15,
                  stepTime: 0.1, from: 0, to: 4),
              ActionAnim.ComputerLeft: spriteSheet.createAnimation(14,
                  stepTime: 0.1, from: 0, to: 4),
              ActionAnim.ComputerTop: spriteSheet.createAnimation(14,
                  stepTime: 0.1, from: 4, to: 8),
              ActionAnim.ComputerBottom: spriteSheet.createAnimation(15,
                  stepTime: 0.1, from: 4, to: 8),
              /////////////////////////
              ActionAnim.SawRight: spriteSheet.createAnimation(19,
                  stepTime: 0.1, from: 0, to: 4),
              ActionAnim.SawLeft: spriteSheet.createAnimation(18,
                  stepTime: 0.1, from: 0, to: 4),
              ActionAnim.SawTop: spriteSheet.createAnimation(18,
                  stepTime: 0.1, from: 4, to: 8),
              ActionAnim.SawBottom: spriteSheet.createAnimation(19,
                  stepTime: 0.1, from: 4, to: 8),
              /////////////////////////
              ActionAnim.PliersRight: spriteSheet.createAnimation(23,
                  stepTime: 0.1, from: 0, to: 4),
              ActionAnim.PliersLeft: spriteSheet.createAnimation(22,
                  stepTime: 0.1, from: 0, to: 4),
              ActionAnim.PliersTop: spriteSheet.createAnimation(22,
                  stepTime: 0.1, from: 4, to: 8),
              ActionAnim.PliersBottom: spriteSheet.createAnimation(23,
                  stepTime: 0.1, from: 4, to: 8),
            },
          ),
          width: tileSize.r,
          height: tileSize.r,
          initPosition: initPosition,
          life: 100,
          speed: tileSize.r * 3,
        ) {
    _textConfig = TextConfig(
      fontSize: tileSize.r / 4,
      color: Palette.WHITE,
      fontFamily: AppTheme.appTheme.textTheme.bodyText1.fontFamily,
      textAlign: TextAlign.center,
    );

    setupCollision(
      CollisionConfig(
        collisions: [
          CollisionArea(
            height: (tileSize.r * 0.7),
            width: (tileSize.r * 0.7),
            align: Offset(tileSize.r * 0.17, tileSize.r * 0.12),
          ),
        ],
      ),
    );
  }

  void increaseLoad(int amount) {
    load += amount;
    if (load >= maxLoad) {
      load = maxLoad;
    }
  }

  void decrementLoad(int amount) {
    load -= amount;
    if (amount <= 0) {
      load = 0;
    }
  }

  @override
  void update(double dt) {
    if (isDead) return;
    super.update(dt);
  }

  @override
  void joystickChangeDirectional(JoystickDirectionalEvent event) {
    if (event.directional != currentDirection && position != null) {
      currentDirection = event.directional;
      switch (currentDirection) {
        case JoystickMoveDirectional.MOVE_UP:
          directionEvent = 'UP';
          break;
        case JoystickMoveDirectional.MOVE_UP_LEFT:
          directionEvent = 'UP_LEFT';
          break;
        case JoystickMoveDirectional.MOVE_UP_RIGHT:
          directionEvent = 'UP_RIGHT';
          break;
        case JoystickMoveDirectional.MOVE_RIGHT:
          directionEvent = 'RIGHT';
          break;
        case JoystickMoveDirectional.MOVE_DOWN:
          directionEvent = 'DOWN';
          break;
        case JoystickMoveDirectional.MOVE_DOWN_RIGHT:
          directionEvent = 'DOWN_RIGHT';
          break;
        case JoystickMoveDirectional.MOVE_DOWN_LEFT:
          directionEvent = 'DOWN_LEFT';
          break;
        case JoystickMoveDirectional.MOVE_LEFT:
          directionEvent = 'LEFT';
          break;
        case JoystickMoveDirectional.IDLE:
          directionEvent = 'IDLE';
          break;
      }
      GameSocketManager().send(
        'message',
        {
          'action': 'MOVE',
          'room': this.currentRoomId,
          'time': DateTime.now().toIso8601String(),
          'data': {
            'player_id': id,
            'direction': directionEvent,
            'position': {
              'x': (position.left / tileSize),
              'y': (position.top / tileSize)
            },
          }
        },
      );
    }

    super.joystickChangeDirectional(event);
  }

  void showEmote(FlameAnimation.Animation emoteAnimation) {
    gameRef.add(
      AnimatedFollowerObject(
        animation: emoteAnimation,
        target: this,
        positionFromTarget: Rect.fromLTWH(
          25,
          -10,
          position.width / 2,
          position.width / 2,
        ),
      ),
    );
  }

  @override
  void render(Canvas canvas) {
    _textConfig.render(
      canvas,
      nick,
      Position(
        position.center.dx,
        position.topCenter.dy,
      ),
      anchor: Anchor.bottomCenter,
    );

    // lightingConfig = LightingConfig(
    //   color: Colors.yellow.withOpacity(0.1),
    //   radius: 100,
    //   blurBorder: 100,
    //   withPulse: false,
    //   pulseVariation: 0.5,
    //   pulseCurve: Curves.decelerate,
    //   pulseSpeed: 2,
    // );
    super.render(canvas);
  }

  @override
  void joystickAction(JoystickActionEvent action) {
    if (gameRef.joystickController.keyboardEnable &&
        action.id == LogicalKeyboardKey.space.keyId) {
      _execAttack();
    }
    if (action.id == 0 && action.event == ActionEvent.DOWN) {
      _execAttack();
    }
    super.joystickAction(action);
  }

  void _execAttack() {
    if (load < 25 || isDead) {
      return;
    }
    // decrementStamina(0);
    GameSocketManager().send('message', {
      'action': 'ATTACK',
      'room': currentRoomId,
      'time': DateTime.now().toIso8601String(),
      'data': {
        'player_id': id,
        'direction': this.lastDirection.getName(),
        'position': {
          'x': (position.left / tileSize),
          'y': (position.top / tileSize)
        },
      }
    });
    var anim = FlameAnimation.Animation.sequenced('axe_spin_atack.png', 8,
        textureWidth: 148, textureHeight: 148, stepTime: 0.05);
    this.simpleAttackRange(
      id: id,
      animationRight: anim,
      animationLeft: anim,
      animationTop: anim,
      animationBottom: anim,
      animationDestroy: FlameAnimation.Animation.sequenced(
        "smoke_explosin.png",
        6,
        textureWidth: 16,
        textureHeight: 16,
      ),
      width: tileSize * 0.9,
      height: tileSize * 0.9,
      speed: speed * 1.5,
      damage: 15,
      collision: CollisionConfig(collisions: [
        CollisionArea(
          width: tileSize * 0.9,
          height: tileSize * 0.9,
        )
      ]),
    );
  }

  @override
  void receiveDamage(double damage, dynamic from) {
    GameSocketManager().send('message', {
      'action': 'RECEIVED_DAMAGE',
      'room': currentRoomId,
      'time': DateTime.now().toIso8601String(),
      'data': {
        'player_id': id,
        'damage': damage,
        'player_id_attack': from,
      }
    });
    this.showDamage(
      damage,
      config: TextConfig(
        color: Colors.red,
        fontSize: 14,
      ),
    );
    super.receiveDamage(damage, from);
  }

  @override
  void die() {
    life = 0;
    gameRef.add(
      AnimatedObjectOnce(
        animation: FlameAnimation.Animation.sequenced(
          "smoke_explosin.png",
          6,
          textureWidth: 16,
          textureHeight: 16,
        ),
        position: position,
      ),
    );
    gameRef.addGameComponent(
      GameDecoration.sprite(
        Sprite('crypt.png'),
        position: Position(
          position.center.dx,
          position.center.dy,
        ),
        height: 48,
        width: 48,
      ),
    );
    remove();
    super.die();
  }

  void playWeaponAnim(WeaponKey weaponKey, {bool forceAddAnimation = false}) {
    String action =
        weaponKey.getName().capitalize + lastDirection.getName().capitalize;

    animation.playOther(action);

    lastActionAnim = action;
  }
}

import 'package:bonfire/bonfire.dart' hide TiledWorldMap;
import 'package:flutter/material.dart' hide TextStyle;
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:heist_squad_x/app/data/service/game_socket_manager.dart';
import 'package:heist_squad_x/app/theme/color_theme.dart';
import 'package:heist_squad_x/game/objects/breakable.dart';
import 'package:heist_squad_x/game/utils/Weapon.dart';
import 'package:heist_squad_x/game/utils/game_extensions.dart';
import 'package:heist_squad_x/main.dart';

import 'other_anim.dart';

class GamePlayer extends SimplePlayer with Lighting, ObjectCollision {
  final Vector2 initPosition;
  final int? id;
  final String? nick;
  double load = 0.0;
  double? maxLoad = 20.0;
  JoystickMoveDirectional? currentDirection;
  String directionEvent = 'IDLE';
  String? lastActionAnim;
  String? currentRoomId;
  bool isLooting = false;
  List<Destroyable> lootables = <Destroyable>[];
  final List<WeaponKey>? weapons;
  List<Destroyable>? closeLootables;

  TextPaint? _textConfig;

  // bool isMainPlayer = false;

  GamePlayer({
    this.id,
    this.nick,
    required this.initPosition,
    this.currentRoomId,
    this.weapons,
    this.maxLoad,
    required SpriteSheet spriteSheet,
  }) : super(
          initDirection: Direction.down,
          animation: SimpleDirectionAnimation(
            idleDown: spriteSheet.createAnimation(
                row: 1, stepTime: 0.1, from: 5, to: 6),
            idleLeft: spriteSheet.createAnimation(
                row: 0, stepTime: 0.1, from: 1, to: 2),
            idleRight: spriteSheet.createAnimation(
                row: 1, stepTime: 0.1, from: 1, to: 2),
            idleUp: spriteSheet.createAnimation(
                row: 0, stepTime: 0.1, from: 5, to: 6),
            runDown: spriteSheet.createAnimation(
                row: 1, stepTime: 0.1, from: 4, to: 8),
            runLeft: spriteSheet.createAnimation(
                row: 0, stepTime: 0.1, from: 0, to: 4),
            runRight: spriteSheet.createAnimation(
                row: 1, stepTime: 0.1, from: 0, to: 4),
            runUp: spriteSheet.createAnimation(
                row: 0, stepTime: 0.1, from: 4, to: 8),
            others: ActionAnim.anims(spriteSheet),
          ),
          width: tileSize,
          height: tileSize,
          position: initPosition,
          life: 100,
          speed: tileSize * 3,
        ) {
    _textConfig = TextPaint(
      style: TextStyle(
        fontSize: tileSizeResponsive / 6,
        color: Palette.WHITE,
        // fontFamily: AppTheme.appTheme.textTheme.bodyText1?.fontFamily,
      ),
      // textAlign: TextAlign.center,
    );

    setupCollision(
      CollisionConfig(
        collisions: [
          CollisionArea.circle(
            radius: tileSize * 0.3,
            align: Vector2(tileSize * 0.2, tileSize * 0.2),
          ),
        ],
      ),
    );

    setupLighting(
      LightingConfig(
        color: Colors.yellow.withOpacity(0.0),
        radius: 150,
        blurBorder: 150,
        withPulse: false,
        pulseVariation: 0.5,
        pulseCurve: Curves.decelerate,
        pulseSpeed: 2,
      ),
    );
  }

  void increaseLoad(int amount) {
    load += amount;
    if (load >= maxLoad!) {
      load = maxLoad!;
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
    if (event.directional != currentDirection) {
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
        default:
          directionEvent = 'LEFT';
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

  void showEmote(SpriteAnimation emoteAnimation) {
    gameRef.add(
      AnimatedFollowerObject(
        animation: emoteAnimation.asFuture(),
        target: this,
        positionFromTarget: Vector2Rect.fromRect(
          Rect.fromLTWH(
            25,
            -10,
            position.width / 2,
            position.width / 2,
          ),
        ),
      ),
    );
  }

  @override
  void render(Canvas canvas) {
    _textConfig!.render(
      canvas,
      nick ?? "UNKNOWN",
      Vector2(
        position.center.dx,
        position.top,
      ),
      anchor: Anchor.bottomCenter,
    );

    super.render(canvas);
  }

  @override
  void joystickAction(JoystickActionEvent action) {
    if (gameRef.joystick!.keyboardConfig.enable &&
        action.id == LogicalKeyboardKey.space.keyId) {
      _execAttack();
    }
    if (action.id == 0 && action.event == ActionEvent.DOWN) {
      _execAttack();
    }
    super.joystickAction(action);
  }

  Future<void> _execAttack() async {
    // if (load < 25 || isDead) {
    //   return;
    // }
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
    var anim = SpriteAnimation.load(
      'axe_spin_atack.png',
      SpriteAnimationData.sequenced(
        amount: 8,
        textureSize: Vector2.all(148.0),
        stepTime: 0.05,
      ),
    );

    simpleAttackRange(
      id: id,
      animationRight: anim,
      animationLeft: anim,
      animationUp: anim,
      animationDown: anim,
      animationDestroy: SpriteAnimation.load(
        "smoke_explosin.png",
        SpriteAnimationData.sequenced(
          amount: 6,
          textureSize: Vector2.all(16.0),
          stepTime: 0.1,
        ),
      ),
      width: tileSize * 0.9,
      height: tileSize * 0.9,
      speed: speed * 1.5,
      damage: 15,
      collision: CollisionConfig(collisions: [
        CollisionArea.rectangle(
          size: Size.square(tileSize * 0.9),
        )
      ]),
    );
  }

  @override
  void receiveDamage(double damage, dynamic from) {
    GameSocketManager().send(
      'message',
      {
        'action': 'RECEIVED_DAMAGE',
        'room': currentRoomId,
        'time': DateTime.now().toIso8601String(),
        'data': {
          'player_id': id,
          'damage': damage,
          'player_id_attack': from,
        }
      },
    );
    this.showDamage(
      damage,
      config: TextStyle(
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
        animation: SpriteAnimation.load(
          "smoke_explosin.png",
          SpriteAnimationData.sequenced(
            amount: 6,
            textureSize: Vector2.all(16.0),
            stepTime: 0.1,
          ),
        ),
        position: position,
      ),
    );
    gameRef.add(
      GameDecoration.withSprite(
        Sprite.load('crypt.png'),
        position: Vector2(
          position.center.dx,
          position.center.dy,
        ),
        height: 48,
        width: 48,
      ),
    );
    remove(this);
    super.die();
  }

  void playWeaponAnim(WeaponKey weaponKey, {bool forceAddAnimation = false}) {
    String action =
        weaponKey.getName().capitalize! + lastDirection.getName().capitalize!;

    animation!.playOther(action);

    lastActionAnim = action;
  }
}

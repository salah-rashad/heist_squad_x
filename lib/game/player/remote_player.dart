import 'dart:math';

import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:heist_squad_x/app/data/service/game_socket_manager.dart';
import 'package:heist_squad_x/game/player/server_player_control.dart';
import 'package:heist_squad_x/game/utils/game_extensions.dart';
import 'package:heist_squad_x/main.dart';

class RemotePlayer extends SimpleEnemy
    with ServerPlayerControl, ObjectCollision {
  static const REDUCTION_SPEED_DIAGONAL = 0.7;
  final int id;
  final String nick;
  String currentMove = 'IDLE';
  TextStyle? _textStyle;

  RemotePlayer(
    this.id,
    this.nick,
    Vector2 initPosition,
    SpriteSheet spriteSheet,
    GameSocketManager socketManager,
  ) : super(
          animation: SimpleDirectionAnimation(
            idleUp: spriteSheet.createAnimation(row: 0, stepTime: 0.1),
            idleDown: spriteSheet.createAnimation(row: 1, stepTime: 0.1),
            idleLeft: spriteSheet.createAnimation(row: 2, stepTime: 0.1),
            idleRight: spriteSheet.createAnimation(row: 3, stepTime: 0.1),
            runUp: spriteSheet.createAnimation(row: 4, stepTime: 0.1),
            runDown: spriteSheet.createAnimation(row: 5, stepTime: 0.1),
            runLeft: spriteSheet.createAnimation(row: 6, stepTime: 0.1),
            runRight: spriteSheet.createAnimation(row: 7, stepTime: 0.1),
          ),
          position: initPosition,
          width: tileSize * 1.5,
          height: tileSize * 1.5,
          life: 100,
          speed: tileSize * 3,
        ) {
    setupCollision(
      CollisionConfig(
        collisions: [
          CollisionArea.rectangle(
            size: Size.square(tileSize * 0.5),
            align: Vector2((tileSize * 0.9) / 2, tileSize),
          ),
        ],
      ),
    );

    // receivesAttackFrom = null;
    _textStyle = TextStyle(
      fontSize: tileSize / 4,
    );
    setupServerPlayerControl(socketManager, id);
  }

  @override
  void update(double dt) {
    _move(currentMove, dt);
    super.update(dt);
  }

  void _move(move, double dtUpdate) {
    switch (move) {
      case 'LEFT':
        this.moveLeft(speed * dtUpdate);
        break;
      case 'RIGHT':
        this.moveRight(speed * dtUpdate);
        break;
      case 'UP_RIGHT':
        double speedDiagonal = (speed * REDUCTION_SPEED_DIAGONAL) * dtUpdate;
        moveRight(speedDiagonal);
        moveUp(speedDiagonal);
        break;
      case 'DOWN_RIGHT':
        double speedDiagonal = (speed * REDUCTION_SPEED_DIAGONAL) * dtUpdate;
        moveRight(speedDiagonal);
        moveDown(speedDiagonal);

        break;
      case 'DOWN_LEFT':
        double speedDiagonal = (speed * REDUCTION_SPEED_DIAGONAL) * dtUpdate;
        moveLeft(speedDiagonal);
        moveDown(speedDiagonal);
        break;
      case 'UP_LEFT':
        double speedDiagonal = (speed * REDUCTION_SPEED_DIAGONAL) * dtUpdate;
        moveLeft(
          speedDiagonal,
        );
        moveUp(speedDiagonal);
        break;
      case 'UP':
        this.moveUp(speed * dtUpdate);
        break;
      case 'DOWN':
        this.moveDown(speed * dtUpdate);
        break;
      case 'IDLE':
        this.idle();
        break;
    }
  }

  @override
  void render(Canvas canvas) {
    if (isVisible) {
      _renderNickName(canvas);
      this.drawDefaultLifeBar(canvas, borderWidth: 4, margin: 0);
    }

    super.render(canvas);
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
      GameDecoration.withSprite(
        Sprite.load('crypt.png'),
        position: Vector2(
          position.left,
          position.top,
        ),
        height: 30,
        width: 30,
      ),
    );
    remove(this);
    super.die();
  }

  void _execAttack(String direction) {
    var anim = SpriteAnimation.load(
      "axe_spin_atack.png",
      SpriteAnimationData.sequenced(
        amount: 8,
        stepTime: 0.01,
        textureSize: Vector2.all(148.0),
      ),
    );

    this.simpleAttackRange(
      id: id,
      animationRight: anim,
      animationLeft: anim,
      animationUp: anim,
      animationDown: anim,
      interval: 0,
      direction: direction.getDirection(),
      animationDestroy: SpriteAnimation.load(
        "smoke_explosin.png",
        SpriteAnimationData.sequenced(
          amount: 6,
          stepTime: 0.1,
          textureSize: this.vectorPosition,
        ),
      ),
      width: tileSize * 0.9,
      height: tileSize * 0.9,
      speed: speed * 1.5,
      damage: 15,
      collision: CollisionConfig(
        collisions: [
          CollisionArea.rectangle(
            size: Size.square(tileSize * 0.9),
          ),
        ],
      ),
      // collisionOnlyVisibleObjects: false,
    );
  }

  @override
  void receiveDamage(double damage, dynamic from) {
    print("damage");
  }

  @override
  void serverAttack(String direction) {
    _execAttack(direction);
  }

  @override
  void serverMove(String direction, Rect serverPosition) {
    currentMove = direction;

    /// Corrige posição se ele estiver muito diferente da do server
    Point p = Point(serverPosition.center.dx, serverPosition.center.dy);
    double dist = p.distanceTo(Point(
      position.center.dx,
      position.center.dy,
    ));

    if (dist > (tileSize * 0.5)) {
      position = Vector2Rect.fromRect(serverPosition);
    }
  }

  @override
  void serverPlayerLeave() {
    if (!isDead) {
      die();
    }
  }

  @override
  void serverReceiveDamage(double damage) {
    if (!isDead) {
      this.showDamage(
        damage,
        config: TextStyle(color: Colors.red, fontSize: 14),
      );
      if (life > 0) {
        life -= damage;
        if (life <= 0) {
          die();
        }
      }
    }
  }

  void _renderNickName(Canvas canvas) {
    TextPaint(style: _textStyle!.copyWith(color: Colors.white)).render(
      canvas,
      nick,
      Vector2(
        position.left + ((width - (nick.length * (width / 13))) / 2),
        position.top - 20,
      ),
    );
  }
}

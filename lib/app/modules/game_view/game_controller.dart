import 'dart:ui';

import 'package:bonfire/bonfire.dart';
import 'package:flame/position.dart';
import 'package:get/get.dart';
import 'package:heist_squad_x/app/data/service/socket_manager.dart';
import 'package:heist_squad_x/app/data/service/connection_service.dart';
import 'package:heist_squad_x/game/player/remote_player.dart';
import 'package:heist_squad_x/game/player/sprite_sheet_hero.dart';
import 'package:heist_squad_x/main.dart';

class Game extends GetxController implements GameListener {
  final int idCharacter;
  final int playerId;
  final String nick;
  final Position position;
  final List<dynamic> playersOn;

  Game({
    this.idCharacter,
    this.position,
    this.playerId,
    this.nick,
    this.playersOn,
  });

  GameController gameController = GameController();
  bool firstUpdate = false;

  @override
  void onInit() {
    gameController.setListener(this);
    SocketManager().listen('message', (data) {
      if (data['action'] == 'PLAYER_JOIN' && data['data']['id'] != playerId) {
        Position personPosition = Position(
          double.parse(data['data']['position']['x'].toString()) * tileSize,
          double.parse(data['data']['position']['y'].toString()) * tileSize,
        );
        var enemy = RemotePlayer(
          data['data']['id'],
          data['data']['nick'],
          personPosition,
          getSprite(data['data']['skin'] ?? 0),
          SocketManager(),
        );
        gameController.addGameComponent(enemy);
        gameController.addGameComponent(
          AnimatedObjectOnce(
            animation: Animation.sequenced(
              "smoke_explosin.png",
              6,
              textureWidth: 16,
              textureHeight: 16,
            ),
            position: Rect.fromLTRB(personPosition.x, personPosition.y, 32, 32),
          ),
        );
      }
    });
    super.onInit();
  }

  @override
  void onClose() {
    Conn.disconnectEverything();
    print("SocketManager: disconnected");
    super.onClose();
  }

  @override
  void changeCountLiveEnemies(int count) {}

  @override
  void updateGame() {
    _addPlayersOn();
  }

  void _addPlayersOn() {
    if (firstUpdate) return;
    firstUpdate = true;
    playersOn.forEach((player) {
      if (player != null && player['id'] != playerId) {
        var enemy = RemotePlayer(
          player['id'],
          player['nick'],
          Position(
            double.parse(player['position']['x'].toString()) * tileSize,
            double.parse(player['position']['y'].toString()) * tileSize,
          ),
          getSprite(player['skin'] ?? 0),
          SocketManager(),
        );
        enemy.life = double.parse(player['life'].toString());
        gameController.addGameComponent(enemy);
      }
    });
  }

  SpriteSheet getSprite(int index) {
    switch (index) {
      case 0:
        return SpriteSheetHero.hero1;
        break;
      case 1:
        return SpriteSheetHero.hero2;
        break;
      case 2:
        return SpriteSheetHero.hero3;
        break;
      case 3:
        return SpriteSheetHero.hero4;
        break;
      case 4:
        return SpriteSheetHero.hero5;
        break;
      default:
        return SpriteSheetHero.hero1;
    }
  }
}

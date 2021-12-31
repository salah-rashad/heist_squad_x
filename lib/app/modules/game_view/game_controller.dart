import 'package:bonfire/bonfire.dart';
import 'package:get/get.dart';
import 'package:heist_squad_x/app/data/service/game_socket_manager.dart';
import 'package:heist_squad_x/game/player/remote_player.dart';
import 'package:heist_squad_x/game/player/sprite_sheet_player.dart';
import 'package:heist_squad_x/main.dart';

class Game extends GetxController implements GameListener {
  final int? idCharacter;
  final int? playerId;
  final String? nick;
  final Vector2? position;
  final List<dynamic>? playersOn;

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
    gameController.addListener(this);
    GameSocketManager().listen('message', (data) async {
      if (data['action'] == 'PLAYER_JOIN' && data['data']['id'] != playerId) {
        Vector2 personPosition = Vector2(
          double.parse(data['data']['position']['x'].toString()) * tileSize,
          double.parse(data['data']['position']['y'].toString()) * tileSize,
        );
        var teamMate = RemotePlayer(
          data['data']['id'],
          data['data']['nick'],
          personPosition,
          await getSprite(data['data']['skin'] ?? 0),
          GameSocketManager(),
        );
        gameController.addGameComponent(teamMate);
        gameController.addGameComponent(
          AnimatedObjectOnce(
            animation: SpriteAnimation.load(
              "smoke_explosin.png",
              SpriteAnimationData.sequenced(
                amount: 6,
                stepTime: 0.1,
                textureSize: Vector2.all(16.0),
              ),
            ),
            position: Vector2Rect(personPosition, Vector2.all(32.0)),
          ),
        );
      }
    });
    super.onInit();
  }

  @override
  void changeCountLiveEnemies(int count) {}

  @override
  void updateGame() {
    _addPlayersOn();
  }

  Future<void> _addPlayersOn() async {
    if (firstUpdate) return;
    firstUpdate = true;
    playersOn!.forEach((player) async {
      if (player != null && player['id'] != playerId) {
        var teamMate = RemotePlayer(
          player['id'],
          player['nick'],
          Vector2(
            double.parse(player['position']['x'].toString()) * tileSize,
            double.parse(player['position']['y'].toString()) * tileSize,
          ),
          await getSprite(player['skin'] ?? 0),
          GameSocketManager(),
        );
        teamMate.life = double.parse(player['life'].toString());
        gameController.addGameComponent(teamMate);
      }
    });
  }

  Future<SpriteSheet> getSprite(int index) {
    switch (index) {
      case 0:
        return SpriteSheetPlayer.player1();
      case 1:
        return SpriteSheetPlayer.player1();
      case 2:
        return SpriteSheetPlayer.player1();
      case 3:
        return SpriteSheetPlayer.player1();
      case 4:
        return SpriteSheetPlayer.player1();
      default:
        return SpriteSheetPlayer.player1();
    }
  }
}

import 'package:bonfire/bonfire.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heist_squad_x/game/interface/player_interface.dart';
import 'package:heist_squad_x/game/player/game_player.dart';
import 'package:heist_squad_x/main.dart';

import 'game_controller.dart';

class GameView extends GetView<Game> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints:
            kIsWeb ? BoxConstraints(maxWidth: 800, maxHeight: 800) : null,
        child: SizedBox(
          child: BonfireTiledWidget(
            joystick: Joystick(
              keyboardEnable: true,
              directional: JoystickDirectional(
                spriteKnobDirectional: Sprite('joystick_knob.png'),
                spriteBackgroundDirectional: Sprite('joystick_background.png'),
                size: 100,
              ),
              actions: [
                JoystickAction(
                  actionId: 0,
                  sprite: Sprite('joystick_atack.png'),
                  spritePressed: Sprite('joystick_atack_selected.png'),
                  size: 80,
                  margin: EdgeInsets.only(bottom: 50, right: 50),
                ),
              ],
            ),
            player: GamePlayer(
              controller.playerId,
              controller.nick,
              Position(controller.position.x * tileSize,
                  controller.position.y * tileSize),
              controller.getSprite(controller.idCharacter),
            ),
            interface: PlayerInterface(),
            map: TiledWorldMap('tile/map.json',
                forceTileSize: Size(tileSize, tileSize)),
            constructionModeColor: Colors.black,
            collisionAreaColor: Colors.purple.withOpacity(0.4),
            gameController: controller.gameController,
            cameraMoveOnlyMapArea: true,
          ),
        ),
      ),
    );
  }
}

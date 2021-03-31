import 'package:bonfire/bonfire.dart' hide TiledWorldMap;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heist_squad_x/game/interface/player_interface.dart';
import 'package:heist_squad_x/game/map/map_generator.dart';
import 'package:heist_squad_x/game/player/game_player.dart';
import 'package:heist_squad_x/game/player/sprite_sheet_player.dart';
import 'package:heist_squad_x/game/utils/Weapon.dart';

import 'game_controller.dart';

class GameView extends GetView<Game> {
  final String roomId;

  GameView(this.roomId);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        // constraints:
        //     kIsWeb ? BoxConstraints(maxWidth: 800, maxHeight: 800) : null,
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
              id: controller.playerId,
              nick: controller.nick,
              initPosition: Position(660, 750),
              currentRoomId: roomId,
              spriteSheet: SpriteSheetPlayer.player1,
              weapons: [
                WeaponKey.crowbar,
                WeaponKey.hammer,
                WeaponKey.saw,
                WeaponKey.keys,
                WeaponKey.drill,
                WeaponKey.oscillator,
                WeaponKey.pliers,
                WeaponKey.scanner,
                WeaponKey.computer,
                WeaponKey.smallBomb,
                WeaponKey.largeBomb,
                WeaponKey.knife,
              ],
              maxLoad: 20,
            ),
            interface: PlayerInterface(),
            map: MapGenerator().level1,
            showCollisionArea: true,
            collisionAreaColor: Colors.purple.withOpacity(0.4),
            gameController: controller.gameController,
            cameraMoveOnlyMapArea: true,

            // lightingColorGame: Palette.BLACK.withOpacity(0.95),
          ),
        ),
      ),
    );
  }
}

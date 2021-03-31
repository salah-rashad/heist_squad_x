import 'dart:ui';

import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:heist_squad_x/game/player/game_player.dart';
import 'package:heist_squad_x/game/player/remote_player.dart';
import 'package:heist_squad_x/app/theme/color_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'bar_life_component.dart';

class PlayerInterface extends GameInterface {
  OverlayEntry _overlayEntryEmotes;
  int countEnemy = 0;
  static int countEmotes = 10;

  SpriteSheet spriteSheetEmotes = SpriteSheet(
    imageName: 'emotes/emotes1.png',
    textureWidth: 32,
    textureHeight: 32,
    columns: 8,
    rows: countEmotes,
  );

  @override
  void resize(Size size) {
    add(
      InterfaceComponent(
        sprite: Sprite('emote.png'),
        width: 32.w,
        height: 32.h,
        id: 1,
        position: Position(size.width - 42.w, 10),
        onTapComponent: () => _showDialog(),
      ),
    );
    addNicks(size);
    add(BarLifeComponent());
    super.resize(size);
  }

  void addNicks(Size size) {
    add(TextInterfaceComponent(
        text: _getEnemiesName(),
        width: 32,
        height: 32,
        id: 2,
        position: Position(size.width - 60.w, 50),
        textConfig: TextConfig(color: Colors.white, fontSize: 13),
        onTapComponent: () => _showDialog()));
  }

  @override
  void update(double t) {
    if (gameRef.livingEnemies().length != countEnemy && gameRef.size != null) {
      addNicks(gameRef.size);
    }
    super.update(t);
  }

  void _showDialog() {
    if (_overlayEntryEmotes == null) {
      _overlayEntryEmotes = OverlayEntry(
          builder: (context) => Align(
                alignment: Alignment.topLeft,
                child: Container(
                  height: 50.h,
                  margin: EdgeInsets.only(left: 15, right: 15, top: 15),
                  child: Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(20),
                    child: ListView(
                      padding: EdgeInsets.only(top: 6, bottom: 6, right: 20),
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      children: List.generate(countEmotes, (index) {
                        return InkWell(
                          onTap: () {
                            _overlayEntryEmotes.remove();
                            if (gameRef.player != null) {
                              (gameRef.player as GamePlayer)
                                  .showEmote(spriteSheetEmotes.createAnimation(
                                index,
                                stepTime: 0.1,
                              ));
                            }
                          },
                          child: Container(
                            width: 32.w,
                            height: 32.h,
                            margin: EdgeInsets.only(left: 20),
                            child: Flame.util.animationAsWidget(
                                Position(32, 32),
                                spriteSheetEmotes.createAnimation(index,
                                    stepTime: 0.1)),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ));
      // Align(
      //   alignment: Alignment.topCenter,
      //   child: Material(
      //     color: Colors.transparent,
      //     child: Padding(
      //       padding:
      //           EdgeInsets.symmetric(horizontal: 100.0, vertical: 16.0),
      //       child: Row(
      //         children: [
      //           Expanded(
      //             child: Container(
      //               height: 40.0,
      //               child: TextField(
      //                 textInputAction: TextInputAction.send,
      //                 decoration: InputDecoration(
      //                   filled: true,
      //                   fillColor:
      //                       Palette.BACKGROUND_DARK.withOpacity(0.5),
      //                   border: OutlineInputBorder(),
      //                 ),
      //               ),
      //             ),
      //           ),
      //           Container(
      //             height: 40.0,
      //             width: 40.0,
      //             margin: EdgeInsets.only(left: 16.0),
      //             child: IconButton(
      //               icon: Icon(
      //                 Icons.send_rounded,
      //                 color: Palette.BLUE,
      //               ),
      //               color: Colors.black54,
      //               onPressed: () {},
      //             ),
      //           )
      //         ],
      //       ),
      //     ),
      //   ),
      // ));
    }
    Overlay.of(gameRef.context).insert(_overlayEntryEmotes);
  }

  String _getEnemiesName() {
    countEnemy = gameRef.livingEnemies().length;
    String names = '';
    gameRef.livingEnemies().forEach((enemy) {
      if (enemy is RemotePlayer) names += '${(enemy).nick}\n';
    });
    return names;
  }
}

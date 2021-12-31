import 'dart:ui';

import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heist_squad_x/app/theme/color_theme.dart';
import 'package:heist_squad_x/app/widgets/custom_button.dart';
import 'package:heist_squad_x/game/objects/breakable.dart';
import 'package:heist_squad_x/game/player/game_player.dart';
import 'package:heist_squad_x/game/utils/Weapon.dart';
import 'package:heist_squad_x/game/utils/game_extensions.dart';

class LootableDialog extends StatelessWidget {
  final GamePlayer player;
  final Destroyable lootable;

  const LootableDialog(this.player, this.lootable);
  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Center(
        child: Container(
          height: Get.height * 0.75,
          width: Get.width * 0.5,
          child: Card(
            elevation: 5,
            color: Palette.BACKGROUND_DARK,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 32, left: 32),
                      child: Center(
                        child: SpriteAnimationWidget(
                          playing: false,
                          animation: lootable.getCurrentAnimation()!,
                        ),
                        // SpriteWidget(
                        //   sprite: lootable.animation.current.getSprite(),
                        // ),
                      ),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 32),
                        child: Text(
                          lootable.itemName!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 26,
                            color: Palette.WHITE60,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    CustomButton(
                      margin: EdgeInsets.only(right: 16),
                      child: Icon(Icons.close, color: Palette.RED, size: 18),
                      onTap: () => Get.back(),
                    )
                  ],
                ),
                Container(
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            "assets/images/icons/hp.png",
                            width: 30,
                            height: 30,
                            fit: BoxFit.contain,
                          ),
                          SizedBox(width: 16),
                          Text(
                            lootable.life.floor().toString() +
                                "/" +
                                lootable.maxLife.floor().toString(),
                            style:
                                TextStyle(color: Palette.WHITE60, fontSize: 18),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      Container(
                        width: Get.width * 0.5,
                        height: 120,
                        child: Builder(
                          builder: (context) {
                            List<WeaponKey> userWeapons = player.weapons!;

                            List<WeaponKey> availableWeapons =
                                lootable.canDestroyWeapons!;

                            availableWeapons.retainWhere(
                                (weapon) => userWeapons.contains(weapon));

                            if (availableWeapons.isEmpty) {
                              return Center(
                                child: Text(
                                  "This item is not available for you!",
                                  style: TextStyle(color: Palette.RED2),
                                ),
                              );
                            }

                            return ListView.builder(
                              padding: EdgeInsets.only(left: 32.0, right: 32.0),
                              scrollDirection: Axis.horizontal,
                              itemCount: availableWeapons.length,
                              itemBuilder: (context, i) {
                                WeaponKey weapon = availableWeapons[i];
                                String name = weapon.getName();

                                // if (weapon == WeaponKey.CROWBAR)
                                //   name = "Crowbar";
                                // if (weapon == WeaponKey.HAMMER) name = "Hammer";
                                // if (weapon == WeaponKey.SAW) name = "Saw";
                                // if (weapon == WeaponKey.KEYS) name = "Keys";
                                // if (weapon == WeaponKey.DRILL) name = "Drill";
                                // if (weapon == WeaponKey.OSCILLATOR)
                                //   name = "Oscillator";
                                // if (weapon == WeaponKey.PLIERS) name = "Pliers";
                                // if (weapon == WeaponKey.SCANNER)
                                //   name = "Scanner";
                                // if (weapon == WeaponKey.COMPUTER)
                                //   name = "Computer";
                                // if (weapon == WeaponKey.SMALL_BOMB)
                                //   name = "Small Bomb";
                                // if (weapon == WeaponKey.LARGE_BOMB)
                                //   name = "Large Bomb";
                                // if (weapon == WeaponKey.KNIFE) name = "Knife";

                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CustomButton(
                                    height: 50,
                                    width: 100,
                                    radius: 16,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Image.asset(
                                            "assets/images/weapons/$name.png"),
                                        SizedBox(
                                          height: 8.0,
                                        ),
                                        Text(
                                          name,
                                          style:
                                              TextStyle(color: Palette.WHITE60),
                                        ),
                                      ],
                                    ),
                                    onTap: () {
                                      lootable.startDestoying(player, weapon);
                                      Get.back();
                                    },
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

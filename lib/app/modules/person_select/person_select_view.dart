import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heist_squad_x/app/data/service/connection_service.dart';
import 'package:heist_squad_x/app/modules/person_select/person_select_controller.dart';
import 'package:heist_squad_x/app/theme/color_theme.dart';

class PersonSelectView extends GetView<PersonSelectController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.BACKGROUND_DARK,
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Text(
                "Select your character".capitalize,
                style: TextStyle(color: Colors.white, fontSize: 30),
              ),
              SizedBox(
                width: 200.0,
                child: TextField(
                  controller: controller.nicknameTextController,
                  textAlign: TextAlign.center,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    hintText: "Nickname",
                  ),
                  style: TextStyle(color: Palette.WHITE60),
                ),
              ),
              Expanded(
                child: _buildPersons(),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Stack(
                  children: <Widget>[
                    SizedBox(
                      height: 50,
                      width: 150,
                      child: Obx(() => RaisedButton(
                            color: Palette.GREEN,
                            child: Text(
                              'ENTER',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            onPressed: Conn.status == 'CONNECTED'
                                ? controller.goGame
                                : null,
                          )),
                    ),
                  ],
                ),
              )
            ],
          ),
          Obx(() {
            if (controller.loading)
              return InkWell(
                onTap: () {},
                child: Container(
                  color: Colors.white.withOpacity(0.9),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        CircularProgressIndicator(),
                        SizedBox(
                          height: 10,
                        ),
                        Text("Loading")
                      ],
                    ),
                  ),
                ),
              );
            else
              return Container();
          }),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 4.0, horizontal: 32.0),
                    child: Obx(() => Text(
                          Conn.status,
                          style: TextStyle(fontSize: 9, color: Colors.white),
                        )),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 4.0, horizontal: 32.0),
                  child: Text(
                    "v0.1.0",
                    style: TextStyle(fontSize: 9, color: Colors.white),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildPersons() {
    return Obx(
      () => Row(
        children: <Widget>[
          Expanded(
            child: Center(
              child: SizedBox(
                width: 50,
                height: 50,
                child: RaisedButton(
                  color: Palette.BACKGROUND_LIGHT,
                  padding: EdgeInsets.all(0),
                  child: Center(
                      child: Icon(
                    Icons.chevron_left,
                    color: Colors.white,
                  )),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                  onPressed: controller.count == 0 ? null : controller.previous,
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Flame.util.animationAsWidget(
                Position(100, 100),
                controller.sprites[controller.count]
                    .createAnimation(5, stepTime: 0.1),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: SizedBox(
                width: 50,
                height: 50,
                child: RaisedButton(
                  color: Palette.BACKGROUND_LIGHT,
                  padding: EdgeInsets.all(0),
                  child: Center(
                      child: Icon(
                    Icons.chevron_right,
                    color: Colors.white,
                  )),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                  onPressed: controller.count == controller.sprites.length - 1
                      ? null
                      : controller.next,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

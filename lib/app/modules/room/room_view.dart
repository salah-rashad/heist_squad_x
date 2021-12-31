import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:heist_squad_x/app/data/model/room_model.dart';
import 'package:heist_squad_x/app/data/model/user_model.dart';
import 'package:heist_squad_x/app/data/provider/database.dart';
import 'package:heist_squad_x/app/data/service/connection_service.dart';
import 'package:heist_squad_x/app/modules/game_view/game_view.dart';
import 'package:heist_squad_x/app/modules/room/chat/chat_view.dart';
import 'package:heist_squad_x/app/modules/room/room_controller.dart';
import 'package:heist_squad_x/app/theme/color_theme.dart';
import 'package:heist_squad_x/app/util/clipboard_util.dart';
import 'package:heist_squad_x/app/util/futured.dart';
import 'package:heist_squad_x/app/util/random_color.dart';
import 'package:heist_squad_x/app/widgets/loading_widget.dart';

class RoomView extends StatelessWidget {
  final Room initialRoom;
  RoomView(this.initialRoom);

  @override
  Widget build(BuildContext context) {
    return GetX<RoomController>(
        autoRemove: true,
        tag: initialRoom.id,
        init: RoomController(initialRoom),
        builder: (controller) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: Stack(
              children: [
                Container(
                  constraints: BoxConstraints(minHeight: Get.size.height),
                  padding: const EdgeInsets.symmetric(
                      vertical: 32.0, horizontal: 40.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 4,
                        child: leftView(controller),
                      ),
                      SizedBox(
                        width: 16.0,
                      ),
                      Expanded(
                        flex: 6,
                        child: centerView(controller),
                      ),
                      SizedBox(
                        width: 16.0,
                      ),
                      Expanded(
                        flex: 4,
                        child: rightView(context, controller),
                      )
                    ],
                  ),
                ),
                if (controller.isLoading)
                  InkWell(
                    onTap: () {},
                    child: Container(
                      color: Palette.BACKGROUND_LIGHT,
                      child: Center(
                        child: LoadingWidget(size: Get.height * 0.3),
                      ),
                    ),
                  )
              ],
            ),
          );
        });
  }

  Widget leftView(RoomController c) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          c.room!.name!,
          style: TextStyle(fontSize: 18.0),
        ),
        SizedBox(
          height: 16.0,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "ROOM-ID:",
              style: TextStyle(
                fontSize: 12.0,
                color: Palette.WHITE24,
              ),
            ),
            SelectableText(
              c.room!.id!,
              style: TextStyle(
                fontSize: 14.0,
                color: Palette.WHITE60,
                height: 2.0,
              ),
            ),
          ],
        ),
        TextButton.icon(
          label: Text(
            "copy",
            style: TextStyle(
              fontSize: 12.0,
              color: Palette.WHITE60,
            ),
          ),
          icon: Icon(
            Icons.copy_rounded,
            color: Palette.WHITE60,
            size: 12.0,
          ),
          onPressed: () => ClipboardUtil.copy(c.room!.id!),
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            visualDensity: VisualDensity.compact,
            onSurface: Palette.BLUE,
            primary: Palette.BLUE,
          ),
        ),
        Expanded(child: Container()),
        Padding(
          padding: const EdgeInsets.only(top: 8.0, right: 8.0, left: 8.0),
          child: Obx(
            () => c.gameStarted
                ? ElevatedButton(
                    onPressed: Conn.status == 'CONNECTED'
                        ? () => Get.to(
                              () => GameView(c.room!.id!),
                              transition: Transition.fade,
                              preventDuplicates: true,
                            )
                        : null,
                    child: Text("BACK TO GAME >>"),
                    style: ElevatedButton.styleFrom(
                      primary: Palette.BACKGROUND_DARKER,
                      onPrimary: Palette.GREEN,
                      minimumSize: Size(double.maxFinite, 56.0),
                    ),
                  )
                : ElevatedButton(
                    onPressed: Conn.status == 'CONNECTED' ? c.goGame : null,
                    child: Text(
                      "START",
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Palette.GREEN,
                      onPrimary: Palette.BACKGROUND_DARKER,
                      minimumSize: Size(double.maxFinite, 56.0),
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Widget centerView(RoomController c) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.topCenter,
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                color: Palette.BACKGROUND_DARKER,
                child: Container()
                /* BonfireTiledWidget(
                  map: MapGenerator().level1,
                  constructionModeColor: Colors.black,
                  collisionAreaColor: Colors.purple.withOpacity(0.4),
                  cameraConfig: CameraConfig(
                    sizeMovementWindow: Size(200, 200),
                    moveOnlyMapArea: true,
                    zoom: 0.0,
                  ),
                ) */
                ,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 8.0,
        ),
        Expanded(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Players:",
                    style: TextStyle(fontSize: 14.0),
                  ),
                  Text(
                    "${c.room!.players!.length}/${c.room!.maxPlayers}",
                    style: TextStyle(fontSize: 14.0),
                  ),
                ],
              ),
              SizedBox(
                height: 8.0,
              ),
              Expanded(
                child: Center(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 80.0,
                      mainAxisSpacing: 8.0,
                      crossAxisSpacing: 8.0,
                    ),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: c.room!.maxPlayers,
                    physics: ClampingScrollPhysics(),
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    itemBuilder: (BuildContext context, int index) {
                      if (c.room!.players!.length > index)
                        return Futured<UserModel?>(
                          future: Database.getUser(c.room!.players![index]),
                          hasData: (context, snapshot) {
                            UserModel? user = snapshot.data;

                            return playerCircle(user, c);
                          },
                          hasError: (context, snapshot) {
                            return playerError(snapshot.error!);
                          },
                          hasNoData: (context, snapshot) {
                            return playerInvite();
                          },
                        );
                      else
                        return playerInvite();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget rightView(BuildContext context, RoomController controller) {
    return ChatView(
      room: controller.room!,
    );
  }

  Widget playerCircle(UserModel? user, RoomController c) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.all(0.0),
            child: ClipOval(
              child: Container(
                // color: randomColor(),
                child: Image.network(
                  // "https://ui-avatars.com/api/?name=${user!.nick}",

                  "https://avatars.dicebear.com/api/big-smile/${user!.nick}.png?style=circle?background=%230000ff",
                ),
              ),
            ),
          ),
        ),
        if (user.uid == c.room!.ownerId)
          Align(
            alignment: Alignment.topLeft,
            child: Transform.rotate(
              angle: -pi / 4.4,
              child: Icon(
                FontAwesomeIcons.crown,
                color: Palette.YELLOW,
                size: 16.0,
              ),
            ),
          )
      ],
    );
  }

  Widget playerInvite() {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Align(
        alignment: Alignment.center,
        child: ClipOval(
          child: Container(
            alignment: Alignment.center,
            color: Palette.BACKGROUND_DARKER,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.person_add_alt_1_rounded,
                  color: Palette.WHITE24,
                  size: 18.0,
                ),
                Text(
                  "INVITE",
                  style: TextStyle(color: Palette.WHITE24, fontSize: 12.0),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget playerError(Object? error) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Align(
        alignment: Alignment.center,
        child: ClipOval(
          child: Container(
            alignment: Alignment.center,
            color: Palette.TRANSPARENT,
            child: Text(
              "Error!",
              style: TextStyle(color: Palette.RED),
            ),
          ),
        ),
      ),
    );
  }
}

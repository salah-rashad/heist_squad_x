import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

class RoomView extends StatelessWidget {
  final Room initialRoom;
  RoomView(this.initialRoom);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        constraints: BoxConstraints(minHeight: Get.size.height),
        padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 40.0),
        child: GetX<RoomController>(
          autoRemove: true,
          // tag: initialRoom.id,
          init: RoomController(initialRoom),
          // initState: (state) {},
          builder: (controller) {
            return Stack(
              children: [
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 4,
                      child: leftView(controller),
                    ),
                    SizedBox(
                      width: 16.0.w,
                    ),
                    Expanded(
                      flex: 6,
                      child: centerView(controller),
                    ),
                    SizedBox(
                      width: 16.0.w,
                    ),
                    Expanded(
                      flex: 4,
                      child: rightView(context),
                    )
                  ],
                ),
                Obx(() {
                  if (controller.isLoading)
                    return InkWell(
                      onTap: () {},
                      child: Container(
                        color: Palette.BLACK.withOpacity(0.5),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              CircularProgressIndicator(),
                              SizedBox(
                                height: 10.h,
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
              ],
            );
          },
        ),
      ),
    );
  }

  Widget leftView(RoomController c) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          c.room.name,
          style: TextStyle(fontSize: 18.0.sp),
        ),
        SizedBox(
          height: 16.0.h,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "ROOM-ID:",
              style: TextStyle(
                fontSize: 12.0.sp,
                color: Palette.WHITE24,
              ),
            ),
            SelectableText(
              c.room.id,
              style: TextStyle(
                fontSize: 14.0.sp,
                color: Palette.WHITE60,
                height: 2.0.h,
              ),
            ),
          ],
        ),
        TextButton.icon(
          label: Text(
            "copy",
            style: TextStyle(
              fontSize: 12.0.sp,
              color: Palette.WHITE60,
            ),
          ),
          icon: Icon(
            Icons.copy_rounded,
            color: Palette.WHITE60,
            size: 12.0.sp,
          ),
          onPressed: () => ClipboardUtil.copy(c.room.id),
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
                              () => GameView(c.room.id),
                              transition: Transition.fade,
                              preventDuplicates: true,
                            )
                        : null,
                    child: Text("BACK TO GAME >>"),
                    style: ElevatedButton.styleFrom(
                      primary: Palette.BACKGROUND_DARKER,
                      onPrimary: Palette.GREEN,
                      minimumSize: Size(double.maxFinite, 56.0.h),
                    ),
                  )
                : ElevatedButton(
                    onPressed: Conn.status == 'CONNECTED' ? c.goGame : null,
                    child: Text(
                      "START",
                      style: TextStyle(
                        fontSize: 14.0.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Palette.GREEN,
                      onPrimary: Palette.BACKGROUND_DARKER,
                      minimumSize: Size(double.maxFinite, 56.0.h),
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
                child:
                    //  Container()

                    BonfireTiledWidget(
                  map: TiledWorldMap(
                    'tiled/maps/hs_level1.json',
                    // forceTileSize: Size(2, 2),
                  ),
                  constructionModeColor: Colors.black,
                  collisionAreaColor: Colors.purple.withOpacity(0.4),
                  cameraSizeMovementWindow: Size(200, 200),
                  cameraMoveOnlyMapArea: true,
                  cameraZoom: 0.0,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 8.0.h,
        ),
        Expanded(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Players:",
                    style: TextStyle(fontSize: 14.0.sp),
                  ),
                  Text(
                    "${c.room.players.length}/${c.room.maxPlayers}",
                    style: TextStyle(fontSize: 14.0.sp),
                  ),
                ],
              ),
              SizedBox(
                height: 8.0.h,
              ),
              Expanded(
                child: Center(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 80.0.w,
                      mainAxisSpacing: 8.0.w,
                      crossAxisSpacing: 8.0.h,
                    ),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: c.room.maxPlayers,
                    physics: ClampingScrollPhysics(),
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    itemBuilder: (BuildContext context, int index) {
                      if (c.room.players.length > index)
                        return FutureBuilder<UserModel>(
                          future: Database.getUser(c.room.players[index]),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              UserModel user = snapshot.data;

                              return playerCircle(user);
                            } else if (snapshot.hasError)
                              return playerError(snapshot.error);
                            else
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

  Widget rightView(BuildContext context) {
    return ChatView();
  }
}

Widget playerCircle(UserModel user) {
  return Align(
    alignment: Alignment.center,
    child: ClipOval(
      child: Container(
        alignment: Alignment.center,
        color: Palette.BLUE,
        child: Text(
          user.nick,
          style: TextStyle(fontSize: 14.0.sp),
        ),
      ),
    ),
  );
}

Widget playerInvite() {
  return Align(
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
              size: 18.0.sp,
            ),
            Text(
              "INVITE",
              style: TextStyle(color: Palette.WHITE24, fontSize: 12.0.sp),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ),
  );
}

Widget playerError(Object error) {
  return Align(
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
  );
}

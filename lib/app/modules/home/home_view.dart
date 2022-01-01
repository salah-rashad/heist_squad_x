import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:heist_squad_x/app/data/model/user_model.dart';
import 'package:heist_squad_x/app/data/provider/auth.dart';
import 'package:heist_squad_x/app/data/provider/database.dart';
import 'package:heist_squad_x/app/modules/home/home_controller.dart';
import 'package:heist_squad_x/app/routes/app_pages.dart';
import 'package:heist_squad_x/app/theme/color_theme.dart';
import 'package:heist_squad_x/app/widgets/flat_button_x.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: BoxConstraints(minHeight: Get.size.height),
        padding: const EdgeInsets.all(40.0),
        child: Row(
          children: <Widget>[
            Expanded(child: leftSide()),
            Expanded(child: rightSide()),
          ],
        ),
      ),
    );
  }

  Widget leftSide() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Image.asset(
            'assets/logo/logo_light.png',
            width: 120.0.w,
          ),
        ),
        SizedBox(
          height: 32.0,
        ),
        Expanded(
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Obx(
              () {
                return Wrap(
                  alignment: WrapAlignment.end,
                  crossAxisAlignment: WrapCrossAlignment.start,
                  direction: Axis.vertical,
                  verticalDirection: VerticalDirection.down,
                  runSpacing: 8.0,
                  children:
                      Auth.i.isSignedIn ? onlineButtons() : offlineButtons(),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget rightSide() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Obx(
          () => Auth.i.isSignedIn
              ? StreamBuilder<QuerySnapshot<UserModel>>(
                  stream: Database.getOnlineUsers(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active)
                      return Text(
                          "${snapshot.data?.docs.length} User(s) Online.");
                    else
                      return SizedBox();
                  },
                )
              : SizedBox.shrink(),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Obx(
            //   () => Auth.i.isSignedIn
            //       ? IconButton(
            //           color: Palette.RED,
            //           icon: Icon(FontAwesomeIcons.signOutAlt),
            //           iconSize: 24.0,
            //           onPressed: () => Auth.auth.signOut(),
            //         )
            //       : SizedBox.shrink(),
            // ),
            Obx(
              () => Auth.i.isSignedIn
                  ? IconButton(
                      color: Palette.RED,
                      icon: Icon(FontAwesomeIcons.signOutAlt),
                      iconSize: 24.0,
                      onPressed: () => Auth.auth.signOut(),
                    )
                  : SizedBox.shrink(),
            ),
            SizedBox(
              height: 8.0,
            ),
            Obx(
              () => IconButton(
                color:
                    controller.bgmIsPlaying ? Palette.WHITE60 : Palette.WHITE24,
                icon: Icon(FontAwesomeIcons.music),
                iconSize: 24.0,
                onPressed: () => controller.bgmIsPlaying
                    ? FlameAudio.bgm.pause()
                    : FlameAudio.bgm.resume(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  List<Widget> offlineButtons() {
    return [
      FlatButtonX(
        onPressed: () {},
        child: Text(
          "Solo Game",
        ),
      ),
      FlatButtonX(
        onPressed: () async {
          Get.toNamed(Routes.LOGIN);
        },
        child: Text(
          "Multiplayer",
        ),
      ),
      FlatButtonX(
        onPressed: () {},
        child: Text(
          "Settings",
        ),
      ),
      FlatButtonX(
        onPressed: () {},
        child: Text(
          "About",
        ),
      ),
    ];
  }

  List<Widget> onlineButtons() {
    return [
      FlatButtonX(
        onPressed: () async {
          Get.toNamed(Routes.JOIN_ROOM);
        },
        child: Text(
          "Join",
        ),
      ),
      FlatButtonX(
        onPressed: () => Database.createNewRoom(Auth.i.userData),
        child: Text(
          "Create",
        ),
      ),
      FlatButtonX(
        onPressed: () {},
        child: Text(
          "Tutorial",
        ),
      ),
      FlatButtonX(
        onPressed: () {},
        child: Text(
          "Settings",
        ),
      ),
      FlatButtonX(
        onPressed: () {},
        child: Text(
          "About",
        ),
      ),
    ];
  }
}

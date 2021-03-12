import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:heist_squad_x/app/data/provider/auth_controller.dart';
import 'package:heist_squad_x/app/modules/home/home_controller.dart';
import 'package:heist_squad_x/app/routes/app_pages.dart';
import 'package:heist_squad_x/app/theme/color_theme.dart';
import 'package:heist_squad_x/app/widgets/flat_button_x.dart';

class HomeView extends GetView<HomeController> {
  final _auth = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Row(
          children: <Widget>[
            leftSide(),
            optionsSide(),
          ],
        ),
      ),
    );
  }

  Widget leftSide() {
    return Expanded(
      flex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Image.asset(
              'assets/logo/logo_light.png',
              width: 120.0,
            ),
          ),
          Expanded(child: SizedBox()),
          _auth.isSignedIn
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FlatButtonX(
                      onPressed: () async {
                        Get.toNamed(Routes.PERSON_SELECT);
                      },
                      highlightColor: Colors.transparent,
                      splashColor: Palette.BACKGROUND_LIGHT,
                      child: Text(
                        "Join (15)",
                        style: TextStyle(
                          fontSize: 18,
                          // color: Palette.WHITE60,
                        ),
                      ),
                    ),
                    FlatButtonX(
                      onPressed: () {},
                      highlightColor: Colors.transparent,
                      splashColor: Palette.BACKGROUND_LIGHT,
                      child: Text(
                        "Create",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FlatButtonX(
                      onPressed: () async {
                        Get.toNamed(Routes.LOGIN);
                      },
                      highlightColor: Colors.transparent,
                      splashColor: Palette.BACKGROUND_LIGHT,
                      child: Text(
                        "Play",
                        style: TextStyle(
                          fontSize: 18,
                          // color: Palette.WHITE60,
                        ),
                      ),
                    ),
                    FlatButtonX(
                      onPressed: () {},
                      highlightColor: Colors.transparent,
                      splashColor: Palette.BACKGROUND_LIGHT,
                      child: Text(
                        "Tutorial",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
          FlatButtonX(
            onPressed: () {},
            highlightColor: Colors.transparent,
            splashColor: Palette.BACKGROUND_LIGHT,
            child: Text(
              "Settings",
              style: TextStyle(
                fontSize: 18,
                color: Palette.WHITE60,
              ),
            ),
          ),
          FlatButtonX(
            onPressed: () {},
            highlightColor: Colors.transparent,
            splashColor: Palette.BACKGROUND_LIGHT,
            child: Text(
              "About",
              style: TextStyle(
                fontSize: 18,
                color: Palette.WHITE60,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget optionsSide() {
    return Padding(
      padding: EdgeInsets.only(left: 32.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Obx(
            () => IconButton(
              color:
                  controller.bgmIsPlaying ? Palette.WHITE60 : Palette.WHITE24,
              icon: Icon(FontAwesomeIcons.headphonesAlt),
              onPressed: () => controller.bgmIsPlaying
                  ? Flame.bgm.pause()
                  : Flame.bgm.resume(),
            ),
          ),
        ],
      ),
    );
  }
}

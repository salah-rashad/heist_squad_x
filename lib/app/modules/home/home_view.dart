import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:heist_squad_x/app/data/provider/auth.dart';
import 'package:heist_squad_x/app/data/provider/database.dart';
import 'package:heist_squad_x/app/data/service/auth_controller.dart';
import 'package:heist_squad_x/app/modules/home/home_controller.dart';
import 'package:heist_squad_x/app/routes/app_pages.dart';
import 'package:heist_squad_x/app/theme/color_theme.dart';
import 'package:heist_squad_x/app/widgets/flat_button_x.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeView extends GetView<HomeController> {
  final auth = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: BoxConstraints(minHeight: Get.size.height),
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
              width: 120.0.w,
            ),
          ),
          SizedBox(
            height: 32.0.h,
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Obx(
                () => auth.isSignedIn ? onlineButtons() : offlineButtons(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget optionsSide() {
    return Expanded(
      flex: 1,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // StreamBuilder<QuerySnapshot>(
              //     stream: Database.getOnlineUsers(),
              //     builder: (context, snapshot) {
              //       if (snapshot.connectionState == ConnectionState.active)
              //         return Text(
              //             "${snapshot.data.docs.length} User(s) Online.");
              //       else
              //         return SizedBox();
              //     }),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Obx(
                () => auth.isSignedIn
                    ? IconButton(
                        color: Palette.RED.withOpacity(0.5),
                        icon: Icon(FontAwesomeIcons.signOutAlt),
                        iconSize: 24.0.sp,
                        onPressed: () => Auth.auth.signOut(),
                      )
                    : SizedBox.shrink(),
              ),
              SizedBox(
                height: 8.0.h,
              ),
              Obx(
                () => IconButton(
                  color: controller.bgmIsPlaying
                      ? Palette.WHITE60
                      : Palette.WHITE24,
                  icon: Icon(FontAwesomeIcons.headphonesAlt),
                  iconSize: 24.0.sp,
                  onPressed: () => controller.bgmIsPlaying
                      ? Flame.bgm.pause()
                      : Flame.bgm.resume(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget offlineButtons() {
    return Wrap(
      alignment: WrapAlignment.end,
      crossAxisAlignment: WrapCrossAlignment.start,
      direction: Axis.vertical,
      verticalDirection: VerticalDirection.down,
      runSpacing: 16.0,
      children: [
        FlatButtonX(
          onPressed: () async {
            Get.toNamed(Routes.LOGIN);
          },
          highlightColor: Colors.transparent,
          splashColor: Palette.BACKGROUND_LIGHT,
          child: Text(
            "Login",
            style: TextStyle(fontSize: 18.sp),
          ),
        ),
        FlatButtonX(
          onPressed: () {},
          highlightColor: Colors.transparent,
          splashColor: Palette.BACKGROUND_LIGHT,
          child: Text(
            "Tutorial",
            style: TextStyle(fontSize: 18.sp),
          ),
        ),
        FlatButtonX(
          onPressed: () {},
          highlightColor: Colors.transparent,
          splashColor: Palette.BACKGROUND_LIGHT,
          child: Text(
            "Settings",
            style: TextStyle(
              fontSize: 18.sp,
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
              fontSize: 18.sp,
              color: Palette.WHITE60,
            ),
          ),
        ),
      ],
    );
  }

  Widget onlineButtons() {
    return Wrap(
      alignment: WrapAlignment.end,
      crossAxisAlignment: WrapCrossAlignment.start,
      direction: Axis.vertical,
      verticalDirection: VerticalDirection.down,
      runSpacing: 8.0.w,
      children: [
        FlatButtonX(
          onPressed: () async {
            Get.toNamed(Routes.JOIN_ROOM);
          },
          highlightColor: Colors.transparent,
          splashColor: Palette.BACKGROUND_LIGHT,
          child: Text(
            "Join",
            style: TextStyle(fontSize: 18.sp),
          ),
        ),
        FlatButtonX(
          onPressed: () => Database.createNewRoom(AuthController.c.user),
          highlightColor: Colors.transparent,
          splashColor: Palette.BACKGROUND_LIGHT,
          child: Text(
            "Create",
            style: TextStyle(fontSize: 18.sp),
          ),
        ),
        FlatButtonX(
          onPressed: () {},
          highlightColor: Colors.transparent,
          splashColor: Palette.BACKGROUND_LIGHT,
          child: Text(
            "Tutorial",
            style: TextStyle(fontSize: 18.sp),
          ),
        ),
        FlatButtonX(
          onPressed: () {},
          highlightColor: Colors.transparent,
          splashColor: Palette.BACKGROUND_LIGHT,
          child: Text(
            "Settings",
            style: TextStyle(
              fontSize: 18.sp,
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
              fontSize: 18.sp,
              color: Palette.WHITE60,
            ),
          ),
        ),
      ],
    );
  }
}

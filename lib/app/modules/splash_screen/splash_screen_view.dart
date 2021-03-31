import 'package:flame_splash_screen/flame_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heist_squad_x/app/modules/splash_screen/splash_screen_controller.dart';
import 'package:heist_squad_x/app/routes/app_pages.dart';
import 'package:heist_squad_x/app/theme/app_theme.dart';
import 'package:heist_squad_x/app/theme/color_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashScreenView extends GetView<SplashScreenController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.BACKGROUND_DARK,
      body: FlameSplashScreen(
        showBefore: (ctx) {
          return Text(
            "Made with ❤ in Egypt",
            style: TextStyle(
              color: Palette.WHITE,
              fontSize: 14.0.sp,
            ),
          );
        },
        showAfter: (ctx) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Powered by",
                style: TextStyle(
                  color: Palette.WHITE,
                  fontSize: 14.0.sp,
                ),
              ),
              SizedBox(
                height: 8.0.h,
              ),
              Image(
                width: 120.0.w,
                image: const AssetImage(
                  'assets/flame-logo-black.gif',
                  package: 'flame_splash_screen',
                ),
              ),
            ],
          );
        },
        theme: SplashTheme.dark,
        onFinish: (ctx) {
          Get.offNamed(Routes.HOME);
        },
        controller: controller.splashController,
      ),
    );
  }
}

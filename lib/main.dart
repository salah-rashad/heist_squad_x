import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flame/flame.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heist_squad_x/app/data/service/game_socket_manager.dart';
import 'package:heist_squad_x/app/theme/app_theme.dart';
import 'package:wakelock/wakelock.dart';

import 'app/data/provider/auth.dart';
import 'app/data/service/connection_service.dart';
import 'app/routes/app_pages.dart';
import 'initial_binding.dart';

double tileSize = 48.0;
double tileSizeResponsive = tileSize.w;

Rx<bool> isSplash = true.obs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var device = Flame.device;

  if (!kIsWeb) {
    await device.setLandscape();
    await device.fullScreen();
  }

  HttpOverrides.global = new MyHttpOverrides();

  GameSocketManager.configure('http://heist-squad.herokuapp.com');
  // ChatSocketManager.configure('http://heist-squad-chat.herokuapp.com');

  FlameAudio.bgm.initialize();

  await Firebase.initializeApp();

  Wakelock.enable();

  runApp(
    ScreenUtilInit(
      designSize: Size(392.72727272727275, 850.9090909090909),
      builder: () {
        return GetMaterialApp(
          title: "Heist Squad",
          debugShowCheckedModeBanner: false,
          theme: AppTheme.appTheme,
          getPages: AppPages.routes,
          initialRoute: AppPages.INITIAL,
          initialBinding: InitialBinding(),
          builder: (context, child) => Obx(
            () => isSplash.value ? child! : buildStats(context, child!),
          ),
        );
      },
    ),
  );
}

Widget buildStats(BuildContext context, Widget child) {
  // print("width: " + MediaQuery.of(context).size.width.toString());
  // print("height: " + MediaQuery.of(context).size.height.toString());

  return Stack(
    children: [
      child,
      IgnorePointer(
        child: Material(
          color: Colors.transparent,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 4.0,
                      horizontal: 32.0,
                    ),
                    child: Obx(() => Text(
                          Auth.i.firebaseUser != null
                              ? "UID: " + Auth.i.firebaseUser!.uid
                              : "OFFLINE",
                          style: TextStyle(fontSize: 9, color: Colors.white),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 4.0, horizontal: 32.0),
                    child: Obx(() => Text(
                          Conn.status,
                          style: TextStyle(fontSize: 9, color: Colors.white),
                        )),
                  ),
                  const Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 4.0, horizontal: 32.0),
                    child: Text(
                      "v0.1.0",
                      style: TextStyle(fontSize: 9, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      )
    ],
  );
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

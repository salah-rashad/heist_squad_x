import 'package:firebase_core/firebase_core.dart';
import 'package:flame/flame.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:heist_squad_x/app/data/service/socket_manager.dart';
import 'package:heist_squad_x/app/theme/app_theme.dart';
import 'package:wakelock/wakelock.dart';

import 'app/data/service/connection_service.dart';
import 'app/routes/app_pages.dart';
import 'initial_binding.dart';

const double tileSize = 35;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var util = Flame.util;

  if (!kIsWeb) {
    await util.setLandscape();
    await util.fullScreen();

    await util.setOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  SocketManager.configure('http://heist-squad.herokuapp.com');

  Flame.bgm.initialize();
  await Firebase.initializeApp();

  Wakelock.enable();

  runApp(
    GetMaterialApp(
      title: "Heist Squad",
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      getPages: AppPages.routes,
      initialRoute: AppPages.INITIAL,
      initialBinding: InitialBinding(),
      builder: (context, child) => MyApp(child),
    ),
  );
}

class MyApp extends StatelessWidget {
  final Widget child;

  const MyApp(this.child);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        IgnorePointer(
          child: Material(
            color: Colors.transparent,
            child: Row(
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
            ),
          ),
        )
      ],
    );
  }
}

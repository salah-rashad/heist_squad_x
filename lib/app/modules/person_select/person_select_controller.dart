// import 'package:bonfire/bonfire.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:get/get.dart';
// import 'package:heist_squad_x/app/data/service/game_socket_manager.dart';
// import 'package:heist_squad_x/app/data/service/connection_service.dart';
// import 'package:heist_squad_x/app/modules/game_view/game_controller.dart';
// import 'package:heist_squad_x/game/player/sprite_sheet_hero.dart';
// import 'package:heist_squad_x/app/routes/app_pages.dart';

// class PersonSelectController extends GetxController {
//   RxInt _count = 0.obs;
//   RxList<SpriteSheet> _sprites = <SpriteSheet>[].obs;
//   RxBool _loading = false.obs;
//   TextEditingController nicknameTextController = TextEditingController();

//   int get count => this._count.value;
//   set count(int value) => this._count.value = value;

//   List<SpriteSheet> get sprites => this._sprites;
//   set sprites(value) => this._sprites.assignAll(value);

//   bool get loading => this._loading.value;
//   set loading(bool value) => this._loading.value = value;

//   String get nickname => this.nicknameTextController.text;
//   set nickname(String value) => this.nicknameTextController.text = value;

//   @override
//   void onInit() {
//     // nick = 'Nick${Random().nextInt(1000)}';
//     nickname = "Bemo";
//     sprites.add(SpriteSheetHero.hero1);
//     sprites.add(SpriteSheetHero.hero2);
//     sprites.add(SpriteSheetHero.hero3);
//     sprites.add(SpriteSheetHero.hero4);
//     sprites.add(SpriteSheetHero.hero5);

//     // Conn.connect();

//     super.onInit();
//   }

//   void next() {
//     if (count < sprites.length - 1) {
//       count++;
//     }
//   }

//   void previous() {
//     if (count > 0) {
//       count--;
//     }
//   }

  
// }

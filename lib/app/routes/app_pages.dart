import 'package:get/get.dart';
import 'package:heist_squad_x/app/modules/auth/login/login_binding.dart';
import 'package:heist_squad_x/app/modules/auth/login/login_view.dart';
import 'package:heist_squad_x/app/modules/game_view/game_binding.dart';
import 'package:heist_squad_x/app/modules/game_view/game_view.dart';
import 'package:heist_squad_x/app/modules/home/home_binding.dart';
import 'package:heist_squad_x/app/modules/home/home_view.dart';
import 'package:heist_squad_x/app/modules/person_select/person_select_binding.dart';
import 'package:heist_squad_x/app/modules/person_select/person_select_view.dart';
import 'package:heist_squad_x/app/modules/splash_screen/splash_screen_binding.dart';
import 'package:heist_squad_x/app/modules/splash_screen/splash_screen_view.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.SPLASH_SCREEN;

  static final routes = [
    GetPage(
      name: Routes.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.SPLASH_SCREEN,
      page: () => SplashScreenView(),
      binding: SplashScreenBinding(),
    ),
    GetPage(
      name: Routes.PERSON_SELECT,
      page: () => PersonSelectView(),
      binding: PersonSelectBinding(),
    ),
    GetPage(
      name: Routes.GAME,
      page: () => GameView(),
      binding: GameBinding(),
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
  ];
}

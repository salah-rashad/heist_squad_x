import 'package:flame_splash_screen/flame_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'color_theme.dart';

ThemeData get appTheme => ThemeData(
      scaffoldBackgroundColor: Palette.BACKGROUND_DARK,
      primaryColor: Palette.BLUE,
      primaryColorDark: Palette.BLUE2,
      fontFamily: GoogleFonts.cutiveMono().fontFamily,
      platform: TargetPlatform.iOS,
      textTheme: GoogleFonts.cutiveMonoTextTheme().apply(
        bodyColor: Palette.WHITE,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderSide: BorderSide.none),
        filled: true,
        fillColor: Palette.BACKGROUND_LIGHT.withOpacity(0.5),
        contentPadding: EdgeInsets.symmetric(
          vertical: 8.0,
          horizontal: 16.0,
        ),
      ),
      colorScheme: ColorScheme(
        primary: Palette.BLUE,
        primaryVariant: Palette.BLUE2,
        secondary: Palette.GREEN,
        secondaryVariant: Palette.GREEN2,
        surface: Palette.BACKGROUND_LIGHT,
        background: Palette.BACKGROUND_DARK,
        error: Palette.RED,
        onPrimary: Palette.WHITE,
        onSecondary: Palette.BLACK,
        onSurface: Palette.BLACK,
        onBackground: Palette.WHITE60,
        onError: Palette.BLACK,
        brightness: Brightness.dark,
      ),
      buttonTheme: ButtonThemeData(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          primary: Palette.WHITE60,
        ),
      ),
      hintColor: Palette.WHITE24,
    );

class SplashTheme {
  static FlameSplashTheme light = FlameSplashTheme(
    backgroundDecoration: const BoxDecoration(color: Color(0xFFFFFFFF)),
    logoBuilder: (ctx) => Image.asset(
      'assets/logo/logo_dark.png',
      width: 300,
    ),
  );

  static FlameSplashTheme dark = FlameSplashTheme(
    backgroundDecoration: const BoxDecoration(color: Color(0xFF000000)),
    logoBuilder: (ctx) => Image.asset(
      'assets/logo/logo_light.png',
      width: 300,
    ),
  );
}

import 'package:flame_splash_screen/flame_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'color_theme.dart';

class AppTheme {
  static ThemeData get appTheme => ThemeData(
        scaffoldBackgroundColor: Palette.BACKGROUND_DARK,
        primaryColor: Palette.BLUE,
        primaryColorDark: Palette.BLUE2,
        fontFamily: GoogleFonts.cutiveMono().fontFamily,
        platform: TargetPlatform.iOS,
        brightness: Brightness.dark,
        textTheme: GoogleFonts.cutiveMonoTextTheme(
          TextTheme(
            button: TextStyle(fontWeight: FontWeight.bold),
          ),
        ).apply(
          bodyColor: Palette.WHITE,
          fontSizeFactor: 1.0,
        ),
        highlightColor: Palette.TRANSPARENT,
        inputDecorationTheme: inputDecorationTheme,
        colorScheme: colorScheme,
        buttonTheme: ButtonThemeData(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            primary: Palette.WHITE60,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            primary: Palette.BLUE,
          ),
        ),
        disabledColor: Palette.WHITE24,
        hintColor: Palette.WHITE24,
        indicatorColor: Palette.ORANGE,
      );

  static ColorScheme get colorScheme => ColorScheme(
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
      );

  static InputDecorationTheme get inputDecorationTheme => InputDecorationTheme(
        border: OutlineInputBorder(borderSide: BorderSide.none),
        filled: true,
        fillColor: Palette.BACKGROUND_LIGHT.withOpacity(0.5),
        contentPadding: EdgeInsets.symmetric(
          vertical: 8.0,
          horizontal: 16.0,
        ),
      );
}

class SplashTheme {
  static FlameSplashTheme light = FlameSplashTheme(
    backgroundDecoration: const BoxDecoration(color: Color(0xFFFFFFFF)),
    logoBuilder: (ctx) => Image.asset(
      'assets/logo/logo_dark.png',
      width: 300,
    ),
  );

  static FlameSplashTheme dark = FlameSplashTheme(
    backgroundDecoration: const BoxDecoration(color: Palette.BACKGROUND_DARK),
    logoBuilder: (ctx) => Image.asset(
      'assets/logo/logo_light.png',
      width: 300,
    ),
  );
}

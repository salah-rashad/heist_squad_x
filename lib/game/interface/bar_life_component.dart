import 'dart:math';
import 'dart:ui';

import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heist_squad_x/app/theme/color_theme.dart';
import 'package:heist_squad_x/game/player/game_player.dart';

class BarLifeComponent extends InterfaceComponent {
  double padding = 20;
  double widthBar = 120.0.r;
  double strokeWidth = 18.0.r;

  double maxLife = 0;
  double life = 0;
  double maxLoad = 0;
  double load = 0;

  bool isAnimating = false;

  BarLifeComponent()
      : super(
          id: 3,
          position: Position(20, 20),
          sprite: null,
          width: 120.r,
          height: 40.r,
        );

  @override
  void update(double t) {
    if (this.gameRef.player != null && !isAnimating) {
      isAnimating = true;
      gameRef
          .getValueGenerator(
            Duration(milliseconds: 1000),
            begin: life,
            end: this.gameRef.player.life,
            onChange: (value) {
              life = value;
              maxLife = this.gameRef.player.maxLife;
            },
            onFinish: () => isAnimating = false,
            curve: Curves.easeOutCirc,
          )
          .start();

      if (this.gameRef.player is GamePlayer) {
        GamePlayer player = this.gameRef.player;
        gameRef.getValueGenerator(
          Duration(milliseconds: 1000),
          begin: load,
          end: player.load,
          onChange: (value) {
            load = value;
            maxLoad = player.maxLoad;
          },
          curve: Curves.easeOutCirc,
        ).start();
      }
    }

    super.update(t);
  }

  @override
  void render(Canvas c) {
    try {
      _drawLife(c);
      _drawLoad(c);
    } catch (e) {}
    super.render(c);
  }

  void _drawLife(Canvas canvas) {
    double xBar = 48.r;
    double yBar = 31.5.r;

    double currentBarLife = (life * widthBar) / maxLife;

    // Draw HP Background Line
    canvas.drawLine(
      Offset(xBar, yBar),
      Offset(xBar + widthBar, yBar),
      Paint()
        ..color = Palette.BACKGROUND_DARK
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.fill
        ..strokeCap = StrokeCap.round,
    );

    // Draw HP Shadow Line
    double elevation = 5.0;

    canvas.drawLine(
      Offset(xBar, yBar),
      Offset(xBar + currentBarLife, yBar),
      Paint()
        ..color = _getColorLife(currentBarLife).withOpacity(0.3)
        ..strokeWidth = strokeWidth + elevation
        ..style = PaintingStyle.fill
        ..strokeCap = StrokeCap.round
        ..imageFilter = ImageFilter.blur(sigmaX: elevation, sigmaY: elevation),
    );

    // Draw HP Line

    canvas.drawLine(
      Offset(xBar, yBar),
      Offset(xBar + currentBarLife, yBar),
      Paint()
        ..color = _getColorLife(currentBarLife)
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.fill
        ..strokeCap = StrokeCap.round,
    );

    String text = "${life.round()}/${maxLife.round()} HP";

    TextConfig config = TextConfig(
      color: Palette.WHITE,
      fontSize: 12.sp,
      textAlign: TextAlign.right,
    );

    Size txtSize = config.toTextPainter(text).size;

    gameRef.interface.add(TextInterfaceComponent(
      text: text,
      id: 5,
      width: txtSize.width,
      position: Position(
        max(xBar, xBar + currentBarLife * 0.5 - txtSize.width * 0.5),
        yBar - txtSize.height * 0.5,
      ),
      textConfig: config,
    ));
  }

  void _drawLoad(Canvas canvas) {
    double xBar = 48.r;
    double yBar = 55.r;

    double currentBarLoad = (load * widthBar) / maxLoad;

    // Draw Shadow line
    double elevation = 5.0;

    canvas.drawLine(
      Offset(xBar, yBar),
      Offset(xBar + currentBarLoad, yBar),
      Paint()
        ..color = Palette.BLUE2.withOpacity(0.3)
        ..strokeWidth = strokeWidth + elevation
        ..style = PaintingStyle.fill
        ..strokeCap = StrokeCap.round
        ..imageFilter = ImageFilter.blur(
          sigmaX: elevation,
          sigmaY: elevation,
        ),
    );

    // Draw Load Progress Line
    canvas.drawLine(
      Offset(xBar, yBar),
      Offset(xBar + currentBarLoad, yBar),
      Paint()
        ..color = Palette.BLUE2
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.fill
        ..strokeCap = StrokeCap.round,
    );

    String text = "${load.round()}/${maxLoad.round()} KG";

    TextConfig config = TextConfig(
      color: Palette.WHITE,
      fontSize: 12.sp,
      textAlign: TextAlign.right,
    );

    Size txtSize = config.toTextPainter(text).size;

    gameRef.interface.add(TextInterfaceComponent(
      text: text,
      id: 6,
      position: Position(
        max(xBar, xBar + currentBarLoad * 0.5 - txtSize.width * 0.5),
        yBar - txtSize.height * 0.5,
      ),
      textConfig: config,
    ));
  }

  String toStringReplaceFirstZiros(String text) {
    if (text.length == 1) return text;

    List<String> output = <String>[];

    for (var i = 0; i < text.length; i++) {
      if (text[0] == '0') {
        output.add('k');
      }
      if (int.tryParse(text[i - 1]) > 0)
        output.add(text[i]);
      else
        output.add('k');
    }

    return output.join();
  }

  Color _getColorLife(double currentBarLife) {
    if (currentBarLife > widthBar - (widthBar / 3)) {
      return Palette.GREEN;
    }
    if (currentBarLife > (widthBar / 3)) {
      return Palette.YELLOW;
    } else {
      return Palette.RED;
    }
  }
}

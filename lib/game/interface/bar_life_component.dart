import 'dart:math';
import 'dart:ui';

import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/src/extensions/num_extensions.dart';
import 'package:heist_squad_x/app/theme/color_theme.dart';
import 'package:heist_squad_x/game/player/game_player.dart';

class BarLifeComponent extends InterfaceComponent {
  // double padding = 20;
  double barWidth = 80.0.w;
  double barHeight = 32.0.h;

  Vector2 get lifePosition => Vector2.all(42.0);
  Vector2 get loadPosition => Vector2(lifePosition.x, lifePosition.y * 1.8);

  double get currentBarLife => (life * barWidth) / maxLife;
  double get currentBarLoad => (load * barWidth) / maxLoad;

  double maxLife = 0;
  double life = 0;
  double maxLoad = 0;
  double load = 0;

  bool isAnimating = false;

  BarLifeComponent()
      : super(
          id: 3,
          position: Vector2.zero(),
          sprite: null,
          width: 0.0,
          height: 0.0,
        );

  @override
  void update(double t) {
    if (this.gameRef.player != null && !isAnimating) {
      isAnimating = true;
      gameRef
          .getValueGenerator(
            1.seconds,
            begin: life,
            end: this.gameRef.player!.life,
            onChange: (value) {
              life = value;
              maxLife = this.gameRef.player!.maxLife;
            },
            onFinish: () => isAnimating = false,
            curve: Curves.easeOutCirc,
          )
          .start();

      if (this.gameRef.player is GamePlayer) {
        GamePlayer? player = gameRef.player as GamePlayer?;
        gameRef.getValueGenerator(
          1.seconds,
          begin: load,
          end: player!.load,
          onChange: (value) {
            load = value;
            maxLoad = player.maxLoad!;
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
    } catch (e) {
      print(e);
    }
    super.render(c);
  }

  void _drawLife(Canvas canvas) {
    // Draw HP Background Line
    canvas.drawLine(
      lifePosition.toOffset(),
      lifePosition.toOffset().translate(barWidth, 0.0),
      Paint()
        ..color = Palette.BACKGROUND_DARK
        ..strokeWidth = barHeight
        ..style = PaintingStyle.fill
        ..strokeCap = StrokeCap.round,
    );

    // Draw HP Shadow Line
    double elevation = 5.0;

    canvas.drawLine(
      lifePosition.toOffset(),
      lifePosition.toOffset().translate(currentBarLife, 0.0),
      Paint()
        ..color = _getColorLife(currentBarLife).withOpacity(0.3)
        ..strokeWidth = barHeight + elevation
        ..style = PaintingStyle.fill
        ..strokeCap = StrokeCap.round
        ..imageFilter = ImageFilter.blur(sigmaX: elevation, sigmaY: elevation),
    );

    // Draw HP Line

    canvas.drawLine(
      lifePosition.toOffset(),
      lifePosition.toOffset().translate(currentBarLife, 0.0),
      Paint()
        ..color = _getColorLife(currentBarLife)
        ..strokeWidth = barHeight
        ..style = PaintingStyle.fill
        ..strokeCap = StrokeCap.round,
    );

    String text = "${life.round()}/${maxLife.round()} HP";

    TextStyle config = TextStyle(
      color: Palette.WHITE,
      fontSize: 14,
      // textAlign: TextAlign.right,
    );

    Vector2 txtSize = TextPaint(style: config).measureText(text);

    gameRef.interface!.add(TextInterfaceComponent(
      text: text,
      id: 5,
      // width: txtSize.width,
      position: Vector2(
        max(lifePosition.x,
            lifePosition.x + currentBarLife * 0.5 - txtSize.x * 0.5),
        lifePosition.y - txtSize.y * 0.5,
      ),
      textConfig: config,
    ));
  }

  void _drawLoad(Canvas canvas) {
    // Draw Shadow line
    double elevation = 5.0;

    // Draw HP Background Line
    canvas.drawLine(
      loadPosition.toOffset(),
      loadPosition.toOffset().translate(barWidth, 0.0),
      Paint()
        ..color = Palette.BACKGROUND_DARK
        ..strokeWidth = barHeight
        ..style = PaintingStyle.fill
        ..strokeCap = StrokeCap.round,
    );

    canvas.drawLine(
      loadPosition.toOffset(),
      loadPosition.toOffset().translate(currentBarLoad, 0.0),
      Paint()
        ..color = Palette.BLUE2.withOpacity(0.3)
        ..strokeWidth = barHeight + elevation
        ..style = PaintingStyle.fill
        ..strokeCap = StrokeCap.round
        ..imageFilter = ImageFilter.blur(
          sigmaX: elevation,
          sigmaY: elevation,
        ),
    );

    // Draw Load Progress Line
    canvas.drawLine(
      loadPosition.toOffset(),
      loadPosition.toOffset().translate(currentBarLoad, 0.0),
      Paint()
        ..color = Palette.BLUE2
        ..strokeWidth = barHeight
        ..style = PaintingStyle.fill
        ..strokeCap = StrokeCap.round,
    );

    String text = "${load.round()}/${maxLoad.round()} KG";

    TextStyle config = TextStyle(
      color: Palette.WHITE,
      fontSize: 14,
      // textAlign: TextAlign.right,
    );

    Vector2 txtSize = TextPaint(style: config).measureText(text);

    gameRef.interface!.add(TextInterfaceComponent(
      text: text,
      id: 6,
      position: Vector2(
        max(loadPosition.x,
            loadPosition.x + currentBarLoad * 0.5 - txtSize.x * 0.5),
        loadPosition.y - txtSize.y * 0.5,
      ),
      textConfig: config,
    ));
  }

  String toStringReplaceFirstZeros(String text) {
    if (text.length == 1) return text;

    List<String> output = <String>[];

    for (var i = 0; i < text.length; i++) {
      if (text[0] == '0') {
        output.add('k');
      }
      if (int.tryParse(text[i - 1])! > 0)
        output.add(text[i]);
      else
        output.add('k');
    }

    return output.join();
  }

  Color _getColorLife(double currentBarLife) {
    if (currentBarLife > barWidth - (barWidth / 3)) {
      return Palette.GREEN;
    }
    if (currentBarLife > (barWidth / 3)) {
      return Palette.YELLOW;
    } else {
      return Palette.RED;
    }
  }
}

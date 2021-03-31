import 'package:flutter/material.dart';

import 'color_filter_generator.dart';

class ImageFilter extends StatelessWidget {
  final double brightness;
  final double saturation;
  final double hue;
  final Widget child;

  const ImageFilter({this.brightness, this.saturation, this.hue, this.child});

  @override
  Widget build(BuildContext context) {
    return ColorFiltered(
        colorFilter:
            ColorFilter.matrix(ColorFilterGenerator.brightnessAdjustMatrix(
          value: brightness,
        )),
        child: ColorFiltered(
            colorFilter:
                ColorFilter.matrix(ColorFilterGenerator.saturationAdjustMatrix(
              value: saturation,
            )),
            child: ColorFiltered(
              colorFilter:
                  ColorFilter.matrix(ColorFilterGenerator.hueAdjustMatrix(
                value: hue,
              )),
              child: child,
            )));
  }
}

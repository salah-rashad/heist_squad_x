// Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';

import 'image_filter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double h = 0.0;
  double s = 0.0;
  double b = 0.0;

  double slider1 = 50;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 100.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: <Widget>[
                ImageFilter(
                  hue: h,
                  saturation: s,
                  brightness: b,
                  child: Image.network(
                      'https://i.imgur.com/9Bbt8U5.png'), // clothes
                ),
                ImageFilter(
                  hue: 0.0,
                  brightness: 0.0,
                  saturation: 0.0,
                  child:
                      Image.network('https://i.imgur.com/SV0oK2K.png'), // hair
                ),
                ImageFilter(
                  hue: 0.0,
                  brightness: 0.0,
                  saturation: 0.0,
                  child:
                      Image.network('https://i.imgur.com/Q4DCtNA.png'), // skin
                ),
                ImageFilter(
                  hue: 0.0,
                  brightness: 0.0,
                  saturation: 0.0,
                  child:
                      Image.network('https://i.imgur.com/56lLZY8.png'), // shoes
                ),
              ],
            ),
            SizedBox(height: 32.0),
            FlutterSlider(
              values: [slider1],
              fixedValues: [
                FlutterSliderFixedValue(percent: 0, value: -1.0),
                FlutterSliderFixedValue(percent: 25, value: -0.5),
                FlutterSliderFixedValue(percent: 50, value: 0.0),
                FlutterSliderFixedValue(percent: 75, value: 0.5),
                FlutterSliderFixedValue(percent: 100, value: 1.0),
              ],
              trackBar: FlutterSliderTrackBar(
                inactiveTrackBar: BoxDecoration(
                  color: Colors.white,
                  gradient: LinearGradient(colors: [
                    Colors.blue,
                    Colors.red,
                    Colors.green,
                  ]),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                activeTrackBar: BoxDecoration(color: Colors.transparent),
                inactiveTrackBarHeight: 16.0,
              ),
              handler:
                  FlutterSliderHandler(child: Icon(Icons.drag_handle_rounded)),
              onDragCompleted: (handlerIndex, lowerValue, upperValue) {
                setState(() {
                  
                  h = lowerValue;
                });
              },
            ),
            Slider(
              label: "S",
              min: -1.0,
              max: 1.0,
              value: s,
              onChanged: (value) {
                setState(() {
                  s = value;
                });
              },
            ),
            Slider(
              label: "B",
              min: -1.0,
              max: 1.0,
              value: b,
              onChanged: (value) {
                setState(() {
                  b = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

class GradientRectSliderTrackShape extends SliderTrackShape
    with BaseSliderTrackShape {
  /// Based on https://www.youtube.com/watch?v=Wl4F5V6BoJw
  /// Create a slider track that draws two rectangles with rounded outer edges.
  final LinearGradient gradient;
  final bool darkenInactive;
  const GradientRectSliderTrackShape(
      {this.gradient:
          const LinearGradient(colors: [Colors.lightBlue, Colors.blue]),
      this.darkenInactive: true});

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    @required RenderBox parentBox,
    @required SliderThemeData sliderTheme,
    @required Animation<double> enableAnimation,
    @required TextDirection textDirection,
    @required Offset thumbCenter,
    bool isDiscrete = false,
    bool isEnabled = false,
    double additionalActiveTrackHeight = 2,
  }) {
    assert(context != null);
    assert(offset != null);
    assert(parentBox != null);
    assert(sliderTheme != null);
    assert(sliderTheme.disabledActiveTrackColor != null);
    assert(sliderTheme.disabledInactiveTrackColor != null);
    assert(sliderTheme.activeTrackColor != null);
    assert(sliderTheme.inactiveTrackColor != null);
    assert(sliderTheme.thumbShape != null);
    assert(enableAnimation != null);
    assert(textDirection != null);
    assert(thumbCenter != null);
    // If the slider [SliderThemeData.trackHeight] is less than or equal to 0,
    // then it makes no difference whether the track is painted or not,
    // therefore the painting  can be a no-op.
    if (sliderTheme.trackHeight <= 0) {
      return;
    }

    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    // Assign the track segment paints, which are leading: active and
    // trailing: inactive.
    final ColorTween activeTrackColorTween = ColorTween(
        begin: sliderTheme.disabledActiveTrackColor,
        end: sliderTheme.activeTrackColor);
    final ColorTween inactiveTrackColorTween = darkenInactive
        ? ColorTween(
            begin: sliderTheme.disabledInactiveTrackColor,
            end: sliderTheme.inactiveTrackColor)
        : activeTrackColorTween;
    final Paint activePaint = Paint()
      ..shader = gradient.createShader(trackRect)
      ..color = activeTrackColorTween.evaluate(enableAnimation);
    final Paint inactivePaint = Paint()
      ..shader = gradient.createShader(trackRect)
      ..color = inactiveTrackColorTween.evaluate(enableAnimation);
    Paint leftTrackPaint;
    Paint rightTrackPaint;
    switch (textDirection) {
      case TextDirection.ltr:
        leftTrackPaint = activePaint;
        rightTrackPaint = inactivePaint;
        break;
      case TextDirection.rtl:
        leftTrackPaint = inactivePaint;
        rightTrackPaint = activePaint;
        break;
    }
    final Radius trackRadius = Radius.circular(trackRect.height / 2);
    final Radius activeTrackRadius = Radius.circular(trackRect.height / 2 + 1);

    context.canvas.drawRRect(
      RRect.fromLTRBAndCorners(
        trackRect.left,
        (textDirection == TextDirection.ltr)
            ? trackRect.top - (additionalActiveTrackHeight / 2)
            : trackRect.top,
        thumbCenter.dx,
        (textDirection == TextDirection.ltr)
            ? trackRect.bottom + (additionalActiveTrackHeight / 2)
            : trackRect.bottom,
        topLeft: (textDirection == TextDirection.ltr)
            ? activeTrackRadius
            : trackRadius,
        bottomLeft: (textDirection == TextDirection.ltr)
            ? activeTrackRadius
            : trackRadius,
      ),
      leftTrackPaint,
    );
    context.canvas.drawRRect(
      RRect.fromLTRBAndCorners(
        thumbCenter.dx,
        (textDirection == TextDirection.rtl)
            ? trackRect.top - (additionalActiveTrackHeight / 2)
            : trackRect.top,
        trackRect.right,
        (textDirection == TextDirection.rtl)
            ? trackRect.bottom + (additionalActiveTrackHeight / 2)
            : trackRect.bottom,
        topRight: (textDirection == TextDirection.rtl)
            ? activeTrackRadius
            : trackRadius,
        bottomRight: (textDirection == TextDirection.rtl)
            ? activeTrackRadius
            : trackRadius,
      ),
      rightTrackPaint,
    );
  }
}

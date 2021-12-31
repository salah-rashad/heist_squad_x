import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class LoadingWidget extends StatelessWidget {
  final double size;
  final Color? color;

  const LoadingWidget({Key? key, required this.size, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SpinKitSquareCircle(
          color: color ?? Colors.white,
          size: size,
          duration: 1.5.seconds,
        ),
        SizedBox(height: 32.0),
        Text(
          "LOADING...",
        )
      ],
    );
  }
}

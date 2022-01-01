import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heist_squad_x/app/theme/app_theme.dart';

class FlatButtonX extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color? primary;

  final Widget child;

  const FlatButtonX({
    Key? key,
    this.onPressed,
    required this.child,
    this.primary,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      key: key,
      onPressed: onPressed,
      child: child,
      style: TextButton.styleFrom(
        primary: primary ?? Colors.white60,
        textStyle: Get.textTheme.button?.copyWith(fontSize: 18.0),
      ),
    );
  }
}

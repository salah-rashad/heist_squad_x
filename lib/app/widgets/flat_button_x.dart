import 'package:flutter/material.dart';
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
        primary: primary ?? Colors.white,
        textStyle: AppTheme.appTheme.textTheme.bodyText2?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

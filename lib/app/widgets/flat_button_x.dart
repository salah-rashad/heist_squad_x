import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FlatButtonX extends StatelessWidget {
  final VoidCallback onPressed;
  final VoidCallback onLongPress;
  final ValueChanged<bool> onHighlightChanged;
  final MouseCursor mouseCursor;
  final ButtonTextTheme textTheme;
  final Color textColor;
  final Color disabledTextColor;
  final Color color;
  final Color disabledColor;
  final Color splashColor;
  final Color focusColor;
  final Color hoverColor;
  final Color highlightColor;
  final double elevation;
  final double hoverElevation;
  final double focusElevation;
  final double highlightElevation;
  final double disabledElevation;
  final Brightness colorBrightness;
  final Widget child;
  bool get enabled => onPressed != null || onLongPress != null;
  final EdgeInsetsGeometry padding;
  final VisualDensity visualDensity;
  final ShapeBorder shape;
  final Clip clipBehavior;
  final FocusNode focusNode;
  final bool autofocus;
  final Duration animationDuration;
  final MaterialTapTargetSize materialTapTargetSize;
  final double minWidth;
  final double height;
  final bool enableFeedback;

  const FlatButtonX({
    Key key,
    @required this.onPressed,
    this.onLongPress,
    this.onHighlightChanged,
    this.mouseCursor,
    this.textTheme,
    this.textColor,
    this.disabledTextColor,
    this.color,
    this.disabledColor,
    this.focusColor,
    this.hoverColor,
    this.highlightColor,
    this.splashColor,
    this.colorBrightness,
    this.padding,
    this.visualDensity,
    this.shape,
    this.clipBehavior = Clip.none,
    this.focusNode,
    this.autofocus = false,
    this.materialTapTargetSize,
    @required this.child,
    this.height,
    this.minWidth,
    this.animationDuration,
    this.disabledElevation,
    this.elevation,
    this.enableFeedback,
    this.focusElevation,
    this.highlightElevation,
    this.hoverElevation,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: child,
      autofocus: autofocus,
      clipBehavior: clipBehavior,
      focusNode: focusNode,
      key: key,
      onLongPress: onLongPress,
      style: getStyle,
    );
  }

  ButtonStyle get getStyle => ButtonStyle(
      overlayColor: MaterialStateProperty.resolveWith<Color>(
        (states) {
          if (states.contains(MaterialState.pressed)) return this.splashColor;
          if (states.contains(MaterialState.focused)) return this.focusColor;
          if (states.contains(MaterialState.disabled))
            return this.disabledColor;
          if (states.contains(MaterialState.hovered))
            return this.hoverColor;
          else
            return null;
        },
      ),
      animationDuration: this.animationDuration,
      foregroundColor: MaterialStateProperty.resolveWith<Color>(
        (states) {
          if (states.contains(MaterialState.disabled))
            return this.disabledTextColor;
          else
            return this.textColor;
        },
      ),
      backgroundColor: MaterialStateProperty.all(color),
      minimumSize:
          MaterialStateProperty.all(Size(minWidth ?? 50.w, height ?? 20.0.h)));
}

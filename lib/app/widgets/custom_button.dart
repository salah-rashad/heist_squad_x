import 'package:flutter/material.dart';
import 'package:heist_squad_x/app/theme/color_theme.dart';

class CustomButton extends StatefulWidget {
  final Color topShadowColor;
  final Color bottomShadowColor;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final double width;
  final double height;
  final double radius;
  final Widget child;
  final VoidCallback? onTap;

  CustomButton({
    this.topShadowColor = Palette.BACKGROUND_LIGHT,
    this.bottomShadowColor = Palette.BACKGROUND_DARKER,
    this.margin = const EdgeInsets.all(0),
    this.padding = const EdgeInsets.all(0),
    this.width = 40,
    this.height = 40,
    this.radius = 30,
    required this.child,
    required this.onTap,
  });

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool tapping = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (d) {
        setState(() {
          tapping = true;
        });
      },
      onTapCancel: () {
        setState(() {
          tapping = false;
        });
      },
      onTapUp: (d) {
        setState(() {
          tapping = false;
        });
      },
      child: Container(
        margin: widget.margin,
        padding: widget.padding,
        height: widget.height,
        width: widget.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.radius),
            boxShadow: [
              BoxShadow(
                color:
                    tapping ? widget.bottomShadowColor : widget.topShadowColor,
                offset: Offset(-2, -2),
                spreadRadius: -2,
                blurRadius: 5,
              )
            ]),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.radius),
              color: Palette.BACKGROUND_DARK,
              boxShadow: [
                BoxShadow(
                  color: tapping
                      ? widget.topShadowColor
                      : widget.bottomShadowColor,
                  offset: Offset(2, 2),
                  spreadRadius: 0,
                  blurRadius: 5,
                )
              ]),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(widget.radius),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.onTap,
                splashColor: Colors.transparent,
                highlightColor: Palette.BACKGROUND_DARKER.withOpacity(0.5),
                child: Center(
                  child: widget.child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

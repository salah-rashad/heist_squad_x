import 'package:auto_direction/auto_direction.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:heist_squad_x/app/theme/color_theme.dart';



extension INPUT_ONTAP on TextField {
  Widget fullScreen(
    BuildContext context, {
    Function(String text) onDone,
    String buttonText = "Done",
  }) {
    return Stack(
      children: [
        IgnorePointer(
          child: this,
        ),
        Positioned.fill(
          child: GestureDetector(
            onTap: () => Get.dialog(
                _dialog(
                  // context,
                  this.controller,
                  onDone,
                  buttonText,
                  this.decoration.hintText,
                ),
                useSafeArea: false,
                barrierDismissible: true,
                barrierColor: Palette.BLACK),
          ),
        ),
      ],
    );
  }
}

Widget _dialog(
  // BuildContext context,
  TextEditingController controller,
  Function(String text) onDone,
  String buttonText,
  String hintText,
) =>
    StatefulBuilder(
      builder: (context, setState) {
        String text = controller.text;
        return Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Palette.BACKGROUND_LIGHT,
          body: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 40.0, vertical: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: AutoDirection(
                      text: text,
                      child: TextField(
                        controller: controller,
                        autofocus: true,
                        maxLines: null,
                        maxLength: 255,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(hintText: hintText),
                        onChanged: (value) => setState(() {
                          text = value;
                        }),
                      ),
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    MediaQuery.of(context).viewInsets.bottom.isGreaterThan(0)
                        ? IconButton(
                            icon: Icon(Icons.keyboard_hide_rounded),
                            onPressed: () => FocusScope.of(context).unfocus(),
                          )
                        : SizedBox.shrink(),
                    ElevatedButton.icon(
                      icon: Icon(Icons.send_rounded),
                      onPressed: () {
                        if (controller.text.length > 255)
                          return Fluttertoast.showToast(
                              msg:
                                  "Message must be no longer than 255 characters.");
                        Get.back();
                        try {
                          onDone(controller.text);
                        } catch (e) {
                          print(e);
                        }
                      },
                      label: Text(buttonText),
                      style: ElevatedButton.styleFrom(
                        primary: Palette.BACKGROUND_DARK,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );


extension StringExtensions on String {
  Size getSize(TextStyle style) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: this, style: style), maxLines: 1, textDirection: TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }
}
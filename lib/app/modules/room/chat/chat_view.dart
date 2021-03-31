import 'package:auto_direction/auto_direction.dart';
import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heist_squad_x/app/data/service/connection_service.dart';
import 'package:heist_squad_x/app/theme/color_theme.dart';

import 'chat_controller.dart';

class ChatView extends GetView<ChatController> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            color: Palette.BACKGROUND_LIGHT,
            child: Obx(
              () => Conn.status == "CONNECTED"
                  ? Obx(
                      () => ListView.builder(
                        padding: EdgeInsets.all(8.0),
                        controller: controller.scrollController,
                        itemCount: controller.messages.length,
                        itemBuilder: (context, index) {
                          final message = controller.messages[index];
                          bool isParentMsg = index == 0
                              ? true
                              : controller.messages[index - 1].nickname !=
                                  message.nickname;
                          if (message.nickname == "*")
                            return Text(
                              message.message,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12.0,
                                color: Palette.WHITE24,
                                height: 1.5,
                              ),
                            );
                          if (message.nickname == controller.nick) {
                            return Bubble(
                              margin: BubbleEdges.only(
                                top: isParentMsg ? 8.0 : 2.0,
                                bottom: 0.0,
                              ),
                              radius: Radius.circular(4.0),
                              alignment: Alignment.topRight,
                              nip: BubbleNip.rightTop,
                              showNip: isParentMsg,
                              elevation: 2,
                              color: Palette.BACKGROUND_DARKER,
                              child: AutoDirection(
                                text: message.message,
                                child: SelectableText(
                                  message.message,
                                  style: TextStyle(
                                    fontSize: 13,
                                    letterSpacing: -0.5,
                                    wordSpacing: -3.0,
                                  ),
                                ),
                              ),
                            );
                          }
                          return Bubble(
                            margin: BubbleEdges.only(
                              top: isParentMsg ? 8.0 : 2.0,
                              bottom: 0.0,
                            ),
                            radius: Radius.circular(4.0),
                            alignment: Alignment.topLeft,
                            nip: BubbleNip.leftTop,
                            showNip: isParentMsg,
                            color: Palette.WHITE24,
                            elevation: 0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                isParentMsg
                                    ? Text(
                                        message.nickname,
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Palette.BACKGROUND_LIGHT,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        textAlign: TextAlign.left,
                                      )
                                    : SizedBox.shrink(),
                                SelectableText(
                                  message.message,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    )
                  : Center(
                      child: Obx(() => Text(Conn.status)),
                    ),
            ),
          ),
        ),
        Container(
          child: TextField(
            enabled: false,
            controller: controller.messageController,
            style: TextStyle(fontSize: 12.0),
            decoration: InputDecoration(
              hintText: "Message...",
            ),
            maxLines: 1,
          ).fullScreen(context,
              onDone: (text) => controller.sendMessage(), buttonText: "Send"),
        ),
      ],
    );
  }
}

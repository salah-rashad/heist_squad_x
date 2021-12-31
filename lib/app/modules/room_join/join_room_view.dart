import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:heist_squad_x/app/data/model/room_model.dart';
import 'package:heist_squad_x/app/data/provider/database.dart';
import 'package:heist_squad_x/app/modules/room/room_view.dart';
import 'package:heist_squad_x/app/theme/color_theme.dart';
import 'package:heist_squad_x/app/util/futured.dart';

class JoinRoomView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          constraints: BoxConstraints(
            minHeight: Get.size.height,
            maxWidth: Get.size.width * 0.8,
          ),
          padding: const EdgeInsets.all(40.0),
          child: Column(
            children: [
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "JOIN ROOM",
                      style: TextStyle(fontSize: 22.0),
                    ),
                    IconButton(
                        onPressed: () {}, icon: Icon(Icons.refresh_rounded))
                  ],
                ),
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(bottom: 32.0),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      "ROOM NAME",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Palette.WHITE24,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "OWNER",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Palette.WHITE24,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "NO. OF PLAYERS",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Palette.WHITE24,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 16.0,
              ),
              Expanded(
                child: Futured<List<Room>?>(
                  future: Database.getRooms(),
                  hasData: (context, snapshot) {
                    List<Room> rooms = snapshot.data!;

                    return ListView.separated(
                      shrinkWrap: true,
                      itemCount: rooms.length,
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(
                          height: 8.0,
                        );
                      },
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      itemBuilder: (BuildContext context, int index) {
                        Room room = rooms[index];
                        return Material(
                          type: MaterialType.button,
                          color: Palette.BACKGROUND_LIGHT,
                          clipBehavior: Clip.antiAlias,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0)),
                          child: InkWell(
                            onTap: () => Get.to(
                              () => RoomView(room),
                              transition: Transition.fade,
                              preventDuplicates: true,
                            ),
                            child: SizedBox(
                              height: 56.0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        room.name!,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        room.ownerName ??
                                            room.ownerId ??
                                            "UnKnown",
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "${room.players!.length}/${room.maxPlayers}",
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  hasNoData: (context, snapshot) {
                    return Center(child: Text("No rooms found!"));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heist_squad_x/app/data/model/room_model.dart';
import 'package:heist_squad_x/app/data/provider/database.dart';
import 'package:heist_squad_x/app/modules/room/room_view.dart';
import 'package:heist_squad_x/app/theme/color_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
                child: Text(
                  "JOIN ROOM",
                  style: TextStyle(fontSize: 22.0.sp),
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
                        fontSize: 12.0.sp,
                        color: Palette.WHITE24,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "OWNER",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12.0.sp,
                        color: Palette.WHITE24,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "NO. OF PLAYERS",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12.0.sp,
                        color: Palette.WHITE24,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 16.0.h,
              ),
              Expanded(
                child: FutureBuilder<List<Room>>(
                  future: Database.getRooms(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData) {
                        List<Room> rooms = snapshot.data;

                        return ListView.separated(
                          shrinkWrap: true,
                          itemCount: rooms.length ?? 0,
                          separatorBuilder: (BuildContext context, int index) {
                            return SizedBox(
                              height: 8.0.h,
                            );
                          },
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          itemBuilder: (BuildContext context, int index) {
                            Room room = rooms[index];
                            return Stack(
                              children: [
                                InkWell(
                                  onTap: () {},
                                  child: TextButton(
                                    onPressed: () => Get.to(
                                      () => RoomView(room),
                                      transition: Transition.fade,
                                      preventDuplicates: true,
                                    ),
                                    style: TextButton.styleFrom(
                                      minimumSize: Size(
                                        double.maxFinite,
                                        56.0.h,
                                      ),
                                      backgroundColor: Palette.BACKGROUND_LIGHT,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              room.name,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              room.ownerId,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "${room.players.length}/${room.maxPlayers}",
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                // Positioned.fill(
                                //     child: InkWell(
                                //   onTap: () {},
                                // )),
                              ],
                            );
                          },
                        );
                      } else if (!snapshot.hasData)
                        return Text("No rooms found!");
                      else if (snapshot.hasError)
                        return Text("Error: ${snapshot.error}");
                      else
                        return Center(child: CircularProgressIndicator());
                    } else
                      return Center(child: CircularProgressIndicator());
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

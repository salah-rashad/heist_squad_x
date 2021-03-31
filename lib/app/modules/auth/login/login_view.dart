import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heist_squad_x/app/forms/login_form.dart';
import 'package:heist_squad_x/app/modules/auth/login/login_controller.dart';
import 'package:heist_squad_x/app/routes/app_pages.dart';
import 'package:heist_squad_x/app/theme/color_theme.dart';

class LoginView extends GetView<LoginController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(56.0),
          constraints: BoxConstraints(minHeight: Get.size.height),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: leftSide(),
              ),
              Expanded(
                flex: 1,
                child: SizedBox(),
              ),
              Expanded(
                flex: 3,
                child: rightSide(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget leftSide() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child: Text(
            "CREATE A NEW ACCOUNT",
            style: TextStyle(fontSize: 22.0),
          ),
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(bottom: 8.0),
        ),
        Container(
          child: Text(
            "Join the gangster world, create your own squad, cooperate together, \nbecome the best and gain the respect of other gangs.",
            style: TextStyle(fontSize: 16.0, color: Palette.WHITE60),
          ),
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(bottom: 16.0),
        ),
        ElevatedButton(
          onPressed: () => Get.toNamed(Routes.REGISTER),
          child: Text('CREATE'),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 32.0),
            minimumSize: Size(double.maxFinite, 55.0),
            primary: Palette.GREEN,
            onPrimary: Palette.BACKGROUND_DARK,
          ),
        ),
      ],
    );
  }

  Widget rightSide() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          child: Text(
            "LOGIN",
            style: TextStyle(fontSize: 22.0),
          ),
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(bottom: 32.0),
        ),
        LoginForm(),
      ],
    );
  }
}

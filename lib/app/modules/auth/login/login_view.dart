import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heist_squad_x/app/forms/login_form/login_form.dart';
import 'package:heist_squad_x/app/modules/auth/login/login_controller.dart';

class LoginView extends GetView<LoginController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Row(
          children: <Widget>[
            // leftSide(),
            loginForm(),
          ],
        ),
      ),
    );
  }

  Widget loginForm() {
    return Expanded(
        flex: 2,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                child: Text(
                  "LOGIN",
                  style: TextStyle(fontSize: 22.0),
                ),
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(bottom: 16.0),
              ),
              LoginForm(),
            ],
          ),
        ));
  }
}

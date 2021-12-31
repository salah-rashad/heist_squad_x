import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:heist_squad_x/app/data/provider/auth.dart';
import 'package:heist_squad_x/app/modules/auth/login/login_controller.dart';
import 'package:heist_squad_x/app/theme/color_theme.dart';
import 'package:heist_squad_x/app/widgets/flat_button_x.dart';

class LoginForm extends GetWidget<LoginController> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.loginFormKey,
      autovalidateMode: AutovalidateMode.disabled,
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: controller.emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: "Email",
              suffixIcon: Icon(
                FontAwesomeIcons.at,
                color: Palette.BACKGROUND_LIGHT,
              ),
              border: OutlineInputBorder(borderSide: BorderSide.none),
              filled: true,
              fillColor: Palette.BACKGROUND_LIGHT.withOpacity(0.5),
              contentPadding: EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 16.0,
              ),
            ),
            enableSuggestions: true,
            style: TextStyle(fontSize: 20),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Email is empty.';
              } else
                return null;
            },
          ),
          SizedBox(
            height: 16.0,
          ),
          TextFormField(
            controller: controller.passwordController,
            keyboardType: TextInputType.visiblePassword,
            decoration: InputDecoration(
              hintText: 'Password',
              suffixIcon: Icon(
                FontAwesomeIcons.lock,
                color: Palette.BACKGROUND_LIGHT,
              ),
            ),
            enableSuggestions: true,
            obscureText: true,
            style: TextStyle(fontSize: 20),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Password is empty.';
              } else
                return null;
            },
          ),
          SizedBox(
            height: 16.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FlatButtonX(
                onPressed: () {},
                child: Text(
                  "reset password".toUpperCase(),
                  style: TextStyle(
                    fontSize: 14,
                    // color: Palette.WHITE60,
                  ),
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    var formState = controller.loginFormKey.currentState;
                    if (formState!.validate()) {
                      formState.save();
                      Auth.i.loginUser(
                        controller.emailController.text,
                        controller.passwordController.text,
                      );
                    }
                  },
                  child: Text('LOGIN'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 32.0),
                  )),
            ],
          )
        ],
      ),
    );
  }
}

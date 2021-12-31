import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:heist_squad_x/app/modules/auth/register/register_controller.dart';
import 'package:heist_squad_x/app/theme/color_theme.dart';

class RegisterForm extends GetWidget<RegisterController> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.registerFormKey,
      autovalidateMode: AutovalidateMode.disabled,
      child: Column(
        children: <Widget>[
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: controller.nicknameController,
            keyboardType: TextInputType.text,
            smartDashesType: SmartDashesType.enabled,
            decoration: InputDecoration(
              hintText: "Nickname",
              suffixIcon: Icon(
                FontAwesomeIcons.userAlt,
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
              if (!GetUtils.isUsername(value!)) {
                return 'Nickname is invalid.';
              } else
                return null;
            },
          ),
          SizedBox(
            height: 16.0,
          ),
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
              if (!value!.isEmail) {
                return 'Email is invalid.';
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
              } else if (value.length < 8) {
                return 'Password must be at least 8 characters long.';
              } else
                return null;
            },
          ),
        ],
      ),
    );
  }
}

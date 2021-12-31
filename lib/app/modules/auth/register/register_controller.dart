import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum Weapon {
  crowbar,
  computer,
  hammer,
  knife,
}

class RegisterController extends GetxController {
  TextEditingController nicknameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final registerFormKey = new GlobalKey<FormState>();

  Rx<Weapon> _selectedWeapon = Weapon.crowbar.obs;
  
  Weapon get selectedWeapon => this._selectedWeapon.value;
  set selectedWeapon(Weapon value) => this._selectedWeapon.value = value;

  // List<String> weaponsNames = ["Crowbar", "Computer", "Hammer", "Knife"];
}

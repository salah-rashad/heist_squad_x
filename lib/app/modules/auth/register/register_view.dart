import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heist_squad_x/app/data/model/user_model.dart';
import 'package:heist_squad_x/app/data/provider/auth.dart';
import 'package:heist_squad_x/app/forms/register_form.dart';
import 'package:heist_squad_x/app/modules/auth/register/register_controller.dart';
import 'package:heist_squad_x/app/theme/color_theme.dart';

class RegisterView extends GetView<RegisterController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(56.0),
          constraints: BoxConstraints(minHeight: Get.size.height),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: registerForm(),
              ),
              Expanded(
                flex: 1,
                child: SizedBox(),
              ),
              Expanded(
                flex: 2,
                child: rightSide(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget registerForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Container(
        //   child: Text(
        //     "CREATE A NEW ACCOUNT",
        //     style: TextStyle(fontSize: 22.0),
        //   ),
        //   alignment: Alignment.centerLeft,
        //   padding: EdgeInsets.only(bottom: 32.0),
        // ),
        RegisterForm(),
      ],
    );
  }

  Widget rightSide() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ListView.builder(
          shrinkWrap: true,
          itemCount: Weapon.values.length,
          itemBuilder: (context, index) {
            return Obx(
              () => RadioListTile<Weapon>(
                title: Text(
                    Weapon.values[index].toString().split(".")[1].capitalize!),
                value: Weapon.values[index],
                groupValue: controller.selectedWeapon,
                onChanged: (weapon) => controller.selectedWeapon = weapon!,
                selectedTileColor: Palette.BACKGROUND_LIGHT,
                selected: controller.selectedWeapon == Weapon.values[index],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                activeColor: Palette.GREEN,
                dense: true,
                controlAffinity: ListTileControlAffinity.trailing,
                secondary: Builder(
                  builder: (context) {
                    switch (Weapon.values[index]) {
                      case Weapon.crowbar:
                        return Icon(Icons.create);
                      case Weapon.computer:
                        return Icon(Icons.cached);
                      case Weapon.hammer:
                        return Icon(Icons.hail);
                      case Weapon.knife:
                        return Icon(Icons.keyboard);
                      default:
                        return Icon(Icons.bolt);
                    }
                  },
                ),
              ),
            );
          },
        ),
        SizedBox(
          height: 16.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: SizedBox()),
            ElevatedButton(
              onPressed: () {
                final formState = controller.registerFormKey.currentState;
                if (formState!.validate()) {
                  UserModel user = UserModel(
                    email: controller.emailController.text,
                    nick: controller.nicknameController.text,
                    weapon: controller.selectedWeapon
                        .toString()
                        .split(".")[1]
                        .capitalize!,
                    active: false,
                    skinId: 0,
                  );

                  Auth.i
                      .createAccount(user, controller.passwordController.text);
                }
              },
              child: Text('CREATE'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 32.0),
                primary: Palette.GREEN,
                onPrimary: Palette.BACKGROUND_DARK,
              ),
            ),
          ],
        )
      ],
    );
  }
}

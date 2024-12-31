// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transpo/Screen/Driver/Diver_profile.dart';
import 'package:transpo/Screen/Driver/bike_registration/pages/vehical_type.dart';
import 'package:transpo/Screen/login_screen.dart';
import 'package:transpo/Screen/manager_login.dart';
import 'package:transpo/widgets/Dicision_Button.dart';
import 'package:transpo/widgets/bar.dart';

import '../controller/auth_controller.dart';
import '../utils/app_constants.dart';
import '../widgets/bar2.dart';
import '../widgets/text_widget.dart';

class DecisionScreen extends StatelessWidget {
  const DecisionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            bar2(),
            SizedBox(
              height: 10,
            ),
            textWidget(
                text: AppConstants.wel,
                fontSize: 15,
                FontWeight: FontWeight.bold),
            SizedBox(
              height: 50,
            ),
            DButton('assets/driver.png', "Login as Manager", () async {
              Get.to(() => ManagerLogin());
            }, Get.width * 0.6),
            SizedBox(
              height: 50,
            ),
            DButton('assets/customer.png', "Login as User", () {
              Get.to(() => LoginScreen());
            }, Get.width * 0.6),
          ],
        ),
      ),
    );
  }
}

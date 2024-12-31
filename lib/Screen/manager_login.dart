import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transpo/Home_page.dart';
import 'package:transpo/Screen/decision.dart';
import 'package:transpo/Screen/login_screen.dart';
import 'package:transpo/widgets/bar4.dart';

import '../../utils/color.dart';
import '../../widgets/bar1.dart';
import '../Screen/profile_screen.dart';

class ManagerLogin extends StatefulWidget {
  const ManagerLogin({super.key});

  @override
  State<ManagerLogin> createState() => _ManagerLoginState();
}

class _ManagerLoginState extends State<ManagerLogin> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  Login() async {
    try {
      if (usernameController.text == "managervedant" ||
          passwordController.text == "25122004") {
        SharedPreferences sp = await SharedPreferences.getInstance();
        sp.setString('userType', 'manager');
        Get.off(LoginScreen());
      } else {
        Get.snackbar('your', 'Not authorized Person');
        Get.off(DecisionScreen());
      }
    } catch (e) {}
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          bar4("Manager Login"),
          const SizedBox(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 23),
            child: Form(
              key: formkey,
              child: Column(
                children: [
                  TextFieldWidget(
                      'UserName', Icons.person_outline, usernameController,
                      (String? input) {
                    if (input!.isEmpty) {
                      return 'Name is required';
                    }
                    if (input.length < 3) {
                      return 'please enter a valid username!';
                    }
                    return null;
                  }),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFieldWidget(
                      'Password', Icons.password_rounded, passwordController,
                      (String? input) {
                    if (input!.isEmpty) {
                      return 'password is required';
                    }
                    return null;
                  }),
                  const SizedBox(
                    height: 10,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            backgroundColor: AppColors.b,
                            valueColor: AlwaysStoppedAnimation(AppColors.g),
                          ),
                        )
                      : FloatingActionButton.extended(
                          label: Text(
                            '      Log in      ',
                            style: TextStyle(fontSize: 18),
                          ),
                          onPressed: () {
                            if (!formkey.currentState!.validate()) {
                              return;
                            }

                            setState(() {
                              isLoading = true;
                            });
                            Login();
                          },
                          backgroundColor: AppColors.b,
                        )
                  /*  FloatingActionButton(onPressed: () {
                          setState(() {
                            isLoading = true;
                          });
                          uploadI();
                        })*/
                ],
              ),
            ),
          )
        ],
      )),
    );
  }
}

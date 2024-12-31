import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transpo/Screen/Driver/Diver_profile.dart';
import 'package:transpo/Screen/Driver/bike_registration/regis_tempeltes.dart';
import 'package:transpo/Screen/login_screen.dart';
import 'package:transpo/Screen/otp_screen.dart';
import 'package:transpo/Screen/profile_screen.dart';
import 'package:transpo/Home_page.dart';
import 'package:transpo/utils/app_constants.dart';
import 'package:transpo/utils/color.dart';
import 'package:transpo/utils/utilites.dart';
import 'package:transpo/widgets/text_widget.dart';

import '../controller/auth_controller.dart';
import 'import.dart';

var code = "";

TextEditingController textEditingController = TextEditingController();
AuthController authController = Get.find<AuthController>();

Widget OtpWidget(FirebaseAuth auth) {
  final defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: TextStyle(
        fontSize: 20,
        color: Color.fromRGBO(30, 60, 87, 1),
        fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
      border: Border.all(color: Color.fromRGBO(234, 239, 243, 1)),
      borderRadius: BorderRadius.circular(20),
    ),
  );

  final focusedPinTheme = defaultPinTheme.copyDecorationWith(
    border: Border.all(color: Color.fromRGBO(114, 178, 238, 1)),
    borderRadius: BorderRadius.circular(8),
  );

  final submittedPinTheme = defaultPinTheme.copyWith(
    decoration: defaultPinTheme.decoration?.copyWith(
      color: Color.fromRGBO(234, 239, 243, 1),
    ),
  );

  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            textWidget(
              text: AppConstants.hello,
            ),
            textWidget(
                text: AppConstants.getstart,
                fontSize: 20,
                FontWeight: FontWeight.bold),
            const SizedBox(
              height: 40,
            ),
            Pinput(
              controller: textEditingController,
              onSubmitted: (value) async {
                try {
                  // Create a PhoneAuthCredential with the code
                  PhoneAuthCredential credential = PhoneAuthProvider.credential(
                      verificationId: LoginScreen.verify, smsCode: code);
                  // Sign the user in (or link) with the credential
                  await auth.signInWithCredential(credential);

                    Get.offAll(() => ProfileScreen());
                  SharedPreferences sp = await SharedPreferences.getInstance();
                  String userType = sp.getString('userType') ?? '';
                  if (userType == 'manager') {
                    Get.offAll(() => home());
                  } else {
                    Get.offAll(() => ProfileScreen());
                  }

                  
                } catch (e) {
                  utils().toastMessage(e.toString());
                }
              },
              onChanged: (value) {
                code = value;
              },
              length: 6,
              defaultPinTheme: defaultPinTheme,
              focusedPinTheme: focusedPinTheme,
              submittedPinTheme: submittedPinTheme,
              showCursor: true,
            ),
            const SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      style: const TextStyle(color: Colors.black, fontSize: 12),
                      children: [
                        TextSpan(
                          text: AppConstants.policy1 + " ",
                        ),
                        TextSpan(
                            text: AppConstants.policy2 + " ",
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold)),
                        TextSpan(
                          text: "and",
                        ),
                        TextSpan(
                          text: AppConstants.policy3 + " ",
                          style:
                              GoogleFonts.poppins(fontWeight: FontWeight.bold),
                        ),
                      ])),
            )
          ],
        ),
      ),
    ],
  );
}

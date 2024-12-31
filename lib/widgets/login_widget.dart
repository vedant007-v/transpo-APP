

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:transpo/Screen/otp_screen.dart';
import 'package:transpo/utils/app_constants.dart';
import 'package:transpo/utils/color.dart';
import 'package:transpo/widgets/text_widget.dart';

import 'import.dart';

Widget loginWidget() {
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

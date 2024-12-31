import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:transpo/utils/color.dart';

Widget bar1() {
 
  return Container(
    width: Get.width,
    decoration: BoxDecoration(
      image:DecorationImage(
      image: AssetImage('assets/bar.png'),
      fit: BoxFit.fill
    ),
    ),
    height: Get.height*0.3,

    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
           Text(
      'Profile setup',
      style: GoogleFonts.poppins(
      color: AppColors.w,
      fontSize: 25.0,
      ),
          ),

      ],
    ),
  );
}

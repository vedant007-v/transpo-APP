import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:transpo/utils/color.dart';
import 'package:transpo/widgets/text_widget.dart';

Widget bar3(String title,String subtitle) {
 
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
         Text(title, style: GoogleFonts.poppins(
      color: AppColors.w,
      fontSize: 25.0,
      ),),
      Text(subtitle, style: GoogleFonts.poppins(
      color: AppColors.w,
      ),)
      ],
    ),
  );
}

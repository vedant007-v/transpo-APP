import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:transpo/utils/color.dart';
import 'package:transpo/widgets/text_widget.dart';

import '../utils/app_constants.dart';

Widget bar2() {
  return Container(
    width: Get.width,
    decoration: BoxDecoration(
      image:DecorationImage(
      image: AssetImage('assets/Rectangle 1.png'),
      fit: BoxFit.fill
    ),
    ),
    height: Get.height*0.6,

    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
       Icon(
            Icons.directions_bike_sharp,
            size: 150,
            color:  Color(0xFF273443),
          ),

          const SizedBox(
            height: 10,
          ),

           Text(
      'transpo',
      style: GoogleFonts.chewy(
      fontSize: 30.0,
      color: AppColors.b
      ),
          ),
          Padding(padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
             crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
            textWidget(
                    text: AppConstants.ride,
                    fontSize: 20,
                      FontWeight: FontWeight.bold
                  ),
                  textWidget(
                      text: AppConstants.deli,
                      fontSize: 20,
                      FontWeight: FontWeight.bold),
                   textWidget(
                      text: AppConstants.rent,
                      fontSize: 20,
                      FontWeight: FontWeight.bold),
                   textWidget(
                      text: AppConstants.grow,
                      fontSize: 20,
                      FontWeight: FontWeight.bold),
            ]
          ),
          ),
   /*
           Text(
      'ride',
      style: GoogleFonts.chewy(
      fontSize: 30.0,
      ),
          ),
           Text(
      'delivery',
      style: GoogleFonts.chewy(
      fontSize: 30.0,
      ),
          ),

           Text(
      'rent ride',
      style: GoogleFonts.chewy(
      fontSize: 30.0,
      ),
          ),

           Text(
      'grow business',
      style: GoogleFonts.chewy(
      fontSize: 30.0,
      ),
          ),*/

      ],
    ),
  );
}

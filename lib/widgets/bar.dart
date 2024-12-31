import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

Widget bar() {
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
            size: 200,
            color:  Color(0xFF273443),
          ),

          const SizedBox(
            height: 10,
          ),

           Text(
      'Transpo',
      style: GoogleFonts.chewy(
      fontSize: 30.0,
      ),
          ),

      ],
    ),
  );
}

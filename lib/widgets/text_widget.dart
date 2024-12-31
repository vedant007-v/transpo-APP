import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'import.dart';

Widget textWidget({required String text,double fontSize = 12, FontWeight FontWeight = FontWeight.normal}) {
  return Text(
    text, style: GoogleFonts.poppins(fontSize: fontSize,fontWeight: FontWeight)
  );
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transpo/utils/color.dart';

import '../widgets/bar.dart';
import '../widgets/otpwidget.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});
  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(       
          children: [
         
            Stack(
              children: [
                bar(),
                Positioned(
                  top: 60,
                  left: 30,
                  child: InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.white),
                      child: Icon(
                        Icons.arrow_back,
                        color: AppColors.b,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            OtpWidget(auth,),
            SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}

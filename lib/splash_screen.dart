// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:transpo/Screen/login_screen.dart';
import 'package:transpo/Home_page.dart';
import 'package:transpo/utils/color.dart';

import 'firebase_services/splash_services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
 
 
 // ignore: non_constant_identifier_names
 splashservices SplashScreen= splashservices();
 
  @override
  
  void initState() {

    super.initState();
     FirebaseAuth.instance.authStateChanges();
    SplashScreen.isLogin(context,);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.g,
      body: Container(
        width: Get.width,
      decoration: BoxDecoration(
        image:DecorationImage(
        image: AssetImage('assets/transpo1.png'),
        fit: BoxFit.fill
      ),
      ),
      height: Get.height,
       
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
                children: [
                
                Icon(
                  Icons.directions_bike_sharp,
                  size: 200,
                  color: Color(0xFF273443),
                ),
       
                SizedBox(
                  width: 200,
                  child: LinearProgressIndicator(
                    backgroundColor: Color(0xFF273443),
                    color: Colors.white,
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ),
                ),
              ]),
      ),
    );
  }
}

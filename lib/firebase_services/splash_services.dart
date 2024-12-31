import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transpo/Screen/Driver/Diver_profile.dart';
import 'package:transpo/Screen/decision.dart';

import 'package:transpo/Home_page.dart';


import '../Screen/profile_screen.dart';

FirebaseAuth _auth = FirebaseAuth.instance;
User? user = _auth.currentUser;

class splashservices {
  Future<void> isLogin(BuildContext context) async {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    SharedPreferences sp = await SharedPreferences.getInstance();
    String userType = sp.getString('userType') ?? '';
    // SharedPreferences sp = await SharedPreferences.getInstance();
    // String role = sp.getString('role') ?? '';

    if (userType == 'manager') {
      if (user != null) {
        Get.offAll(() => const home());
        

        /* if (role == 'driver') {
        Timer(Duration(seconds: 5), () {
          nextScreen(context, driver_page());
        });
      }
      else {
        Timer(Duration(seconds: 5), () {
          nextScreen(context, home_page());
        });
      }*/
      } else {
        Timer(const Duration(seconds: 3), () {
          Get.offAll(const DecisionScreen());
        });
      }
    } else {
      if (user != null) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get()
            .then((value) {
          if (value.exists) {
            Timer(const Duration(seconds: 3), () {
              Get.offAll(() => const home());
            });
          } else {
            Timer(const Duration(seconds: 3), () {
              Get.offAll(const ProfileScreen());
            });
          }
        });

        /* if (role == 'driver') {
        Timer(Duration(seconds: 5), () {
          nextScreen(context, driver_page());
        });
      }
      else {
        Timer(Duration(seconds: 5), () {
          nextScreen(context, home_page());
        });
      }*/
      } else {
        Timer(const Duration(seconds: 3), () {
          Get.offAll(const DecisionScreen());
        });
      }
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../utils/color.dart';
import '../../widgets/bar1.dart';
import '../Screen/profile_screen.dart';
import '../widgets/bar4.dart';

class GrowBusiness extends StatefulWidget {
  const  GrowBusiness({super.key});

  @override
  State< GrowBusiness> createState() => _GrowBusinessState();
}

class _GrowBusinessState extends State< GrowBusiness> {
  TextEditingController BnameController = TextEditingController();
  TextEditingController BnumberController = TextEditingController();
  TextEditingController BEmail = TextEditingController();
  TextEditingController BActivity = TextEditingController();
  TextEditingController RideActivity = TextEditingController();

  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  uploadI() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance.collection('Grow Business_request').doc(uid).set({
      'Bname': BnameController.text,
      'Bnumber': BnumberController.text,
      'BEmail': BEmail.text,
      'BActivity': BActivity.text,
      'RideActivity': RideActivity.text,
    }).then((value) {
      BnameController.clear();
      BnumberController.clear();
      BEmail.clear();
      BActivity.clear();
      RideActivity.clear();
      setState(() {
        isLoading = false;
      });
      Navigator.pop(context);
       Get.snackbar( 'your', 'Grow Business Request has been sent');
    });
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          bar4("Grow your Business"),
          const SizedBox(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 23),
            child: Form(
              key: formkey,
              child: Column(
                children: [
                  TextFieldWidget('Business Name', Icons.person_outline, BnameController,
                      (String? input) {
                    if (input!.isEmpty) {
                      return 'Name is required';
                    }
                    if (input.length < 3) {
                      return 'please enter a valid Business name!';
                    }
                    return null;
                  }),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFieldWidget(
                      'Business Number', Icons.numbers_outlined, BnumberController,
                      (String? input) {
                    if (input!.isEmpty) {
                      return 'number is required';
                    }
                    return null;
                  }),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFieldWidget(
                      'Business Email', Icons.email, BEmail,
                      (String? input) {
                    if (input!.isEmpty) {
                      return 'Business Email is required';
                    }
                    return null;
                  }),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFieldWidget(
                      'Business Activity', Icons.local_activity, BActivity,
                      (String? input) {
                    if (input!.isEmpty) {
                      return 'Business Activity is required';
                    }
                    return null;
                  }),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFieldWidget('Ride Activity', Icons.directions_bike_sharp, RideActivity,
                      (String? input) {
                    if (input!.isEmpty) {
                      return 'RideActivity is required';
                    }
                    return null;
                  }),
                  const SizedBox(
                    height: 10,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            backgroundColor: AppColors.b,
                            valueColor: AlwaysStoppedAnimation(AppColors.g),
                          ),
                        )
                      : FloatingActionButton.extended(
                          label: Text(
                            '      submit      ',
                            style: TextStyle(fontSize: 18),
                          ),
                          onPressed: () {
                            if (!formkey.currentState!.validate()) {
                              return;
                            }

                            setState(() {
                              isLoading = true;
                            });
                            uploadI();
                          },
                          backgroundColor: AppColors.b,
                        )
                  /*  FloatingActionButton(onPressed: () {
                          setState(() {
                            isLoading = true;
                          });
                          uploadI();
                        })*/
                ],
              ),
            ),
          )
        ],
      )),
    );
  }
}

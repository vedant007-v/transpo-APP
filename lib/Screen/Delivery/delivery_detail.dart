import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transpo/widgets/bar4.dart';

import '../../utils/color.dart';
import '../../widgets/bar1.dart';
import '../profile_screen.dart';

class delivery_detail extends StatefulWidget {
  const delivery_detail({super.key,});
   

  @override
  State<delivery_detail> createState() => _delivery_detailState();
}

class _delivery_detailState extends State<delivery_detail> {
  TextEditingController deliverynameController = TextEditingController();
  TextEditingController deliveryhomeController = TextEditingController();
  TextEditingController deliveryEmailController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  uploadI() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance.collection('deliver_request').doc(uid).set({
      'Dname': deliverynameController.text,
      'Dnumber': numberController.text,
      'DEmail': deliveryEmailController.text,
      'Dhome_address': deliveryhomeController.text,
    }).then((value) async {
      deliverynameController.clear();
      deliveryhomeController.clear();
       numberController.clear();
      deliveryEmailController.clear();
      numberController.clear();
      setState(() {
        isLoading = false;
      });
      Navigator.pop(context);   
    });
  }
  bool top = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          bar4("Delivery person detail"),
          const SizedBox(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 23),
            child: Form(
              key: formkey,
              child: Column(
                children: [
                  TextFieldWidget(
                      'Name', Icons.person_outline, deliverynameController,
                      (String? input) {
                    if (input!.isEmpty) {
                      return 'delivery person Name is required';
                    }
                    if (input.length < 3) {
                      return 'please enter a valid name!';
                    }
                    return null;
                  }),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFieldWidget('home', Icons.home_outlined, numberController,
                      (String? input) {
                    if (input!.isEmpty) {
                      return 'delivery person number  is required';
                    }
                    return null;
                  }),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFieldWidget(
                      'home', Icons.home_outlined, deliveryEmailController,
                      (String? input) {
                    if (input!.isEmpty) {
                      return 'delivery person email is required';
                    }
                    return null;
                  }),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFieldWidget(
                      'Business', Icons.card_travel, deliveryhomeController,
                      (String? input) {
                    if (input!.isEmpty) {
                      return 'delivery  home Address is required';
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

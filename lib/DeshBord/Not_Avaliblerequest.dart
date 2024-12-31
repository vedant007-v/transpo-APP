import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:transpo/widgets/bar4.dart';

import '../../utils/color.dart';
import '../../widgets/bar1.dart';
import '../Screen/profile_screen.dart';

class notAvalible extends StatefulWidget {
  const notAvalible({super.key});

  @override
  State<notAvalible> createState() => _notAvalibleState();
}

class _notAvalibleState extends State<notAvalible> {
  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController NotavalibleArea = TextEditingController();
  TextEditingController Ncurrent_location = TextEditingController();
  TextEditingController Ndestination_location = TextEditingController();

  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  uploadI() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance.collection('Not avali Request').doc(uid).set({
      'name': nameController.text,
      'number': numberController.text,
      'Not Avalible Area': NotavalibleArea.text,
      'current locaton': Ncurrent_location.text,
      'Destination location': Ndestination_location.text,
    }).then((value) {
      nameController.clear();
      numberController.clear();
      NotavalibleArea.clear();
      Ncurrent_location.clear();
      Ndestination_location.clear();
      setState(() {
        isLoading = false;
      });
      Navigator.pop(context);
       Get.snackbar( 'your', 'Not Ride Avalible Request has been sent');
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
          bar4("Not Available Request"),
          const SizedBox(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 23),
            child: Form(
              key: formkey,
              child: Column(
                children: [
                  TextFieldWidget('Name', Icons.person_outline, nameController,
                      (String? input) {
                    if (input!.isEmpty) {
                      return 'Name is required';
                    }
                    if (input.length < 3) {
                      return 'please enter a valid name!';
                    }
                    return null;
                  }),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFieldWidget(
                      'Number', Icons.numbers_outlined, numberController,
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
                      'Not Avalible Area', Icons.location_on, NotavalibleArea,
                      (String? input) {
                    if (input!.isEmpty) {
                      return 'Not Avalible Area is required';
                    }
                    return null;
                  }),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFieldWidget(
                      'Delivery person home', Icons.location_on, Ncurrent_location,
                      (String? input) {
                    if (input!.isEmpty) {
                      return 'home is required';
                    }
                    return null;
                  }),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFieldWidget('Destination Location', Icons.flag, Ndestination_location,
                      (String? input) {
                    if (input!.isEmpty) {
                      return 'Destination Location is required';
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

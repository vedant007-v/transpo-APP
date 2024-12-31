import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:transpo/Screen/Driver/Diver_profile.dart';
import 'package:transpo/model/bick.dart';
import 'package:transpo/utils/bick_constants.dart';
import 'package:transpo/utils/color.dart';

import '../widgets/bick_attribute.dart';

class Rentrideregister extends StatefulWidget {
  const Rentrideregister({
    Key? key,
    required this.bicks,
  }) : super(key: key);
  final bick bicks;

  @override
  State<Rentrideregister> createState() => _RentrideregisterState();
}

class _RentrideregisterState extends State<Rentrideregister> {
  TextEditingController nameController = TextEditingController();

  TextEditingController numberController = TextEditingController();

  TextEditingController PDadress = TextEditingController();

  TextEditingController pd = TextEditingController();

  TextEditingController dd = TextEditingController();
  TextEditingController pt = TextEditingController();
  TextEditingController dt = TextEditingController();

  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  uploadI() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance.collection('Rent ride rq').doc(uid).set({
      'name': nameController.text,
      'number': numberController.text,
      'bick name' : widget.bicks.brand,
      'payment' : widget.bicks.price,
      'person to deliver address':PDadress.text,
      'pick up date' : pd.text,
      'drop date' : dd.text,
      'pick up time': pt.text,
      'drop off time ': dt.text,
    }).then((value) {
      nameController.clear();
      numberController.clear();
      PDadress.clear();
      pd.clear();
      dd.clear();
      pt.clear();
      dt.clear();
      setState(() {
        isLoading = false;
      });
      Navigator.pop(context);
      Get.snackbar('your', 'Rent Ride Request has been sent');
    });
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: SingleChildScrollView(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                      'Pick and drop address', Icons.location_on, PDadress,
                      (String? input) {
                    if (input!.isEmpty) {
                      return 'Pick up date is required';
                    }
                    return null;
                  }),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFieldWidget('Pick up date', Icons.date_range_rounded, pd,
                      (String? input) {
                    if (input!.isEmpty) {
                      return 'Pick up date is required';
                    }
                    return null;
                  }),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFieldWidget('Drop off date', Icons.date_range_rounded, dd,
                      (String? input) {
                    if (input!.isEmpty) {
                      return 'Drop off date is required';
                    }
                    return null;
                  }),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFieldWidget('Pick up time', Icons.timer, pt,
                      (String? input) {
                    if (input!.isEmpty) {
                      return 'Pick up time is required';
                    }
                    return null;
                  }),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFieldWidget('Drop off time', Icons.timer, dt,
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

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: mPrimaryColor,
      elevation: 0,
      title: Text(
        'Rent ' + widget.bicks.brand,
      ),
    );
  }
}

// ignore_for_file: non_constant_identifier_names

import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:transpo/Screen/otp_screen.dart';
import 'package:transpo/utils/utilites.dart';
import 'package:transpo/widgets/bike_icon.dart';

import '../utils/app_constants.dart';
import '../utils/color.dart';
import '../widgets/bar.dart';
import '../widgets/otpwidget.dart';
import '../widgets/text_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static String verify = "";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //TextEditingController countrycode = TextEditingController();
  var phone = "";
  String countryCode = '';
  String plush = '+';
  /* @override
  void initState() {
    // TODO: implement initState
    countrycode.text = "+91";
    super.initState();
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: Get.width,
        height: Get.height,
        child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            bar(),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  textWidget(
                    text: AppConstants.hello,
                  ),
                  textWidget(
                      text: AppConstants.getstart,
                      fontSize: 20,
                      FontWeight: FontWeight.bold),
                  const SizedBox(
                    height: 40,
                  ),
                  Container(
                    height: 55,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.b.withOpacity(0.05),
                            spreadRadius: 3,
                            blurRadius: 3,
                          )
                        ],
                        borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child: InkWell(
                              onTap: () {
                                showCountryPicker(
                                    context: context,
                                    favorite: ['IN'],
                                    onSelect: (
                                      Country value,
                                    ) {
                                      countryCode = value.phoneCode.toString();

                                      setState(() {});
                                    });
                              },
                              child: Container(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(),
                                    ),
                                    Text('+'),
                                    Text(countryCode.toString()),
                                    Icon(Icons.keyboard_arrow_down_rounded),
                                  ],
                                ),
                              ),
                            )),
                        /*   const SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          width: 60,
                          //   child: TextField(

                          child: Row(
                            children: [
                              Text('+'),
                              Text(countryCode.toString()),
                              IconButton(
                                icon: const Icon(Icons.keyboard_arrow_down_rounded),
                                onPressed: () {
                                  showCountryPicker(
                                      context: context,
                                      favorite: ['IN'],
                                      onSelect: (
                                        Country value,
                                      ) {
                                        countryCode =
                                            value.phoneCode.toString();

                                        setState(() {});
                                      });
                                },
                              ),
                            ],
                          ),
                          /* controller: countrycode,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                            ),
                            */
                          //   ),
                        ),*/
                        const SizedBox(
                          width: 1,
                        ),
                        const Text(
                          '|',
                          style: TextStyle(
                            fontSize: 35,
                            color: AppColors.b,
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: TextField(
                            keyboardType: TextInputType.phone,
                            onChanged: (value) {
                              phone = value;
                            },
                            onSubmitted: (value) async {
                              await FirebaseAuth.instance.verifyPhoneNumber(
                                phoneNumber:
                                    plush + countryCode.toString() + phone,
                                verificationCompleted:
                                    (PhoneAuthCredential credential) {},
                                verificationFailed:
                                    (FirebaseAuthException e) {},
                                codeSent: (String verificationId,
                                    int? resendToken) async {
                                  LoginScreen.verify = verificationId;
                                 

                                  Get.to(() => const OtpScreen());
                                },
                                codeAutoRetrievalTimeout:
                                    (String verificationId) {},
                              );
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintStyle: GoogleFonts.poppins(
                                  fontSize: 15, fontWeight: FontWeight.normal),
                              hintText: AppConstants.pn,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                            style: const TextStyle(
                                color: Colors.black, fontSize: 12),
                            children: [
                              TextSpan(
                                text: AppConstants.policy1 + " ",
                              ),
                              TextSpan(
                                  text: AppConstants.policy2 + " ",
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold)),
                              TextSpan(
                                text: "and",
                              ),
                              TextSpan(
                                text: AppConstants.policy3 + " ",
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold),
                              ),
                            ])),
                  )
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

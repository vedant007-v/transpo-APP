import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transpo/Home_page.dart';
import 'package:transpo/Screen/Driver/bike_registration/pages/DocumentUploadaed_page.dart';
import 'package:transpo/Screen/Driver/bike_registration/pages/Driver_upload_Document.dart';
import 'package:transpo/Screen/Driver/bike_registration/pages/Location_page.dart';
import 'package:transpo/Screen/Driver/bike_registration/pages/Vehical_have.dart';
import 'package:transpo/Screen/Driver/bike_registration/pages/vehical_type.dart';
import 'package:transpo/controller/auth_controller.dart';
import 'package:transpo/utils/color.dart';
import 'package:transpo/widgets/bar3.dart';

class RegistrationTemplate extends StatefulWidget {
  const RegistrationTemplate({super.key});

  @override
  State<RegistrationTemplate> createState() => _RegistrationTemplateState();
}

String selectedLocation = '';
String selectedVehicalType = '';
String selectedHave = '';
File? document;

PageController pageController = PageController();
int currentPage = 0;

class _RegistrationTemplateState extends State<RegistrationTemplate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          bar3('Bick Registration', 'Complate the process detail'),
          SizedBox(
            height: 20,
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: PageView(
              controller: pageController,
              onPageChanged: (int page) {
                currentPage = page;
              },
              physics: NeverScrollableScrollPhysics(),
              children: [
                LocationPage(
                    selectedLocation: selectedLocation,
                    onSelect: (String location) {
                      setState(() {
                        selectedLocation = location;
                      });
                    }),
                VehicalType(
                  selectedVehical: selectedVehicalType,
                  onSelect: (String vehicalType) {
                    setState(() {
                      selectedVehicalType = vehicalType;
                    });
                  },
                ),
                VehicalHave(
                  selectedVehicalHave: selectedHave,
                  onSelect: (String vehicalHave) {
                    setState(() {
                      selectedHave = vehicalHave;
                    });
                  },
                ),
                LicenceDriver(onImageSelectd: (File image) {
                  document = image;
                }),
                DocumentUploadedPage(),
              ],
            ),
          )),
          Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: isbickUploading
                    ? Center(
                        child: CircularProgressIndicator(
                          backgroundColor: AppColors.b,
                          valueColor: AlwaysStoppedAnimation(AppColors.g),
                        ),
                      )
                    : FloatingActionButton(
                        onPressed: () {
                          if (currentPage < 4) {
                            pageController.animateToPage(currentPage + 1,
                                duration: const Duration(seconds: 1),
                                curve: Curves.easeIn);
                          } else {
                            setState(() {
                              isbickUploading = true;
                            });
                            uploadDriverBickEntry();
                          }
                        },
                        child:
                            const Icon(Icons.arrow_forward, color: AppColors.b),
                        backgroundColor: AppColors.g,
                      ),
              )),
       
           SizedBox(
            height: 40,
          ),
        ],
      ),
    );
  }
}

bool isbickUploading = false;

void uploadDriverBickEntry() async {
  String imageUrl = await Get.find<AuthController>().uploadImage(document!);

  Map<String, dynamic> bickData = {
    'country': selectedLocation,
    'vehicle_type': selectedVehicalType,
    'vehicle_Have': selectedHave,
    'Licence': imageUrl
  };
  await Get.find<AuthController>().uploadbickEntry(bickData);
  isbickUploading = false;
   Get.snackbar('your', 'Driver Request has been sent');
  Get.offAll(() => home());
}

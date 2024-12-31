import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:transpo/controller/ImageController.dart';
import 'package:path/path.dart' as Path;
import 'package:transpo/controller/auth_controller.dart';
import 'package:transpo/Home_page.dart';
import 'package:transpo/utils/color.dart';
import 'package:transpo/utils/utilites.dart';
import 'package:transpo/widgets/bar1.dart';
import 'package:transpo/widgets/otpwidget.dart';

import '../widgets/bar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController homeController = TextEditingController();
  TextEditingController busiController = TextEditingController();
  TextEditingController shopController = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  ImageaController controller = Get.put(ImageaController());

  AuthController authController = Get.put(AuthController());

  final ImagePicker _picker = ImagePicker();
  File? selectedImage;
  getImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      selectedImage = File(image.path);
      setState(() {});
    }
  }

  uploadImage(File image) async {
    String imageUrl = '';
    String fileName = Path.basename(image.path);
    var reference = FirebaseStorage.instance
        .ref()
        .child('users/$fileName'); // Modify this path/string as your need
    UploadTask uploadTask = reference.putFile(image);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    await taskSnapshot.ref.getDownloadURL().then(
      (value) {
        imageUrl = value;
        print("Download URL: $value");
      },
    );

    return imageUrl;
  }

  uploadI() async {
    String url = await uploadImage(selectedImage!);
    String uid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance.collection('users').doc(uid).set({
      'image': url,
      'name': nameController.text,
      'shopping_addess': shopController.text,
      'home_address': homeController.text,
      'business_address': busiController.text,
      
    }).then((value) {
      nameController.clear();
      homeController.clear();
      busiController.clear();
      shopController.clear();
      setState(() {
        isLoading = false;
      });
      Get.offAll(home());
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
          Container(
            height: Get.height * 0.4,
            child: Stack(
              children: [
                bar1(),
                Align(
                  alignment: Alignment.bottomCenter,
                  /* child: CircleAvatar(
                    backgroundImage: controller.imagePath.isNotEmpty ?
                        FileImage(File(controller.imagePath.toString())) :
                        null
                  ),*/
                  child: InkWell(
                    onTap: () {
                      getImage(ImageSource.camera);
                    },
                    child: selectedImage == null
                        ? Container(
                            width: 120,
                            height: 120,
                            margin: EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: AppColors.b),
                            child: Center(
                                child: Icon(
                              Icons.camera_alt_outlined,
                              size: 40,
                              color: Colors.white,
                            )),
                          )
                        : Container(
                            width: 120,
                            height: 120,
                            margin: EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: FileImage(selectedImage!),
                                    fit: BoxFit.fill),
                                shape: BoxShape.circle,
                                color: AppColors.b),
                          ),
                  ),
                )
              ],
            ),
          ),
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
                  TextFieldWidget('home', Icons.home_outlined, homeController,
                      (String? input) {
                    if (input!.isEmpty) {
                      return 'Home Address is required';
                    }
                    return null;
                  }),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFieldWidget('Business', Icons.card_travel, busiController,
                      (String? input) {
                    if (input!.isEmpty) {
                      return 'Business Address is required';
                    }
                    return null;
                  }),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFieldWidget(
                      'Shapping Center',
                      Icons.shopping_cart_outlined,
                      shopController, (String? input) {
                    if (input!.isEmpty) {
                      return 'Shapping Center Address is required';
                    }
                    return null;
                  }),
                  const SizedBox(
                    height: 15,
                  ),
                  isLoading
                      ? Center(
                          child: CircularProgressIndicator(backgroundColor: AppColors.b,
                          valueColor: AlwaysStoppedAnimation(AppColors.g),
                          ),
                        )
                      : 
                      
                      FloatingActionButton.extended(
                        label: Text('      submit      ',style: TextStyle(fontSize: 18),),
                        onPressed: () {
                          if (!formkey.currentState!.validate()) {
                            return;
                          }
                          if (selectedImage == null) {
                            Get.snackbar(
                                'waring', 'please enter a profile image');
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

TextFieldWidget(String title, IconData iconData,
    TextEditingController controller, Function validator) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: GoogleFonts.poppins(
            fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.b),
      ),
      const SizedBox(
        height: 6,
      ),
      Container(
        width: Get.width,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              spreadRadius: 1,
              blurRadius: 1,
            ),
          ],
          borderRadius: BorderRadius.circular(8),
        ),
        child: TextFormField(
          validator: (input) => validator(input),
          controller: controller,
          style: GoogleFonts.poppins(
              fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.b),
          decoration: InputDecoration(
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Icon(
                  iconData,
                  color: AppColors.b,
                ),
              ),
              border: InputBorder.none),
        ),
      )
    ],
  );
}

Widget GButton(String titel, Function onPressed) {
  return MaterialButton(
    minWidth: Get.width,
    height: 50,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
    color: AppColors.b,
    onPressed: () {},
    child: Text(
      titel,
      style: GoogleFonts.poppins(
          fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
    ),
  );
}

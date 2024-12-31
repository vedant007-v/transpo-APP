import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as Path;


import '../Home_page.dart';
import '../Screen/login_screen.dart';
import '../Screen/otp_screen.dart';
import 'User_model.dart';

class AuthController extends GetxController {
  String userUid = '';
  var varid = '';
  int? resendTokenId;
  bool phoneAuthCheck = false;
  bool isLoginAsDriver = false;
  // ignore: non_constant_identifier_names
  dynamic Credentials;
  var ispro = false.obs;

  

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

  Future<bool> uploadbickEntry(Map<String, dynamic> bickData) async {
    bool isUploding = false;
    String uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('Driver')
        .doc(uid)
        .set(bickData, SetOptions(merge: true));

    isUploding = true;

    return isUploding;
  }

    var myUser = UserModel().obs;

  getUserInfo() {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .snapshots()
        .listen((event) {
      myUser.value = UserModel.fromJson(event.data()!);
    });
  }

  Future<bool> uploadCarEntry(Map<String,dynamic> carData)async{
     bool isUploaded = false;
    String uid = FirebaseAuth.instance.currentUser!.uid;

   await FirebaseFirestore.instance.collection('users').doc(uid).set(carData,SetOptions(merge: true));

   isUploaded = true;

    return isUploaded;
  }

  storeUserCard(String number, String expiry, String cvv, String name) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('cards')
        .add({'name': name, 'number': number, 'cvv': cvv, 'expiry': expiry});

    return true;
  }

  RxList userCards = [].obs;

  getUserCards() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid).collection('cards')
    .snapshots().listen((event) {
      userCards.value = event.docs;
    });
  }

}

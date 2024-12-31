import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:transpo/utils/color.dart';

class utils {
  void toastMessage(String message) {
    Fluttertoast.showToast(
        msg: message,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: AppColors.g,
        textColor: AppColors.b,
        fontSize: 16.0);
  }
}

import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ImageaController extends GetxController {
  RxString imagePath = ''.obs;
  File? _image ;
  Future getImage(ImageSource source) async {
    final ImagePicker _picker = ImagePicker();
    
    final image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      imagePath.value = imagePath.toString();
    }
  }
}

import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';

String imageFinal = "";

Future<File?> compressFile(File image,Function callState) async {
  callState();
  int quality = 110;
  File resultFile;

  do {
    quality -= 10;
    var result = await FlutterImageCompress.compressAndGetFile(
      image.path,
      '${image.path}_compressed.jpg', // Output file path
      quality: quality,
    );

    if (result == null) {
      return null;
    }

    resultFile = File(result.path);
  } while ((resultFile.lengthSync() / 1024) > 1000 && quality > 10);
  callState();
  return resultFile;
}

Future<void> imagePicker(Function callState) async {
  final ImagePicker picker = ImagePicker();
  final XFile? image = await picker.pickImage(source: ImageSource.gallery);
  if (image == null) return;

  File? compress = await compressFile(File(image.path) , callState);
  imageFinal=compress!.path;
}

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

String imageFinal = "";
String message = "";

Future<File?> compressFile(File image, Function callState) async {
  callState(); // Indicate processing start
  int quality = 100;
  File? resultFile;

  try {
    do {
      quality -= 10;
      var result = await FlutterImageCompress.compressAndGetFile(
        image.path,
        '${image.path}_compressed.jpg', // Compressed file path
        quality: quality,
      );

      if (result == null) return null;

      resultFile = File(result.path);
    } while ((resultFile.lengthSync() / 1024) > 1000 && quality > 10);
  } catch (e) {
    debugPrint("Compression error: $e");
    return null;
  }

  try {
    if (await image.exists()) {
      await image.delete(); // Delete original if compression succeeds
    }
  } catch (e) {
    debugPrint("Error deleting original file: $e");
  }

  callState(); // Indicate processing end
  return resultFile;
}

Future<void> imagePicker(Function callState) async {
  final ImagePicker picker = ImagePicker();
  final XFile? image = await picker.pickImage(source: ImageSource.gallery);

  if (image == null) return;

  File? compressed = await compressFile(File(image.path), callState);
  if (compressed != null) {
    imageFinal = compressed.path;
  } else {
    debugPrint("Compression failed or file is null.");
  }
}

Future<void> apiCall(String imagePath) async {
  try {
    File imageFile = File(imagePath);
    if (!await imageFile.exists()) {
      debugPrint("File does not exist: $imagePath");
      return;
    }

    var imageBytes = await imageFile.readAsBytes(); // Use File read instead of rootBundle
    var base64Image = base64Encode(imageBytes);

    var response = await http.post(
      Uri.parse("YOUR_API_ENDPOINT"), // Replace with actual API endpoint
      body: jsonEncode({'image': base64Image}),
      headers: {"Content-Type": "application/json"}, // Ensure correct format
    );

    if (response.statusCode == 200) {
      message = response.body; // Store response message
    } else {
      message = "Error: ${response.statusCode} - ${response.body}";
    }
  } catch (e) {
    message = "$e";
    debugPrint("API Call Exception: $e"); // Handle and log errors
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

String imageFinal = "";
String message = "";
String apiId = "https://6caa-49-36-169-241.ngrok-free.app/";

Future<void> dynamicAPIGet(BuildContext context) async {
  const repositoryOwner = 'umairahmadx'; //add your own owner name
  const repositoryName = 'plantfo'; //your repoName
  final response = await http.get(Uri.parse(
    'https://api.github.com/repos/$repositoryOwner/$repositoryName/releases/latest',
  ));
  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    final name = data['name'];
    apiId = name;
  }
}

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
      Uri.parse(apiId), // Replace with actual API endpoint
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

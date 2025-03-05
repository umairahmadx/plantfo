import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:plantfo/home.dart';
List<CameraDescription> cameras = [];
const apiKey = 'AIzaSyCu-GReY4mvDJXDgP8Ae3luG2V5OnjO1LM';
Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  Gemini.init(apiKey: apiKey);
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PicScan',
      debugShowCheckedModeBanner: false,
      home: HomeScreen(camera: cameras),
    );
  }
}

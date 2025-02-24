import 'dart:io';
import 'package:flutter/material.dart';
import 'functions.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String imagePath = "";
  bool isLoading=false;
  @override
  void initState() {
    imagePath = imageFinal;
    super.initState();
  }
  Future<void> pickImage() async {
    await imagePicker(changeState);
    setState(() {
      imagePath = imageFinal;
    });

  }
  void changeState(){
    setState(() {
      isLoading=!isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Column(
              children: [
                Text(
                  "PlantFo",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 3),
                Text(
                  "Powered by AI",
                  style: TextStyle(fontSize: 10, color: Colors.grey[400]),
                ),
              ],
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  alignment: Alignment.bottomRight,
                  child: imagePath.isEmpty
                      ? SizedBox.shrink()
                      : ClipRRect(
                    borderRadius: BorderRadius.circular(15), // Rounded corners
                    child: Image.file(
                      File(imagePath),
                      width: screenWidth * 0.6,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10.0, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      await pickImage();
                    },
                    style: ButtonStyle(
                      minimumSize: WidgetStatePropertyAll(Size(70, 70)),
                      shape: WidgetStatePropertyAll(CircleBorder()),
                    ),
                    child: Icon(
                      Icons.photo_library_rounded,
                      size: 30,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ButtonStyle(
                      minimumSize: WidgetStatePropertyAll(Size(70, 70)),
                      shape: WidgetStatePropertyAll(CircleBorder()),
                    ),
                    child: Icon(
                      Icons.camera_alt_rounded,
                      size: 30,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (isLoading)
          Positioned.fill(
            child: Container(
              color: Color.fromRGBO(0, 0, 0, 0.5),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
      ],
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String img;

  const ChatScreen({super.key, this.img = ''});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
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
              alignment: Alignment.topRight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(200),
              ),
              child:
              widget.img.isEmpty
                  ? SizedBox.shrink()
                  : ClipRRect(
                borderRadius: BorderRadius.circular(15), // Curves the image corners
                child: Image.file(
                  File(widget.img),
                  width: screenWidth * 0.6,
                  fit: BoxFit.cover, // Ensures proper fitting
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20.0, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () {},
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
    );
  }
}

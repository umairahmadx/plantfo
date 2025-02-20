import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Column(
          children: [
            Text(
              "PlantFo",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 3,),
            Text(
              "Powered by AI",
              style: TextStyle(fontSize: 10, color: Colors.grey[400]),
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

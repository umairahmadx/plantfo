import 'dart:io';
import 'package:flutter/material.dart';
import 'functions.dart';

class ChatScreen extends StatefulWidget {
  final bool sending;
  const ChatScreen({this.sending = false, super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String imagePath = "";
  String messageFinal = "";
  bool isLoading = false;
  bool sent = false;

  @override
  void initState() {
    super.initState();
    imagePath = imageFinal;
    messageFinal = message;

    if (widget.sending) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _callApi();
      });
    }

  }

  Future<void> _callApi() async {
    await apiCall(imagePath);
    setState(() {
      messageFinal = message; // Update message after API call completes
      sent = true; // Mark as sent
    });
  }

  Future<void> pickImage() async {
    await imagePicker(changeState);
    setState(() {
      imagePath = imageFinal;
      sent = false;
      messageFinal = "";
      message = "";
    });

    if (imagePath.isNotEmpty) {
      await apiCall(imagePath); // Call the API after image selection
      setState(() {
        messageFinal = message;
        sent = true; // Update the UI after API response
      });
    }
  }

  void changeState() {
    setState(() {
      isLoading = !isLoading;
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
                  "Powered by OPR",
                  style: TextStyle(fontSize: 10, color: Colors.grey[400]),
                ),
              ],
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        alignment: Alignment.bottomRight,
                        child:
                            imagePath.isEmpty
                                ? SizedBox.shrink()
                                : ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  // Rounded corners
                                  child: Image.file(
                                    File(imagePath),
                                    width: screenWidth * 0.6,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                      ),
                      SizedBox(height: 5,),
                      Visibility(visible:imagePath.isNotEmpty,child: Text(messageFinal.isNotEmpty ? "Sent" : "Sending")),
                    ],
                  ),
                ),
                Visibility(
                  visible: messageFinal.isNotEmpty,
                  child: Container(
                    margin: EdgeInsets.only(right: 50, left: 10, top: 10),
                    padding: EdgeInsets.symmetric(vertical: 10,horizontal: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      color: Colors.lightBlueAccent[200],
                    ),
                    alignment: Alignment.bottomLeft,
                    child: Text(messageFinal,style: TextStyle(color: Colors.white,fontSize: 15),),
                  ),
                ),
                SizedBox(height: 120,)
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
              color: Color.fromRGBO(0, 0, 0, 0.7),
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
      ],
    );
  }
}

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:plantfo/functions.dart';

import 'chatscreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.camera});

  final List<CameraDescription> camera;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late CameraController _controller;
  bool flash = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera[0],
      enableAudio: false,
      ResolutionPreset.ultraHigh,
    );

    _controller.initialize().then((_) {
      if (!mounted) return;
      setState(() {});
    });
  }

  void changeState() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  void flashlight() {
    bool newFlashState = !flash;
    _controller.setFlashMode(newFlashState ? FlashMode.torch : FlashMode.off);
    setState(() {
      flash = newFlashState;
    });
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            SizedBox.expand(child: CameraPreview(_controller)),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => ChatScreen(),
                            ),
                          );
                        },
                        icon: Icon(
                          Icons.chat_bubble_outline_rounded,
                          color: Colors.white,
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            "PlantFo",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "Powered by AI",
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[400],
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: flashlight,
                        icon: Icon(
                          flash
                              ? Icons.flash_on_rounded
                              : Icons.flash_off_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      padding: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                      ),
                      child: ElevatedButton(
                        onPressed: () async {
                          await imagePicker(changeState);

                          setState(() {
                            if (context.mounted) {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => ChatScreen(sending: true,),
                                ),
                              );
                            }
                          });
                        },
                        style: ButtonStyle(
                          minimumSize: WidgetStatePropertyAll(Size(50, 50)),
                          shape: WidgetStatePropertyAll(CircleBorder()),
                        ),
                        child: Icon(
                          Icons.photo_library_rounded,
                          size: 20,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(3),
                          margin: EdgeInsets.only(bottom: 50),
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                          ),
                          child: ElevatedButton(
                            onPressed: () async {
                              try {
                                final image = await _controller.takePicture();
                                _controller.setFlashMode(FlashMode.off);
                                imageFinal = image.path;
                                File? compress = await compressFile(
                                  File(imageFinal),
                                  changeState,
                                );
                                imageFinal = compress!.path;
                                if (context.mounted) {
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (context) => ChatScreen(sending: true,),
                                    ),
                                  );
                                }
                              } catch (e) {
                                debugPrint('$e');
                              }
                            },
                            style: ButtonStyle(
                              shape: WidgetStatePropertyAll(CircleBorder()),
                              padding: WidgetStatePropertyAll(
                                EdgeInsets.all(16),
                              ),
                            ),
                            child: Icon(
                              Icons.search_rounded,
                              size: 25,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(height: 50),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => ChatScreen(),
                            ),
                          );
                        },
                        style: ButtonStyle(
                          minimumSize: WidgetStatePropertyAll(Size(50, 50)),
                          shape: WidgetStatePropertyAll(CircleBorder()),
                        ),
                        child: Icon(
                          Icons.chat_bubble_outline_rounded,
                          size: 20,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // Centered CircularProgressIndicator
            if (isLoading)
              Positioned.fill(
                child: Container(
                  color: Color.fromRGBO(0, 0, 0, 0.7),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

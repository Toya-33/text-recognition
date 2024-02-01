import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rive/rive.dart';
import 'package:text_recognition/ingredients.dart';

class DetectorScreen extends StatefulWidget {
  const DetectorScreen({super.key, required this.ingredient});

  final String ingredient;

  // This widget is the root of your application.
  @override
  State<DetectorScreen> createState() => _DetectorScreenState();
}

class _DetectorScreenState extends State<DetectorScreen> {
  bool textScanning = false;
  bool can_eat = true;
  XFile? imageFile;

  String scannedText = "";

  StateMachineController? controller;

  SMIInput<bool>? trigSuccess;
  SMIInput<bool>? trigFail;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Allergy Detector"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
              margin: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(widget.ingredient),
                  SizedBox(
                    width: size.width,
                    height: 200,
                    child: RiveAnimation.asset(
                      "assets/animated_login_character.riv",
                      stateMachines: const ["Login Machine"],
                      onInit: (artboard) {
                        controller = StateMachineController.fromArtboard(
                            artboard, "Login Machine");
                        if (controller == null) return;

                        artboard.addController(controller!);
                        trigSuccess = controller?.findInput("trigSuccess");
                        trigFail = controller?.findInput("trigFail");
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        padding: const EdgeInsets.only(top: 10),
                        child: ElevatedButton(
                          onPressed: () {
                            getImage(ImageSource.gallery);
                          },
                          child: Container(
                            margin: const EdgeInsets.all(5),
                            child: const Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.image,
                                    size: 30,
                                  ),
                                  Text(
                                    "Gallery",
                                    style: TextStyle(
                                        fontSize: 13, color: Colors.grey),
                                  )
                                ]),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        padding: const EdgeInsets.only(top: 10),
                        child: ElevatedButton(
                          onPressed: () {
                            getImage(ImageSource.camera);
                          },
                          child: Container(
                            margin: const EdgeInsets.all(5),
                            child: const Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.camera_alt,
                                    size: 30,
                                  ),
                                  Text(
                                    "Camera",
                                    style: TextStyle(
                                        fontSize: 13, color: Colors.grey),
                                  )
                                ]),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  if (imageFile != null)
                    Column(children: [
                      Container(
                          child: Text(
                        can_eat ? "Safe! 🤗" : "Not Safe! 💀",
                        style: TextStyle(
                            color: can_eat ? Colors.green : Colors.red,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'Open Sans',
                            fontSize: 40),
                      )),
                      Image.file(File(imageFile!.path)),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => IngredientScreen(
                                          scannedText: scannedText,
                                        )));
                          },
                          child: Text("View Details"))
                    ]),
                ],
              )),
        ),
      ),
    );
  }

  void getImage(ImageSource source) async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage != null) {
        textScanning = true;
        imageFile = pickedImage;
        setState(() {
          getRecognisedText(pickedImage);
        });
      }
    } catch (e) {
      textScanning = false;
      imageFile = null;
      setState(() {});
      scannedText = "Error Occured";
    }
  }

  void getRecognisedText(XFile image) async {
    final inputImage = InputImage.fromFilePath(image.path);
    final textDetector = GoogleMlKit.vision.textRecognizer();
    RecognizedText recognizedText = await textDetector.processImage(inputImage);
    await textDetector.close();
    can_eat = true;
    scannedText = "";
    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        scannedText = "$scannedText${line.text}\n".toLowerCase();
      }
    }
    List<String> ingredients = widget.ingredient.split(',');
    print(ingredients);
    for (String ingredient in ingredients) {
      if (scannedText.contains(ingredient)) {
        can_eat = false;
      }
    }
    textScanning = false;
    print(scannedText);
    setState(() {
      if (can_eat == true) {
        trigSuccess!.change(true);
      } else {
        trigFail!.change(true);
      }
    });
  }

  @override
  void initState() {
    super.initState();
  }
}

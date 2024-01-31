import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool textScanning = false;

  XFile? imageFile;
  
  String scannedText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Text Recognition"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                  if(textScanning) const CircularProgressIndicator(),
                  if(!textScanning && imageFile == null)
                    Container(
                      width: 300,
                      height: 300,
                      color: Colors.grey,
                    ),
                  if (imageFile != null) Image.file(File(imageFile!.path)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        padding: const EdgeInsets.only(top: 10),
                        child: ElevatedButton(
                          onPressed: (){
                            getImage(ImageSource.gallery);
                          },
                          child: Container(
                            margin: const EdgeInsets.all(5),
                            child: const Column(
                              mainAxisSize: MainAxisSize.min,
                              children:[
                                Icon(
                                  Icons.image,
                                  size: 30,
                                ),
                                Text(
                                  "Gallery",
                                  style: TextStyle(fontSize: 13, color: Colors.grey),
                                )
                              ]
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        padding: const EdgeInsets.only(top: 10),
                        child: ElevatedButton(
                          onPressed: (){
                            getImage(ImageSource.camera);
                          },
                          child: Container(
                            margin: const EdgeInsets.all(5),
                            child: const Column(
                              mainAxisSize: MainAxisSize.min,
                              children:[
                                Icon(
                                  Icons.camera_alt,
                                  size: 30,
                                ),
                                Text(
                                  "Camera",
                                  style: TextStyle(fontSize: 13, color: Colors.grey),
                                )
                              ]
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10,),
                  Container(
                    child: Text(
                      scannedText,
                      style: TextStyle(fontSize: 20),
                    ),
                  )
              ],
              )
          ),
        ),
      ),
    );
  }

  void getImage(ImageSource source) async {
    try{
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage != null){
        textScanning = true;
        imageFile = pickedImage;
        setState((){
          getRecognisedText(pickedImage);
        });
      }
    } catch (e) {
      textScanning = false;
      imageFile = null;
      setState((){});
      scannedText = "Error Occured";
    }
  }
  void getRecognisedText(XFile image) async{
    final inputImage = InputImage.fromFilePath(image.path);
    final textDetector = GoogleMlKit.vision.textRecognizer();
    RecognizedText recognizedText = await textDetector.processImage(inputImage);
    await textDetector.close();
    scannedText = "";
    for(TextBlock block in recognizedText.blocks){
      for(TextLine line in block.lines){
        scannedText = "$scannedText${line.text}\n";
      }
    }
    textScanning = false;
    setState(() {
      
    });
    
  }
  @override
  void initState(){
    super.initState();
  }
}

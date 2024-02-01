import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rive/rive.dart';

class IngredientScreen extends StatefulWidget {
  const IngredientScreen({super.key, required this.scannedText});

  final String scannedText;

  // This widget is the root of your application.
  @override
  State<IngredientScreen> createState() => _IngredientScreenState();
}

class _IngredientScreenState extends State<IngredientScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Allergy Ingredient"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
              margin: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(widget.scannedText),
                ],
              )),
        ),
      ),
    );
  }
  @override
  void initState() {
    super.initState();
  }
}
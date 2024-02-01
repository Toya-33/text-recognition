import 'package:flutter/material.dart';
import 'package:text_recognition/detector.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
  final _ingredientController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Allergy Detection'),
      ),
      body: Form(
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: TextFormField(
                controller: _ingredientController,
                validator: (value) {
                  if (value?.isEmpty == true) {
                    return 'Please enter a ingredients';
                  }
                  return null; // Valid input
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Type here!',
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Access the input value
                String ingredients = _ingredientController.text.toLowerCase();

                // Apply conditional logic
                if (ingredients.isNotEmpty) {
                  // Valid input: Perform actions
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              DetectorScreen(ingredient: ingredients)));
                } else {
                  // Invalid input: Handle errors
                  print('Please enter a valid username.');
                }
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
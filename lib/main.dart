import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:text_recognition/detector.dart';

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
  final _ingredientController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Input Condition'),
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
                  labelText: 'Enter your allergy here',
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Access the input value
                String ingredients = _ingredientController.text;

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

// class MyRememberingWidget extends StatefulWidget {
//   @override
//   const MyRememberingWidget({super.key, required this.ingredients});
//   _MyRememberingWidgetState createState() => _MyRememberingWidgetState();
// }

// class _MyRememberingWidgetState extends State<MyRememberingWidget> {
//   final _inputController = TextEditingController();
//   String _rememberedInput = '';

//   @override
//   void initState() {
//     super.initState();
//     _loadRememberedInput();
//   }

//   Future<void> _loadRememberedInput() async {
//     final prefs = await SharedPreferences.getInstance();
//     final rememberedInput = prefs.getString('input_key');
//     setState(() {
//       _rememberedInput = rememberedInput ?? '';
//       _inputController.text = _rememberedInput;
//     });
//   }

//   Future<void> _saveInput(String input) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('input_key', input);
//     setState(() {
//       _rememberedInput = input;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text("list of ingredients"),
//         ),
//         body: Column(children: [Text(data)]),
//       );
//   }
// }

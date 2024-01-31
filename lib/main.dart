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
  final _usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Input Condition'),
      ),
      body: Form(
        child: Column(
          children: [
            TextFormField(
              controller: _usernameController,
              validator: (value) {
                if (value?.isEmpty == true) {
                  return 'Please enter a ingredients';
                }
                return null; // Valid input
              },
              decoration: InputDecoration(
                labelText: 'Ingredient',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Access the input value
                final username = _usernameController.text;

                // Apply conditional logic
                if (username.isNotEmpty) {
                  // Valid input: Perform actions
                  print('Welcome, $username!');
                } else {
                  // Invalid input: Handle errors
                  print('Please enter a valid username.');
                }

                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => DetectorScreen()));
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

class MyRememberingWidget extends StatefulWidget {
  @override
  _MyRememberingWidgetState createState() => _MyRememberingWidgetState();
}

class _MyRememberingWidgetState extends State<MyRememberingWidget> {
  final _inputController = TextEditingController();
  String _rememberedInput = '';

  @override
  void initState() {
    super.initState();
    _loadRememberedInput();
  }

  Future<void> _loadRememberedInput() async {
    final prefs = await SharedPreferences.getInstance();
    final rememberedInput = prefs.getString('input_key');
    setState(() {
      _rememberedInput = rememberedInput ?? '';
      _inputController.text = _rememberedInput;
    });
  }

  Future<void> _saveInput() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('input_key', _inputController.text);
    setState(() {
      _rememberedInput = _inputController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // ... (rest of your UI)
        );
  }
}

import 'package:flutter/material.dart';
import 'package:odin_messenger/screens/startup_screen.dart';

void main() {
  runApp(OdinMessengerApp());
}

class OdinMessengerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Odin Messenger', // Change the app title as needed
      theme: ThemeData(
        primarySwatch: Colors.blue, // Customize the app theme as needed
      ),
      home: StartupScreen(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:odin_messenger/screens/startup_screen.dart';
import 'package:odin_messenger/utility/app_properties.dart'; // Import your AppProperties utility class

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final properties = await AppProperties.load(); // Load the properties

  runApp(OdinMessengerApp(properties));
}

class OdinMessengerApp extends StatelessWidget {
  final Map<String, String> properties;

  OdinMessengerApp(this.properties);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Odin Messenger',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StartupScreen(
          properties: properties), // Pass the properties to your StartupScreen
    );
  }
}

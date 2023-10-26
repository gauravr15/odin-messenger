import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/startup_screen.dart';
import 'utility/app_properties.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppProperties.load(); // Load properties

  runApp(OdinMessengerApp());
}

class OdinMessengerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StartupScreen(),
    );
  }
}

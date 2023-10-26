import 'package:flutter/services.dart';

class AppProperties {
  static Map<String, String> _properties = {};

  // Function to load properties from app.properties
  static Future<void> load() async {
    try {
      final properties = await rootBundle.loadString('assets/app.properties');
      final lines = properties.split('\n');

      for (final line in lines) {
        final parts = line.split('=');
        if (parts.length == 2) {
          final key = parts[0].trim();
          final value = parts[1].trim();

          // Store properties in the map
          _properties[key] = value;
        }
      }
    } catch (e) {
      // Handle any errors in loading properties
      print('Error loading properties: $e');
    }
  }

  // Function to get a property value by key
  static String? getProperty(String key) {
    return _properties[key];
  }

  // Function to get all properties as a map
  static Map<String, String> getProperties() {
    return _properties;
  }
}

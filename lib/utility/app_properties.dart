import 'package:flutter/services.dart';

class AppProperties {
  static Future<Map<String, String>> load() async {
    final String data = await rootBundle.loadString('assets/app.properties');
    final List<String> lines = data.split('\n');
    final Map<String, String> properties = {};

    for (final line in lines) {
      final parts = line.split('=');
      if (parts.length == 2) {
        properties[parts[0]] = parts[1];
      }
    }

    return properties;
  }
}

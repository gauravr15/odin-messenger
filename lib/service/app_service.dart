import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

  Future<Map<String, dynamic>> get(String endpoint,
      {Map<String, String>? headers}) async {
    final response =
        await http.get(Uri.parse('$baseUrl/$endpoint'), headers: headers);

    if (response.statusCode == 200) {
      try {
        final data = json.decode(response.body);
        return data;
      } catch (e) {
        throw Exception('Failed to decode response data');
      }
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  Future<Map<String, dynamic>> post(String endpoint,
      {Map<String, String>? headers, dynamic body}) async {
    final response = await http.post(Uri.parse('$baseUrl/$endpoint'),
        headers: headers, body: jsonEncode(body));

    if (response.statusCode == 200) {
      try {
        final data = json.decode(response.body);
        return data;
      } catch (e) {
        throw Exception('Failed to decode response data');
      }
    } else {
      throw Exception('Failed to post data');
    }
  }

  // Add other API request methods as needed
}

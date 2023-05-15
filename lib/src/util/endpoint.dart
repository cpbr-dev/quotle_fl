import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

class Endpoint {
  static apiRequest(String endpoint) async {
    String apiLink = dotenv.get('API_LINK');
    endpoint = endpoint.trim();

    final response = await http.get(
      Uri.parse('$apiLink$endpoint'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      //Log error.
      return jsonEncode('An error occured.');
    }
  }
}

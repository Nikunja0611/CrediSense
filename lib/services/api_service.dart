import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const baseUrl = "http://127.0.0.1:8000"; // Change if deployed

  static Future<Map<String, dynamic>> predictScore(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse("$baseUrl/predict"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> explainScore(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse("$baseUrl/explain"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );
    return jsonDecode(response.body);
  }
}

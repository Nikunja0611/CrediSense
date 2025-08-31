import 'package:http/http.dart' as http;
import 'dart:convert';

class TranslationService {
  static const String _libreTranslateUrl = 'http://localhost:5000/translate';
  
  static Future<String> translateText(String text, String targetLang) async {
    try {
      final response = await http.post(
        Uri.parse(_libreTranslateUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'q': text,
          'source': 'en',
          'target': targetLang,
        }),
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['translatedText'];
      }
    } catch (e) {
      print('Translation error: $e');
    }
    return text; // Fallback to original text
  }
}

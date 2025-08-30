import 'dart:convert';
import 'package:http/http.dart' as http;

class EmailService {
  static const String backendUrl = "http:// 192.168.1.109:3000"; 
  // 👆 Replace with your system's local IP if testing on real device
  // Use http://10.0.2.2:3000 if testing on Android Emulator

  static Future<void> sendOtpEmail(String recipientEmail, String otp) async {
    try {
      final response = await http.post(
        Uri.parse("$backendUrl/send-otp"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": recipientEmail,
          "otp": otp,
        }),
      );

      if (response.statusCode == 200) {
        print("✅ OTP sent successfully to $recipientEmail");
      } else {
        print("❌ Failed to send OTP: ${response.body}");
      }
    } catch (e) {
      print("❌ Error sending OTP: $e");
    }
  }
}

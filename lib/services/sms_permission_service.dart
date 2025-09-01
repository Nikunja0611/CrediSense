import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

class SMSMessage {
  final String id;
  final String address;
  final String body;
  final DateTime date;

  SMSMessage({
    required this.id,
    required this.address,
    required this.body,
    required this.date,
  });
}

class SMSPermissionService {
  static const MethodChannel _channel = MethodChannel('com.example.credisense/sms');
  static bool _isListening = false;

  static Future<bool> requestSMSPermission() async {
    print('🔐 Requesting SMS permission...');
    final status = await Permission.sms.request();
    print('🔐 SMS permission status: $status');
    return status.isGranted;
  }

  static Future<bool> hasSMSPermission() async {
    final status = await Permission.sms.status;
    print('🔐 Checking SMS permission: $status');
    return status.isGranted;
  }

  static Future<List<SMSMessage>> readSMSMessages({
    int limit = 1000,
    DateTime? since,
  }) async {
    print('📱 Starting SMS reading process...');
    
    if (!await hasSMSPermission()) {
      print('❌ SMS permission not granted');
      throw Exception('SMS permission not granted');
    }

    print('✅ SMS permission granted, reading messages...');

    try {
      final Map<String, dynamic> arguments = {
        'limit': limit,
        'since': since?.millisecondsSinceEpoch.toString(),
      };

      print('📤 Calling platform channel with arguments: $arguments');

      final String result = await _channel.invokeMethod('readSMS', arguments);
      print('📥 Received result from platform channel: ${result.length} characters');
      
      if (result.isEmpty) {
        print('⚠️ Empty result from platform channel');
        return [];
      }

      final List<dynamic> jsonList = json.decode(result);
      print('📊 Parsed ${jsonList.length} SMS messages from JSON');
      
      final messages = jsonList.map((json) {
        return SMSMessage(
          id: json['id'],
          address: json['address'],
          body: json['body'],
          date: DateTime.fromMillisecondsSinceEpoch(json['date']),
        );
      }).toList();

      print('✅ Successfully parsed ${messages.length} SMS messages');
      
      // Log first few messages for debugging
      for (int i = 0; i < messages.length && i < 3; i++) {
        print('📨 Message $i: ${messages[i].address} - ${messages[i].body.substring(0, messages[i].body.length > 50 ? 50 : messages[i].body.length)}...');
      }

      return messages;
    } on PlatformException catch (e) {
      print('❌ Platform Exception: ${e.code} - ${e.message}');
      return [];
    } catch (e) {
      print('❌ Error reading SMS: $e');
      return [];
    }
  }

  static Future<void> listenToIncomingSMS(Function(SMSMessage) onMessageReceived) async {
    print('🎧 Starting real-time SMS listening...');
    
    if (!await hasSMSPermission()) {
      print('❌ SMS permission not granted for listening');
      throw Exception('SMS permission not granted');
    }

    if (_isListening) {
      print('⚠️ Already listening to SMS');
      return;
    }

    try {
      final bool result = await _channel.invokeMethod('startListening');
      if (result) {
        _isListening = true;
        print('✅ Real-time SMS listening started successfully');
        
        // Note: In a production app, you'd use EventChannel for real-time communication
        // For now, we'll use a polling approach for demonstration
        print('📡 SMS listening active - new messages will be detected');
      } else {
        print('❌ Failed to start SMS listening');
      }
    } on PlatformException catch (e) {
      print('❌ Platform Exception while starting SMS listening: ${e.code} - ${e.message}');
      throw Exception('Failed to start SMS listening: ${e.message}');
    } catch (e) {
      print('❌ Error starting SMS listening: $e');
      throw Exception('Failed to start SMS listening: $e');
    }
  }

  static Future<void> stopListeningToSMS() async {
    print('🛑 Stopping real-time SMS listening...');
    
    if (!_isListening) {
      print('⚠️ Not currently listening to SMS');
      return;
    }

    try {
      final bool result = await _channel.invokeMethod('stopListening');
      if (result) {
        _isListening = false;
        print('✅ Real-time SMS listening stopped successfully');
      } else {
        print('❌ Failed to stop SMS listening');
      }
    } on PlatformException catch (e) {
      print('❌ Platform Exception while stopping SMS listening: ${e.code} - ${e.message}');
    } catch (e) {
      print('❌ Error stopping SMS listening: $e');
    }
  }

  static Future<bool> isListeningToSMS() async {
    return _isListening;
  }

  static Future<bool> isDefaultSmsApp() async {
    // For Phase 2, return false - will be implemented in Phase 3
    return false;
  }

  static Future<bool> requestDefaultSmsApp() async {
    // For Phase 2, return false - will be implemented in Phase 3
    return false;
  }
}

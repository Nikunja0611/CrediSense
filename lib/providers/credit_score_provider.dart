import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../models/credit_score.dart';

class CreditScoreProvider extends ChangeNotifier {
  CreditScoreModel? _creditScore;
  bool _loading = false;
  String? _error;

  CreditScoreModel? get creditScore => _creditScore;
  bool get loading => _loading;
  String? get error => _error;

  // ✅ Your backend base URL (Update for your network)
  static const String _baseUrl = "http://172.22.82.223:8000/api";

  /// Fetch credit score for a given [userId]
  Future<void> fetchCreditScore(String userId) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse("$_baseUrl/credit-score/$userId"),
        headers: {
          "Content-Type": "application/json",
          // "Authorization": "Bearer <token>", // uncomment if JWT enabled
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // ✅ Ensure data fits our model
        _creditScore = CreditScoreModel.fromJson(data);
      } else {
        _error = "Failed to load score (Status: ${response.statusCode})";
        _creditScore = null;
      }
    } catch (e) {
      _error = "Network error: $e";

      // ✅ Fallback mock score if backend unreachable
      _creditScore = CreditScoreModel(
        score: 650,
        scoreTrend: [600, 620, 640, 650],
        utilizationTrend: [0.45, 0.40, 0.35, 0.30],
        missedPayments: 1,
        onTimePayments: 12,
      );
    }

    _loading = false;
    notifyListeners();
  }

  /// Reset state (e.g., on logout)
  void clear() {
    _creditScore = null;
    _error = null;
    notifyListeners();
  }
}

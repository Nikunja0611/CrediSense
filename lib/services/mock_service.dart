import 'dart:convert';
import 'package:flutter/services.dart';

import '../models/transaction.dart';
import '../models/budget.dart';

/// Optional: create a PersonaModel for AI Insights
class PersonaModel {
  final String personaType;
  final String description;
  final List<String> recommendations;

  PersonaModel({
    required this.personaType,
    required this.description,
    required this.recommendations,
  });

  factory PersonaModel.fromJson(Map<String, dynamic> json) {
    return PersonaModel(
      personaType: json['personaType'],
      description: json['description'],
      recommendations: List<String>.from(json['recommendations']),
    );
  }
}

class MockService {
  List<TransactionModel> transactions = [];
  List<BudgetModel> budgets = [];
  List<PersonaModel> personas = []; // <-- New for AI insights

  Future<void> loadMockData() async {
    /// Load Transactions
    final data = await rootBundle.loadString('assets/mock_transactions.json');
    final j = json.decode(data) as List<dynamic>;
    transactions = j.map((e) => TransactionModel.fromJson(e)).toList();

    /// Generate budgets aggregated by category
    final Map<String, double> spent = {};
    for (var t in transactions) {
      spent.update(t.category, (v) => v + (t.isExpense ? t.amount : 0),
          ifAbsent: () => (t.isExpense ? t.amount : 0));
    }

    budgets = [
      BudgetModel(category: 'Groceries', spent: spent['Groceries'] ?? 0, limit: 8000),
      BudgetModel(category: 'Transport', spent: spent['Transport'] ?? 0, limit: 5000),
      BudgetModel(category: 'Utilities', spent: spent['Utilities'] ?? 0, limit: 4500),
      BudgetModel(category: 'Entertainment', spent: spent['Entertainment'] ?? 0, limit: 3000),
    ];

    /// Load Personas for AI Insights (from assets/mock_persona.json)
    try {
      final personaData = await rootBundle.loadString('assets/mock_persona.json');
      final pj = json.decode(personaData) as List<dynamic>;
      personas = pj.map((e) => PersonaModel.fromJson(e)).toList();
    } catch (e) {
      print("⚠️ Persona data not found or invalid: $e");
      personas = [];
    }
  }
}

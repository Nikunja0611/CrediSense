import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/transaction.dart';
import '../models/budget.dart';

class MockService {
  List<TransactionModel> transactions = [];
  List<BudgetModel> budgets = [];

  Future<void> loadMockData() async {
    final data = await rootBundle.loadString('assets/mock_transactions.json');
    final j = json.decode(data) as List<dynamic>;
    transactions = j.map((e) => TransactionModel.fromJson(e)).toList();

    // create some mock budgets aggregated by category
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
  }
}

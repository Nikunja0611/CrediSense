import 'package:flutter/material.dart';
import '../services/mock_service.dart';
import '../models/transaction.dart';
import '../models/budget.dart';

class FinanceProvider extends ChangeNotifier {
  final MockService service;
  FinanceProvider(this.service);

  List<TransactionModel> get transactions => service.transactions;
  List<BudgetModel> get budgets => service.budgets;

  // ------------------------
  // Balance & Expense
  // ------------------------
  double get totalBalance {
    double income = 0, expense = 0;
    for (var t in transactions) {
      if (t.isExpense) {
        expense += t.amount;
      } else {
        income += t.amount;
      }
    }
    return income - expense + 45230; // mock baseline
  }

  double get monthExpense {
    final now = DateTime.now();
    double total = 0;
    for (var t in transactions) {
      if (t.isExpense &&
          t.date.month == now.month &&
          t.date.year == now.year) {
        total += t.amount;
      }
    }
    return total;
  }

  // ------------------------
  // OLD mock composite score (fallback)
  // ------------------------
  int get creditScore {
    final base = 650;
    final timelyPayment = 95; // %
    final utilizationPenalty = 20;
    final score = (base + (timelyPayment * 0.5).round() - utilizationPenalty)
        .clamp(300, 850)
        .toInt();
    return score;
  }

  // ------------------------
  // NEW ML scores (from backend)
  // ------------------------
  double? _creditScoreLgbm;
  double? _creditScoreXgb;
  String? _riskCategory;

  double? get creditScoreLgbm => _creditScoreLgbm;
  double? get creditScoreXgb => _creditScoreXgb;
  String? get riskCategory => _riskCategory;

  void updateCreditScores({
    double? lgbm,
    double? xgb,
    String? category,
  }) {
    _creditScoreLgbm = lgbm;
    _creditScoreXgb = xgb;
    _riskCategory = category;
    notifyListeners();
  }

  // ------------------------
  // User Inputs (from ManualInputForm)
  // ------------------------
  Map<String, dynamic>? _userInputs;
  Map<String, dynamic>? get userInputs => _userInputs;

  void updateUserInputs(Map<String, dynamic> inputs) {
    _userInputs = inputs;
    notifyListeners();
  }

  void clearUserInputs() {
    _userInputs = null;
    notifyListeners();
  }

  // ------------------------
  // Transactions
  // ------------------------
  void addTransaction(TransactionModel t) {
    service.transactions.insert(0, t);
    notifyListeners();
  }
}

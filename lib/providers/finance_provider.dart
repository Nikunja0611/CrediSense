import 'package:flutter/material.dart';
import '../services/mock_service.dart';
import '../models/transaction.dart';
import '../models/budget.dart';

class FinanceProvider extends ChangeNotifier {
  final MockService service;

  FinanceProvider(this.service);

  List<TransactionModel> get transactions => service.transactions;
  List<BudgetModel> get budgets => service.budgets;

  double get totalBalance {
    double income = 0;
    double expense = 0;
    for (var t in transactions) {
      if (t.isExpense) expense += t.amount;
      else income += t.amount;
    }
    return income - expense + 45230; // mock baseline balance to match prototype feel
  }

  double get monthExpense {
    final now = DateTime.now();
    double total = 0;
    for (var t in transactions) {
      if (t.isExpense && t.date.month == now.month && t.date.year == now.year) {
        total += t.amount;
      }
    }
    return total;
  }

  int get creditScore {
    // Mock credit score logic (composite)
    final base = 650;
    final timelyPayment = 95; // %
    final utilizationPenalty = 20; // mock
    final score = (base + (timelyPayment * 0.5).round() - utilizationPenalty).clamp(300, 850).toInt();
    return score;
  }

  void addTransaction(TransactionModel t) {
    service.transactions.insert(0, t);
    notifyListeners();
  }
}

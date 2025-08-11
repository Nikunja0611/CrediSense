import 'package:flutter/material.dart';
import '../models/budget.dart';

class BudgetProgress extends StatelessWidget {
  final BudgetModel budget;
  const BudgetProgress({super.key, required this.budget});

  @override
  Widget build(BuildContext context) {
    final percent = budget.percent;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(budget.category, style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              LinearProgressIndicator(value: percent),
              const SizedBox(height: 6),
              Text('₹${budget.spent.toStringAsFixed(0)} / ₹${budget.limit.toStringAsFixed(0)}'),
            ]),
          ),
          const SizedBox(width: 8),
          Icon(percent > 0.9 ? Icons.warning : Icons.check_circle_outline, color: percent > 0.9 ? Colors.orange : Colors.green),
        ]),
      ),
    );
  }
}

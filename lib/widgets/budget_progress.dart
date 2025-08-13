import 'package:flutter/material.dart';
import '../models/budget.dart';

class BudgetProgress extends StatelessWidget {
  final BudgetModel budget;
  final Color primaryColor;
  final Color dangerColor;

  const BudgetProgress({
    super.key,
    required this.budget,
    required this.primaryColor,
    required this.dangerColor,
  });

  @override
  Widget build(BuildContext context) {
    final percent = budget.percent;
    final isOverBudget = percent > 1.0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      budget.category,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(height: 6),
                    LinearProgressIndicator(
                      value: percent > 1 ? 1 : percent,
                      backgroundColor: Colors.grey.shade300,
                      color: isOverBudget ? dangerColor : primaryColor,
                      minHeight: 6,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '₹${budget.spent.toStringAsFixed(0)} / ₹${budget.limit.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: isOverBudget ? dangerColor : Colors.grey[700],
                      ),
                    ),
                  ]),
            ),
            const SizedBox(width: 8),
            Icon(
              isOverBudget ? Icons.warning_amber_rounded : Icons.check_circle_outline,
              color: isOverBudget ? dangerColor : Colors.green,
            ),
          ],
        ),
      ),
    );
  }
}

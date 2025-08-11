import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/finance_provider.dart';
import '../../widgets/simple_app_bar.dart';

class CreditScoreScreen extends StatelessWidget {
  const CreditScoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final finance = Provider.of<FinanceProvider>(context);
    final score = finance.creditScore;
    // small suggestions
    final suggestions = [
      '+15 Pay bills on time',
      '+8 Reduce spending by 10%',
      'Keep card utilization under 30%',
    ];

    return Scaffold(
      appBar: const SimpleAppBar(title: 'Credit Score'),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            Card(
              elevation: 2,
              child: Container(
                padding: const EdgeInsets.all(18),
                width: double.infinity,
                child: Column(
                  children: [
                    Text('Your Current Score', style: Theme.of(context).textTheme.labelLarge),
                    const SizedBox(height: 12),
                    Text('$score', style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(value: (score - 300) / 550),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            Text('Potential Score Changes', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ...suggestions.map((s) => ListTile(leading: const Icon(Icons.check_circle_outline), title: Text(s))).toList(),
          ],
        ),
      ),
    );
  }
}

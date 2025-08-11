import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class BalanceCard extends StatelessWidget {
  final double balance;
  final double monthExpense;
  final int creditScore;
  final VoidCallback? onViewCredit;

  const BalanceCard({
    super.key,
    required this.balance,
    required this.monthExpense,
    required this.creditScore,
    this.onViewCredit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.account_balance_wallet_outlined, size: 28),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Total Balance', style: TextStyle(fontSize: 12)),
                    Text('₹${balance.toStringAsFixed(0)}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  ],
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('This Month', style: TextStyle(fontSize: 12)),
                    Text('₹${monthExpense.toStringAsFixed(0)}', style: const TextStyle(fontSize: 16)),
                  ],
                )
              ],
            ),
            const SizedBox(height: 12),
            Divider(),
            const SizedBox(height: 8),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Credit Score', style: TextStyle(fontSize: 12)),
                    Text('$creditScore', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  ],
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: onViewCredit,
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent),
                  child: const Text('Credit Score Simulator'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

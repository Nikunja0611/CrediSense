import 'package:flutter/material.dart';

class BalanceCard extends StatelessWidget {
  final double balance;
  final double monthExpense;
  final int creditScore;
  final VoidCallback? onViewCredit;
  final Color primaryColor;
  final Color secondaryColor;

  const BalanceCard({
    super.key,
    required this.balance,
    required this.monthExpense,
    required this.creditScore,
    this.onViewCredit,
    required this.primaryColor,
    required this.secondaryColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.account_balance_wallet, color: primaryColor, size: 28),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Total Balance', style: TextStyle(fontSize: 12)),
                    Text(
                      '₹${balance.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('This Month', style: TextStyle(fontSize: 12)),
                    Text(
                      '₹${monthExpense.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 16,
                        color: secondaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Divider(color: Colors.grey.shade300),
            const SizedBox(height: 8),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Credit Score', style: TextStyle(fontSize: 12)),
                    Text(
                      '$creditScore',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: onViewCredit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: secondaryColor,
                    foregroundColor: Colors.white,
                  ),
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

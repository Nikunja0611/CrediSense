import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/finance_provider.dart';
import '../../widgets/transaction_tile.dart';
import '../../widgets/simple_app_bar.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final finance = Provider.of<FinanceProvider>(context);
    final txs = finance.transactions;
    return Scaffold(
      appBar: const SimpleAppBar(title: 'Transactions'),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemCount: txs.length,
        itemBuilder: (ctx, i) => TransactionTile(tx: txs[i]),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';

class TransactionTile extends StatelessWidget {
  final TransactionModel tx;
  const TransactionTile({super.key, required this.tx});

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat.yMMMd();
    return Card(
      child: ListTile(
        leading: CircleAvatar(child: Text(tx.category[0])),
        title: Text(tx.title),
        subtitle: Text('${tx.category} • ${fmt.format(tx.date)}'),
        trailing: Text(
          '${tx.isExpense ? '-' : '+'}₹${tx.amount.toStringAsFixed(0)}',
          style: TextStyle(color: tx.isExpense ? Colors.red : Colors.green),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/finance_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/balance_card.dart';
import '../../widgets/budget_progress.dart';
import '../../widgets/transaction_tile.dart';
import '../../routers.dart';
import '../../widgets/simple_app_bar.dart';
import '../../constants/app_colors.dart';
import '../../models/transaction.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final finance = Provider.of<FinanceProvider>(context);
    final auth = Provider.of<AuthProvider>(context);
    final transactions = finance.transactions.take(5).toList();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: SimpleAppBar(
        title: 'Welcome, ${auth.user?.name ?? 'User'}',
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, Routes.settings),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          BalanceCard(
            balance: finance.totalBalance,
            monthExpense: finance.monthExpense,
            creditScore: finance.creditScore,
            onViewCredit: () => Navigator.pushNamed(context, Routes.creditScore),
            primaryColor: AppColors.primary,
            secondaryColor: AppColors.secondary,
          ),
          const SizedBox(height: 20),
          Text(
            'Smart Expense Tracking',
            style: theme.textTheme.titleMedium?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          ...finance.budgets.map((b) => BudgetProgress(
            budget: b,
            primaryColor: AppColors.secondary,
            dangerColor: AppColors.secondary,
          )),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Recent Transactions',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  )),
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.secondary,
                ),
                onPressed: () => Navigator.pushNamed(context, Routes.transactions),
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...transactions.map((t) => TransactionTile(tx: t)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.secondary,
        child: const Icon(Icons.add),
        onPressed: () {
          final newTx = TransactionModel(
            id: DateTime.now().toIso8601String(),
            title: 'Coffee',
            category: 'Entertainment',
            amount: 120.0,
            date: DateTime.now(),
            isExpense: true,
          );
          finance.addTransaction(newTx);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Added Coffee')),
          );
        },
      ),
    );
  }
}

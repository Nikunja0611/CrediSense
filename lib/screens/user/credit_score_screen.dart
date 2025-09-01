import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../constants/app_colors.dart';
import '../../providers/finance_provider.dart';

// ---- MODEL ----
class CreditScoreModel {
  final double? lgbmScore;
  final double? xgbScore;
  final String riskCategory;
  final Map<String, dynamic>? userInputs;

  CreditScoreModel({
    this.lgbmScore,
    this.xgbScore,
    required this.riskCategory,
    this.userInputs,
  });

  factory CreditScoreModel.fromProvider(FinanceProvider finance) {
    return CreditScoreModel(
      lgbmScore: finance.creditScoreLgbm,
      xgbScore: finance.creditScoreXgb,
      riskCategory: finance.riskCategory ?? "Unknown",
      userInputs: finance.userInputs,
    );
  }
}

// ---- SCREEN ----
class CreditScoreScreen extends StatelessWidget {
  const CreditScoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final finance = Provider.of<FinanceProvider>(context);
    final data = CreditScoreModel.fromProvider(finance);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "CREDIT SCORE ANALYSIS",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
      ),
      body: _buildContent(data, finance),
    );
  }

  Widget _buildContent(CreditScoreModel data, FinanceProvider finance) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---- SCORE CHART ----
          _scoreChart(data, finance),

          const SizedBox(height: 20),

          // ---- RISK CARD ----
          _riskCard(data.riskCategory),

          const SizedBox(height: 20),

          // ---- INCOME vs EXPENSE CHART ----
          _incomeExpenseChart(finance),

          const SizedBox(height: 20),

          // ---- USER INPUTS ----
          if (data.userInputs != null && data.userInputs!.isNotEmpty)
            _userInputsSection(data.userInputs!),
        ],
      ),
    );
  }

  // --- Circular Score Chart ---
  Widget _scoreChart(CreditScoreModel data, FinanceProvider finance) {
    double lgbm = data.lgbmScore ?? finance.creditScore.toDouble();
    double xgb = data.xgbScore ?? finance.creditScore.toDouble();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Column(
        children: [
          const Text("Credit Score Overview",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          SizedBox(
            height: 180,
            child: PieChart(
              PieChartData(
                sections: [
                  PieChartSectionData(
                    value: lgbm,
                    color: Colors.blue,
                    title: "LGBM\n${lgbm.toStringAsFixed(0)}",
                    radius: 60,
                    titleStyle:
                        const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  PieChartSectionData(
                    value: xgb,
                    color: Colors.green,
                    title: "XGB\n${xgb.toStringAsFixed(0)}",
                    radius: 60,
                    titleStyle:
                        const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Risk Card ---
  Widget _riskCard(String risk) {
    Color bg;
    String tip;

    switch (risk) {
      case "Excellent":
        bg = Colors.green.shade100;
        tip = "🎉 You are eligible for the best credit deals.";
        break;
      case "Good":
        bg = Colors.blue.shade100;
        tip = "✅ Your score is strong. Maintain low utilization.";
        break;
      case "Average":
        bg = Colors.orange.shade100;
        tip = "⚠️ Improve by paying bills on time and reducing loans.";
        break;
      case "Moderate":
        bg = Colors.red.shade100;
        tip = "📉 High risk. Avoid late fees & reduce debt.";
        break;
      default:
        bg = Colors.red.shade200;
        tip = "❌ Very risky. Pay EMIs on time & clear pending debts.";
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text("💡 Recommendation: $tip",
          style: const TextStyle(fontSize: 16)),
    );
  }

  // --- Income vs Expense Chart ---
  Widget _incomeExpenseChart(FinanceProvider finance) {
    final totalBalance = finance.totalBalance;
    final monthlyExpense = finance.monthExpense;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Income vs Expense",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                barGroups: [
                  BarChartGroupData(x: 0, barRods: [
                    BarChartRodData(toY: totalBalance, color: Colors.blue),
                  ], showingTooltipIndicators: [0]),
                  BarChartGroupData(x: 1, barRods: [
                    BarChartRodData(toY: monthlyExpense, color: Colors.red),
                  ], showingTooltipIndicators: [0]),
                ],
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (v, _) {
                        switch (v.toInt()) {
                          case 0:
                            return const Text("Balance");
                          case 1:
                            return const Text("Expense");
                        }
                        return const Text("");
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- User Inputs Transparency ---
  Widget _userInputsSection(Map<String, dynamic> inputs) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Your Submitted Details",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const Divider(),
          ...inputs.entries.map((entry) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: Text("${entry.key}:",
                            style:
                                const TextStyle(fontWeight: FontWeight.w500))),
                    const SizedBox(width: 10),
                    Text(entry.value.toString(),
                        style: const TextStyle(color: Colors.black54)),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../constants/app_colors.dart';

class CreditScoreScreen extends StatelessWidget {
  const CreditScoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double score = 678;
    final List<double> scoreTrend = [620, 640, 655, 670, 678];
    final List<double> utilizationTrend = [60, 55, 50, 48, 42];
    final int missedPayments = 2;
    final int onTimePayments = 18;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.creditScoreTitle.toUpperCase(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // CREDIT SCORE CARD (Prototype style)
            // CREDIT SCORE CARD (Fixed Pie + Center Text)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF003366), Color(0xFF006699)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6)],
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        PieChart(
                          PieChartData(
                            sectionsSpace: 0,
                            centerSpaceRadius: 35,
                            startDegreeOffset: -90,
                            sections: [
                              PieChartSectionData(
                                value: score,
                                color: Colors.pinkAccent,
                                radius: 18,
                                showTitle: false,
                                borderSide: BorderSide.none,
                              ),
                              PieChartSectionData(
                                value: 850 - score,
                                color: Colors.grey.shade300,
                                radius: 18,
                                showTitle: false,
                              ),
                            ],
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              score.toStringAsFixed(0),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const Text(
                              "/850",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Text(
                      "$score — Fair\nNot bad, but not strong enough to get the best deals.",
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 20),

            // SCORE LOWERING FACTORS
            const Text("SCORE-LOWERING FACTORS",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            _factorCard("Recent late payment on ₹X EMI"),
            _factorCard("Credit card utilization over 50%"),
            const SizedBox(height: 20),

            // FIX MY SCORE
            const Text("FIX MY SCORE!",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            _factorCard(
                "Pay down ₹X on your credit card to boost by ~20 points"),
            _factorCard("Set auto-pay to avoid missing EMIs"),
            const SizedBox(height: 20),

            // ANALYSIS & GRAPHS
            _AnalysisCard(
              title: "Credit Score Trend",
              chart: _buildLineChart(scoreTrend, Colors.blueAccent),
              tip: scoreTrend.last > scoreTrend.first
                  ? "Your score is improving, keep paying bills on time."
                  : "Score is dropping, check spending and late payments.",
            ),
            const SizedBox(height: 16),
            _AnalysisCard(
              title: "Credit Utilization (%)",
              chart: _buildLineChart(utilizationTrend, Colors.orangeAccent),
              tip: utilizationTrend.last > 50
                  ? "Lower usage to below 30% for faster score growth."
                  : "Good utilization, maintain below 30%.",
            ),
            const SizedBox(height: 16),
            _AnalysisCard(
              title: "Payment History",
              chart: _buildBarChart(missedPayments, onTimePayments),
              tip: missedPayments > 0
                  ? "Avoid missing EMI payments to prevent score drops."
                  : "Great! No missed payments recently.",
            ),
          ],
        ),
      ),
    );
  }

  // FACTOR CARD WIDGET
  Widget _factorCard(String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.85),
        borderRadius: BorderRadius.circular(12),
      ),
      child:
          Text(text, style: const TextStyle(color: Colors.white, fontSize: 14)),
    );
  }

  // LINE CHART BUILDER
  Widget _buildLineChart(List<double> values, Color color) {
    return SizedBox(
      height: 180,
      child: LineChart(
        LineChartData(
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) =>
                      Text("Q${value.toInt() + 1}")),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true, reservedSize: 28),
            ),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: values
                  .asMap()
                  .entries
                  .map((e) => FlSpot(e.key.toDouble(), e.value))
                  .toList(),
              isCurved: true,
              barWidth: 3,
              color: color,
              dotData: FlDotData(show: true),
            ),
          ],
        ),
      ),
    );
  }

  // BAR CHART BUILDER
  Widget _buildBarChart(int missed, int onTime) {
    return SizedBox(
      height: 180,
      child: BarChart(
        BarChartData(
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() == 0) return const Text("On-Time");
                  if (value.toInt() == 1) return const Text("Missed");
                  return const Text("");
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true, reservedSize: 28),
            ),
          ),
          borderData: FlBorderData(show: false),
          barGroups: [
            BarChartGroupData(x: 0, barRods: [
              BarChartRodData(
                  toY: onTime.toDouble(),
                  color: Colors.green,
                  width: 20,
                  borderRadius: BorderRadius.circular(4))
            ]),
            BarChartGroupData(x: 1, barRods: [
              BarChartRodData(
                  toY: missed.toDouble(),
                  color: Colors.red,
                  width: 20,
                  borderRadius: BorderRadius.circular(4))
            ]),
          ],
        ),
      ),
    );
  }
}

// REUSABLE ANALYSIS CARD
class _AnalysisCard extends StatelessWidget {
  final String title;
  final Widget chart;
  final String tip;

  const _AnalysisCard({
    required this.title,
    required this.chart,
    required this.tip,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, spreadRadius: 2),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          chart,
          const SizedBox(height: 8),
          Text("💡 $tip",
              style: const TextStyle(color: Colors.black87, fontSize: 14)),
        ],
      ),
    );
  }
}
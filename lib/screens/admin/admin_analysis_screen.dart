import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../constants/app_colors.dart';

class AdminAnalysisScreen extends StatelessWidget {
  const AdminAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text("Analysis"), backgroundColor: AppColors.primary),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            const Text("Monthly Loan Trends", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            SizedBox(height: 200, child: LineChart(LineChartData(
              gridData: FlGridData(show: false),
              titlesData: FlTitlesData(show: true),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: [FlSpot(1, 20), FlSpot(2, 40), FlSpot(3, 35), FlSpot(4, 60), FlSpot(5, 55)],
                  isCurved: true,
                  color: Colors.blue,
                  barWidth: 3,
                )
              ],
            ))),
            const SizedBox(height: 20),
            const Text("Risk Level Distribution", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            SizedBox(height: 200, child: PieChart(PieChartData(
              sections: [     
                PieChartSectionData(color: Colors.green, value: 60, title: "Low"),
                PieChartSectionData(color: Colors.orange, value: 25, title: "Medium"),
                PieChartSectionData(color: Colors.red, value: 15, title: "High"),
              ],
            ))),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class AnalysisPage extends StatelessWidget {
  const AnalysisPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Analysis',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            sectionTitle('Monthly Loan Trends'),
            SizedBox(height: 200, child: _buildLineChart()),

            sectionTitle('Loan Disbursement Volume'),
            SizedBox(height: 200, child: _buildBarChart()),

            sectionTitle('Risk Level Distribution'),
            SizedBox(height: 200, child: _buildPieChart()),

            sectionTitle('Defaulters by Month'),
            SizedBox(height: 200, child: _buildDefaultersBar()),

            sectionTitle('On-time vs Late Payments'),
            SizedBox(height: 200, child: _buildOnTimeVsLateBar()),

            sectionTitle('Loans by Type'),
            SizedBox(height: 200, child: _buildLoanTypePie()),
          ],
        ),
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.blue,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// Line Chart - Monthly Loan Trends
  Widget _buildLineChart() {
    return LineChart(
      LineChartData(
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, _) {
                const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
                if (value.toInt() >= 0 && value.toInt() < months.length) {
                  return Text(months[value.toInt()]);
                }
                return const SizedBox();
              },
            ),
          ),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
        ),
        lineBarsData: [
          LineChartBarData(
            isCurved: true,
            spots: [
              const FlSpot(0, 20),
              const FlSpot(1, 45),
              const FlSpot(2, 40),
              const FlSpot(3, 60),
              const FlSpot(4, 55),
              const FlSpot(5, 70),
            ],
            color: Colors.blue,
            barWidth: 3,
            dotData: FlDotData(show: true),
          ),
          LineChartBarData(
            isCurved: true,
            spots: [
              const FlSpot(0, 5),
              const FlSpot(1, 10),
              const FlSpot(2, 12),
              const FlSpot(3, 9),
              const FlSpot(4, 11),
              const FlSpot(5, 7),
            ],
            color: Colors.red,
            barWidth: 3,
            dotData: FlDotData(show: true),
          ),
        ],
      ),
    );
  }

  /// Bar Chart - Loan Disbursement Volume
  Widget _buildBarChart() {
    return BarChart(
      BarChartData(
        barGroups: [
          _barGroup(0, 10),
          _barGroup(1, 15),
          _barGroup(2, 15),
          _barGroup(3, 25),
          _barGroup(4, 18),
          _barGroup(5, 28),
        ],
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, _) {
                const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
                if (value.toInt() >= 0 && value.toInt() < months.length) {
                  return Text(months[value.toInt()]);
                }
                return const SizedBox();
              },
            ),
          ),
        ),
      ),
    );
  }

  BarChartGroupData _barGroup(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: Colors.blue,
          width: 15,
        ),
      ],
    );
  }

  /// Pie Chart - Risk Level Distribution
  Widget _buildPieChart() {
    return PieChart(
      PieChartData(
        sections: [
          PieChartSectionData(
            value: 60,
            color: Colors.green,
            title: 'Low',
            radius: 50,
          ),
          PieChartSectionData(
            value: 25,
            color: Colors.orange,
            title: 'Medium',
            radius: 50,
          ),
          PieChartSectionData(
            value: 15,
            color: Colors.red,
            title: 'High',
            radius: 50,
          ),
        ],
      ),
    );
  }

  /// Bar Chart - Defaulters by Month
  Widget _buildDefaultersBar() {
    return BarChart(
      BarChartData(
        barGroups: [
          _redBar(0, 2),
          _redBar(1, 4),
          _redBar(2, 5),
          _redBar(3, 3),
          _redBar(4, 6),
          _redBar(5, 7),
        ],
      ),
    );
  }

  BarChartGroupData _redBar(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: Colors.red,
          width: 15,
        ),
      ],
    );
  }

  /// On-time vs Late Payments
  Widget _buildOnTimeVsLateBar() {
    return BarChart(
      BarChartData(
        barGroups: List.generate(6, (i) {
          return BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: 90,
                color: Colors.green,
                width: 8,
              ),
              BarChartRodData(
                toY: 10,
                color: Colors.orange,
                width: 8,
              ),
            ],
          );
        }),
      ),
    );
  }

  /// Loans by Type Pie
  Widget _buildLoanTypePie() {
    return PieChart(
      PieChartData(
        sections: [
          PieChartSectionData(
            value: 35,
            color: Colors.blue,
            title: 'Housing',
            radius: 50,
          ),
          PieChartSectionData(
            value: 25,
            color: Colors.orange,
            title: 'Personal',
            radius: 50,
          ),
          PieChartSectionData(
            value: 20,
            color: Colors.purple,
            title: 'Vehicle',
            radius: 50,
          ),
          PieChartSectionData(
            value: 20,
            color: Colors.green,
            title: 'Education',
            radius: 50,
          ),
        ],
      ),
    );
  }
}

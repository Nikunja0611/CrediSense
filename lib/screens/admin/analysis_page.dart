import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class AnalysisPage extends StatelessWidget {
  const AnalysisPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).appBarTheme.iconTheme?.color ?? Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Analysis', style: Theme.of(context).appBarTheme.titleTextStyle ?? 
               const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _sectionTitle('Monthly Loan Trends', context),
            SizedBox(height: 200, child: _buildLineChart(context)),
            _sectionTitle('Loan Disbursement Volume', context),
            SizedBox(height: 200, child: _buildBarChart(context)),
            _sectionTitle('Risk Level Distribution', context),
            SizedBox(height: 200, child: _buildPieChart(context)),
            _sectionTitle('Defaulters by Month', context),
            SizedBox(height: 200, child: _buildDefaultersBar(context)),
            _sectionTitle('On-time vs Late Payments', context),
            SizedBox(height: 200, child: _buildOnTimeVsLateBar(context)),
            _sectionTitle('Loans by Type', context),
            SizedBox(height: 200, child: _buildLoanTypePie(context)),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(title, style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }

  Widget _chartContainer(BuildContext context, Widget chart) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Theme.of(context).shadowColor.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: chart,
    );
  }

  FlTitlesData _getCommonTitles(BuildContext context) {
    return FlTitlesData(
      bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (value, _) => _getMonthTitle(value, context))),
      leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (value, _) => _getNumberTitle(value, context))),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    );
  }

  Widget _getMonthTitle(double value, BuildContext context) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
    if (value.toInt() >= 0 && value.toInt() < months.length) {
      return Text(months[value.toInt()], style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color, fontSize: 12));
    }
    return const SizedBox();
  }

  Widget _getNumberTitle(double value, BuildContext context) {
    return Text(value.toInt().toString(), style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color, fontSize: 12));
  }

  FlGridData _getCommonGrid(BuildContext context) {
    return FlGridData(
      show: true, drawVerticalLine: false,
      getDrawingHorizontalLine: (value) => FlLine(color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.1) ?? Colors.grey.withOpacity(0.1), strokeWidth: 1),
    );
  }

  FlBorderData _getCommonBorder(BuildContext context) {
    return FlBorderData(show: true, border: Border.all(color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.2) ?? Colors.grey.withOpacity(0.2), width: 1));
  }

  Widget _buildLineChart(BuildContext context) {
    return _chartContainer(context, LineChart(
      LineChartData(
        gridData: _getCommonGrid(context),
        titlesData: _getCommonTitles(context),
        borderData: _getCommonBorder(context),
        lineBarsData: [
          LineChartBarData(
            isCurved: true,
            spots: const [FlSpot(0, 20), FlSpot(1, 45), FlSpot(2, 40), FlSpot(3, 60), FlSpot(4, 55), FlSpot(5, 70)],
            color: Theme.of(context).colorScheme.primary,
            barWidth: 3,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(show: true, color: Theme.of(context).colorScheme.primary.withOpacity(0.1)),
          ),
          LineChartBarData(
            isCurved: true,
            spots: const [FlSpot(0, 5), FlSpot(1, 10), FlSpot(2, 12), FlSpot(3, 9), FlSpot(4, 11), FlSpot(5, 7)],
            color: const Color(0xFFF44336),
            barWidth: 3,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(show: true, color: const Color(0xFFF44336).withOpacity(0.1)),
          ),
        ],
      ),
    ));
  }

  Widget _buildBarChart(BuildContext context) {
    return _chartContainer(context, BarChart(
      BarChartData(
        barGroups: List.generate(6, (i) => BarChartGroupData(x: i, barRods: [
          BarChartRodData(toY: [10, 15, 15, 25, 18, 28][i].toDouble(), color: Theme.of(context).colorScheme.primary, width: 15,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4))),
        ])),
        gridData: _getCommonGrid(context),
        titlesData: _getCommonTitles(context),
        borderData: _getCommonBorder(context),
      ),
    ));
  }

  Widget _buildPieChart(BuildContext context) {
    final pieData = [
      {'value': 60.0, 'color': const Color(0xFF4CAF50), 'title': 'Low\n60%'},
      {'value': 25.0, 'color': const Color(0xFFFF9800), 'title': 'Medium\n25%'},
      {'value': 15.0, 'color': const Color(0xFFF44336), 'title': 'High\n15%'},
    ];

    return _chartContainer(context, PieChart(
      PieChartData(
        sections: pieData.map((data) => PieChartSectionData(
          value: data['value'] as double,
          color: data['color'] as Color,
          title: data['title'] as String,
          titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
          radius: 60,
        )).toList(),
        sectionsSpace: 2,
        centerSpaceRadius: 0,
      ),
    ));
  }

  Widget _buildDefaultersBar(BuildContext context) {
    return _chartContainer(context, BarChart(
      BarChartData(
        barGroups: List.generate(6, (i) => BarChartGroupData(x: i, barRods: [
          BarChartRodData(toY: [2, 4, 5, 3, 6, 7][i].toDouble(), color: const Color(0xFFF44336), width: 15,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4))),
        ])),
        gridData: FlGridData(show: true, drawVerticalLine: false, horizontalInterval: 2,
          getDrawingHorizontalLine: (value) => FlLine(color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.1) ?? Colors.grey.withOpacity(0.1), strokeWidth: 1)),
        titlesData: _getCommonTitles(context),
        borderData: _getCommonBorder(context),
      ),
    ));
  }

  Widget _buildOnTimeVsLateBar(BuildContext context) {
    return _chartContainer(context, Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _legendItem('On-time', const Color(0xFF4CAF50)),
            const SizedBox(width: 20),
            _legendItem('Late', const Color(0xFFFF9800)),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: BarChart(
            BarChartData(
              barGroups: List.generate(6, (i) => BarChartGroupData(x: i, barRods: [
                BarChartRodData(toY: 90, color: const Color(0xFF4CAF50), width: 10, borderRadius: const BorderRadius.vertical(top: Radius.circular(4))),
                BarChartRodData(toY: 10, color: const Color(0xFFFF9800), width: 10, borderRadius: const BorderRadius.vertical(top: Radius.circular(4))),
              ])),
              gridData: FlGridData(show: true, drawVerticalLine: false, horizontalInterval: 20,
                getDrawingHorizontalLine: (value) => FlLine(color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.1) ?? Colors.grey.withOpacity(0.1), strokeWidth: 1)),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (value, _) => _getMonthTitle(value, context))),
                leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (value, _) => Text('${value.toInt()}%', 
                  style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color, fontSize: 12)))),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: _getCommonBorder(context),
            ),
          ),
        ),
      ],
    ));
  }

  Widget _legendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildLoanTypePie(BuildContext context) {
    final loanTypes = [
      {'value': 35.0, 'color': Theme.of(context).colorScheme.primary, 'title': 'Housing\n35%'},
      {'value': 25.0, 'color': const Color(0xFFFF9800), 'title': 'Personal\n25%'},
      {'value': 20.0, 'color': const Color(0xFF9C27B0), 'title': 'Vehicle\n20%'},
      {'value': 20.0, 'color': const Color(0xFF4CAF50), 'title': 'Education\n20%'},
    ];

    return _chartContainer(context, PieChart(
      PieChartData(
        sections: loanTypes.map((data) => PieChartSectionData(
          value: data['value'] as double,
          color: data['color'] as Color,
          title: data['title'] as String,
          titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
          radius: 60,
        )).toList(),
        sectionsSpace: 2,
        centerSpaceRadius: 0,
      ),
    ));
  }
}
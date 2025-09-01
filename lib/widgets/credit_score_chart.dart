  import 'package:fl_chart/fl_chart.dart';
  import 'package:flutter/material.dart';

  class CreditScoreChart extends StatelessWidget {
    final List<double> segments; // e.g., [40, 25, 20, 15]

    const CreditScoreChart({super.key, required this.segments});

    @override
    Widget build(BuildContext context) {
      final colors = [
        const Color(0xFF70A6FF), // light blue
        const Color(0xFF7CD992), // green
        const Color(0xFF9E7BFF), // purple
        const Color(0xFF6BA8FF), // blue
      ];

      final total = segments.fold<double>(0, (p, e) => p + e);
      final sections = <PieChartSectionData>[];
      for (var i = 0; i < segments.length; i++) {
        final v = segments[i];
        sections.add(
          PieChartSectionData(
            color: colors[i % colors.length],
            value: v,
            radius: 55,
            showTitle: false,
          ),
        );
      }

      return SizedBox(
        height: 160,
        child: PieChart(
          PieChartData(
            sectionsSpace: 4,
            centerSpaceRadius: 24,
            sections: sections,
            startDegreeOffset: -30,
          ),
        ),
      );
    }
  }

import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AITipsCard extends StatelessWidget {
  final String tip;

  const AITipsCard({super.key, required this.tip});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.softPinkDark : AppColors.softPink,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.support_agent_rounded,
            size: 28,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : AppColors.primary,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              tip,
              style: const TextStyle(
                fontSize: 13.5,
                height: 1.35,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

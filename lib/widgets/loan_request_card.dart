import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../constants/app_colors.dart';

class LoanRequestCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String date;
  final VoidCallback onPressed;

  const LoanRequestCard({
    super.key,
    required this.icon,
    required this.title,
    required this.date,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.softPinkDark : AppColors.softPink,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.black.withOpacity(isDark ? 0.2 : 0.08),
          width: 0.6,
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor:
                isDark ? Colors.black54 : Colors.white,
            child: Icon(icon,
                color: isDark ? Colors.white : Colors.black87, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Applied on: $date',
                  style: TextStyle(
                    fontSize: 12.5,
                    color: isDark ? Colors.grey[300] : Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: BorderSide(
                color: isDark ? Colors.white70 : AppColors.primary,
                width: 1,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: onPressed,
            child: Text(AppLocalizations.of(context)!.viewStatus),
          ),
        ],
      ),
    );
  }
}

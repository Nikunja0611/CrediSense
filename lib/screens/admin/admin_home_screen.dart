import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  Widget _statCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.9),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white, size: 28),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 14)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(title: const Text("Admin Dashboard"), backgroundColor: AppColors.primary),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: _statCard("Total Loans", "1,245", Icons.account_balance, Colors.blue)),
                const SizedBox(width: 12),
                Expanded(child: _statCard("Pending", "87", Icons.timelapse, Colors.orange)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _statCard("Approved %", "72%", Icons.check_circle, Colors.green)),
                const SizedBox(width: 12),
                Expanded(child: _statCard("Rejected", "15", Icons.cancel, Colors.red)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

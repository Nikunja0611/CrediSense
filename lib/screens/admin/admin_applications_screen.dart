import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class AdminApplicationsScreen extends StatelessWidget {
  const AdminApplicationsScreen({super.key});

  Widget _applicationCard(String name, String loanType, String date, String status, Color statusColor) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(loanType, style: const TextStyle(fontSize: 12)),
            Text("Applied: $date", style: const TextStyle(fontSize: 11, color: Colors.grey)),
          ]),
          Chip(label: Text(status), backgroundColor: statusColor.withOpacity(0.2)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Applications"), backgroundColor: AppColors.primary),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          _applicationCard("Ravi Kumar", "Personal Loan", "10 Aug 2025", "Pending", Colors.orange),
          _applicationCard("Anita Sharma", "Home Loan", "01 Aug 2025", "Approved", Colors.green),
          _applicationCard("Vikas Mehra", "Car Loan", "29 Jul 2025", "Rejected", Colors.red),
        ],
      ),
    );
  }
}

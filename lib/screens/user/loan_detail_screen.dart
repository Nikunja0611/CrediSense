

import 'package:flutter/material.dart';
import 'loan_apply_form.dart';

class LoanDetailScreen extends StatelessWidget {
  final String loanTitle;
  final String loanDescription;
  final IconData icon;

  const LoanDetailScreen({
    super.key,
    required this.loanTitle,
    required this.loanDescription,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(loanTitle),
        backgroundColor: Colors.indigo,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 60, color: Colors.indigo),
            const SizedBox(height: 20),
            Text(
              loanTitle,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              loanDescription,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
            const Text(
              "Features:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text("✔ Low interest rates"),
            const Text("✔ Flexible repayment options"),
            const Text("✔ Quick approval process"),
            const Text("✔ Minimal documentation"),
            const Spacer(),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LoanApplyForm(loanTitle: loanTitle),
                    ),
                  );
                },
                child: const Text(
                  "Apply Now",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
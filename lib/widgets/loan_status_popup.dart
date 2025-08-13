import 'package:flutter/material.dart';

class LoanStatusPopup extends StatelessWidget {
  final String applicationId;
  final String dateApplied;
  final String currentStage;
  final String loanType;
  final String loanAmount;
  final String tenure;
  final String interestRate;
  final String status;

  const LoanStatusPopup({
    super.key,
    required this.applicationId,
    required this.dateApplied,
    required this.currentStage,
    required this.loanType,
    required this.loanAmount,
    required this.tenure,
    required this.interestRate,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Close Button
            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.close, size: 22),
              ),
            ),

            const SizedBox(height: 4),
            const Text("Application Details",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 6),
            _buildInfo("Application ID:", applicationId),
            _buildInfo("Date Applied:", dateApplied),
            _buildInfo("Current Stage:", currentStage),

            const SizedBox(height: 12),
            const Text("Loan Summary",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 6),
            _buildInfo("Loan Type:", loanType),
            _buildInfo("Loan Amount:", loanAmount),
            _buildInfo("Tenure:", tenure),
            _buildInfo("Interest Rate:", interestRate),

            const Divider(height: 20, thickness: 1),

            const Text("Application Progress",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Row(
              children: const [
                Icon(Icons.check_circle, color: Colors.green, size: 20),
                SizedBox(width: 4),
                Text("Applied"),
                Expanded(child: Divider(thickness: 1)),
                Icon(Icons.cancel, color: Colors.red, size: 20),
                SizedBox(width: 4),
                Text("Verified"),
                Expanded(child: Divider(thickness: 1)),
                Icon(Icons.remove_circle, color: Colors.grey, size: 20),
                SizedBox(width: 4),
                Text("Approved"),
              ],
            ),

            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0A3D91),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {},
                child: Text("Status - $status",
                    style: const TextStyle(color: Colors.white)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInfo(String title, String value) {
    return Row(
      children: [
        const Icon(Icons.play_arrow,
            size: 16, color: Color(0xFF0A3D91)),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            "$title $value",
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }
}

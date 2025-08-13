import 'package:flutter/material.dart';
import '../../widgets/loan_request_card.dart';
import '../../widgets/loan_status_popup.dart'; // New popup widget

class LoanRequestsScreen extends StatelessWidget {
  const LoanRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Loan Requests"),
        backgroundColor: const Color(0xFF003366),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          LoanRequestCard(
            icon: Icons.home,
            title: "Home Loan",
            date: "05 Aug 2025",
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => LoanStatusPopup(
                  applicationId: "HL2025-0456",
                  dateApplied: "05 Aug 2025",
                  currentStage: "Under Review",
                  loanType: "Personal Loan",
                  loanAmount: "₹3,00,000",
                  tenure: "3 years",
                  interestRate: "7.2% p.a.",
                  status: "Pending",
                ),
              );
            },
          ),
          const SizedBox(height: 10),
          LoanRequestCard(
            icon: Icons.school,
            title: "Education Loan",
            date: "01 Jul 2025",
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => LoanStatusPopup(
                  applicationId: "EL2025-0321",
                  dateApplied: "01 Jul 2025",
                  currentStage: "Verified",
                  loanType: "Education Loan",
                  loanAmount: "₹5,00,000",
                  tenure: "5 years",
                  interestRate: "6.5% p.a.",
                  status: "Approved",
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

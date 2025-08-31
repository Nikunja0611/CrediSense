import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../constants/app_colors.dart';
import '../../providers/finance_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/simple_app_bar.dart';
import '../../widgets/transaction_tile.dart';
import '../../widgets/credit_score_chart.dart';
import '../../widgets/ai_tips_card.dart';
import '../../widgets/loan_card.dart';
import '../../widgets/loan_request_card.dart';
import '../../routers.dart';
import '../user/ai_insights_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final finance = Provider.of<FinanceProvider>(context);
    final auth = Provider.of<AuthProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final transactions = finance.transactions.take(6).toList();

    return Scaffold(
      appBar: SimpleAppBar(title: AppLocalizations.of(context)!.dashboardTitle),
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      bottomNavigationBar: _BottomBar(),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          // Credit Score section card
          _RoundedSection(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionHeading(AppLocalizations.of(context)!.creditScoreTitle),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Expanded(
                      flex: 5,
                      child: CreditScoreChart(segments: [40, 25, 20, 15]),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _legendDot(const Color(0xFF70A6FF), 'Repayment'),
                          const SizedBox(height: 8),
                          _legendDot(const Color(0xFF7CD992), 'Utilization'),
                          const SizedBox(height: 8),
                          _legendDot(const Color(0xFF9E7BFF), 'Credit Age'),
                          const SizedBox(height: 8),
                          _legendDot(const Color(0xFF6BA8FF), 'Mix/Enquiries'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // AI Tips
          _RoundedSection(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionHeading(AppLocalizations.of(context)!.aiTipsTitle),
                const SizedBox(height: 8),
                AITipsCard(
                  tip:
                      'Your credit score is improving—keep paying bills on time to boost it further. '
                      'Reducing outstanding debts can raise your score and unlock better loan offers.',
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Today's Transactions
          _RoundedSection(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionHeading(AppLocalizations.of(context)!.todaysTransactions),
                const SizedBox(height: 8),
                ...transactions.map((t) => TransactionTile(tx: t)),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // Apply for new Loans (horizontal row)
          _sectionHeading('Apply for new Loans'),
          const SizedBox(height: 10),
          SizedBox(
            height: 150,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                LoanCard(
                  icon: Icons.home_rounded,
                  title: 'Housing Loan',
                  subtitle:
                      'Amount: ₹30,00,000  |  Tenure: 15 years  |  Interest Rate: 7.2% p.a.',
                  onTap: () {
                    Navigator.pushNamed(context, Routes.transactions);
                  },
                ),
                const SizedBox(width: 12),
                LoanCard(
                  icon: Icons.directions_car_filled_rounded,
                  title: 'Vehicle Loan',
                  subtitle:
                      'Amount: ₹8,00,000  |  Tenure: 5 years  |  Interest Rate: 9.1% p.a.',
                  onTap: () {
                    Navigator.pushNamed(context, Routes.transactions);
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // Loan Requests
          _RoundedSection(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionHeading('Loan Requests'),
                const SizedBox(height: 8),

                LoanRequestCard(
                  icon: Icons.school_rounded,
                  title: 'Educational Loan',
                  date: '22 July 2024',
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => LoanStatusPopup(
                        applicationId: "EL2024-0789",
                        dateApplied: "22 July 2024",
                        currentStage: "Verified",
                        loanType: "Educational Loan",
                        loanAmount: "₹8,00,000",
                        tenure: "5 years",
                        interestRate: "6.9% p.a.",
                        status: "Approved",
                      ),
                    );
                  },
                ),

                LoanRequestCard(
                  icon: Icons.account_balance_wallet_rounded,
                  title: 'Personal Loan',
                  date: '05 Aug 2025',
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => LoanStatusPopup(
                        applicationId: "PL2025-0456",
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _sectionHeading(String text) => Text(
        text,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w800,
        ),
      );

  static Widget _legendDot(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class _RoundedSection extends StatelessWidget {
  final Widget child;
  const _RoundedSection({required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white12 : Colors.black26,
          width: 0.8,
        ),
      ),
      child: child,
    );
  }
}

class _BottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkPrimary : AppColors.primary;

    return SafeArea(
      child: Container(
        height: 64,
        decoration: BoxDecoration(
          color: bg,
          border: Border(top: BorderSide(color: Colors.black.withOpacity(0.1))),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navItem(context, Icons.pie_chart_rounded, 'Credit Score', () {
              Navigator.pushNamed(context, Routes.creditScore);
            }),
            _navItem(context, Icons.attach_money_rounded, 'Loan', () {
              Navigator.pushNamed(context, Routes.loanuser);
            }),
            _navItem(context, Icons.psychology_alt_rounded, 'AI Insights', () {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => const AIInsightsScreen()),
  );
}),

            _navItem(context, Icons.person_rounded, 'Profile', () {
              Navigator.pushNamed(context, Routes.settings);
            }),
          ],
        ),
      ),
    );
  }

  Widget _navItem(
      BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Application Details",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              _detail("Application ID", applicationId),
              _detail("Date Applied", dateApplied),
              _detail("Current Stage", currentStage),
              const Divider(),
              const Text("Loan Summary",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              _detail("Loan Type", loanType),
              _detail("Loan Amount", loanAmount),
              _detail("Tenure", tenure),
              _detail("Interest Rate", interestRate),
              const Divider(),
              const Text("Application Progress",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Row(
                children: const [
                  Icon(Icons.check_circle, color: Colors.green, size: 18),
                  SizedBox(width: 6),
                  Text("Applied"),
                  SizedBox(width: 20),
                  Icon(Icons.radio_button_unchecked, color: Colors.red, size: 18),
                  SizedBox(width: 6),
                  Text("Verified"),
                ],
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF003366),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {},
                child: Text(
                  "Status - $status",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detail(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text("• $title: ",
              style: const TextStyle(fontWeight: FontWeight.w600)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/finance_provider.dart';
import 'dashboard_screen.dart';

class ManualInputForm extends StatefulWidget {
  const ManualInputForm({super.key});

  @override
  State<ManualInputForm> createState() => _ManualInputFormState();
}

class _ManualInputFormState extends State<ManualInputForm> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final annualIncomeCtrl = TextEditingController();
  final monthlySalaryCtrl = TextEditingController();
  final numAccountsCtrl = TextEditingController();
  final numCreditCardsCtrl = TextEditingController();
  final interestRateCtrl = TextEditingController();
  final numLoansCtrl = TextEditingController();
  final delayDaysCtrl = TextEditingController();
  final delayedPaymentsCtrl = TextEditingController();
  final creditMixCtrl = TextEditingController();
  final outstandingDebtCtrl = TextEditingController();
  final creditHistoryYearsCtrl = TextEditingController();
  final monthlyBalanceCtrl = TextEditingController();
  final upiTxnCountCtrl = TextEditingController();
  final upiSpendCtrl = TextEditingController();
  final billPaidRateCtrl = TextEditingController();
  final lateFeeCtrl = TextEditingController();
  final salaryDetectedCtrl = TextEditingController();
  final merchantDiversityCtrl = TextEditingController();

  // 🔹 New controllers for missing backend fields
  final ageCtrl = TextEditingController();
  final changedCreditLimitCtrl = TextEditingController();
  final numCreditInquiriesCtrl = TextEditingController();
  final creditUtilizationRatioCtrl = TextEditingController();
  final creditHistoryMonthsCtrl = TextEditingController();
  final totalEmiCtrl = TextEditingController();
  final amountInvestedCtrl = TextEditingController();

  // Dropdown values
  String? occupation;
  String? typeOfLoan;
  String? paymentOfMinAmount;
  String? paymentBehaviour;
  String? creditHistoryAge;

  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Initial Details Required"),
        centerTitle: true,
        backgroundColor: AppColors.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildField("Annual Income", annualIncomeCtrl, TextInputType.number,
                  validator: (v) => _validatePositive(v, "Annual Income")),
              _buildField("Monthly Inhand Salary", monthlySalaryCtrl, TextInputType.number,
                  validator: (v) => _validatePositive(v, "Monthly Salary")),
              _buildField("Number of Bank Accounts", numAccountsCtrl, TextInputType.number,
                  validator: (v) => _validateInt(v, "Bank Accounts")),
              _buildField("Number of Credit Cards", numCreditCardsCtrl, TextInputType.number,
                  validator: (v) => _validateInt(v, "Credit Cards")),
              _buildField("Interest Rate (%)", interestRateCtrl, TextInputType.number,
                  validator: (v) => _validateRange(v, "Interest Rate", 0, 100)),
              _buildField("Number of Loans", numLoansCtrl, TextInputType.number,
                  validator: (v) => _validateInt(v, "Loans")),
              _buildField("Delay from Due Date (days)", delayDaysCtrl, TextInputType.number,
                  validator: (v) => _validateNonNegative(v, "Delay Days")),
              _buildField("Number of Delayed Payments", delayedPaymentsCtrl, TextInputType.number,
                  validator: (v) => _validateNonNegative(v, "Delayed Payments")),
              _buildField("Credit Mix (0=Poor,1=Standard,2=Good)", creditMixCtrl, TextInputType.number,
                  validator: (v) => _validateChoice(v, "Credit Mix", [0, 1, 2])),
              _buildField("Outstanding Debt", outstandingDebtCtrl, TextInputType.number,
                  validator: (v) => _validatePositive(v, "Outstanding Debt")),
              _buildField("Credit History (Years)", creditHistoryYearsCtrl, TextInputType.number,
                  validator: (v) => _validateNonNegative(v, "Credit History")),
              _buildField("Monthly Balance", monthlyBalanceCtrl, TextInputType.number,
                  validator: (v) => _validateNumber(v, "Monthly Balance")),
              _buildField("UPI Transactions (30d)", upiTxnCountCtrl, TextInputType.number,
                  validator: (v) => _validateNonNegative(v, "UPI Transactions")),
              _buildField("UPI Spend (30d)", upiSpendCtrl, TextInputType.number,
                  validator: (v) => _validatePositive(v, "UPI Spend")),
              _buildField("Bills Paid on Time Rate (0-1)", billPaidRateCtrl, TextInputType.number,
                  validator: (v) => _validateRange(v, "On-time Rate", 0, 1)),
              _buildField("Late Fee Flag (0/1)", lateFeeCtrl, TextInputType.number,
                  validator: (v) => _validateChoice(v, "Late Fee Flag", [0, 1])),
              _buildField("Salary Detected (0/1)", salaryDetectedCtrl, TextInputType.number,
                  validator: (v) => _validateChoice(v, "Salary Detected", [0, 1])),
              _buildField("Merchant Diversity (30d)", merchantDiversityCtrl, TextInputType.number,
                  validator: (v) => _validateNonNegative(v, "Merchant Diversity")),

              // 🔹 Additional fields
              _buildField("Age", ageCtrl, TextInputType.number,
                  validator: (v) => _validatePositive(v, "Age")),
              _dropdownField("Occupation", ["Student", "Salaried", "Business Owner", "Self-Employed", "Other"],
                  (val) => setState(() => occupation = val)),
              _dropdownField("Type of Loan", ["Personal Loan", "Home Loan", "Car Loan", "Business Loan", "Education Loan", "Other"],
                  (val) => setState(() => typeOfLoan = val)),
              _buildField("Changed Credit Limit", changedCreditLimitCtrl, TextInputType.number,
                  validator: (v) => _validateNumber(v, "Changed Credit Limit")),
              _buildField("Number of Credit Inquiries", numCreditInquiriesCtrl, TextInputType.number,
                  validator: (v) => _validateNonNegative(v, "Credit Inquiries")),
              _buildField("Credit Utilization Ratio", creditUtilizationRatioCtrl, TextInputType.number,
                  validator: (v) => _validateRange(v, "Credit Utilization Ratio", 0, 1)),
              _textField("Credit History Age (e.g. '10 Years 6 Months')",
                  onChanged: (val) => creditHistoryAge = val),
              _dropdownField("Payment of Min Amount", ["Yes", "No"],
                  (val) => setState(() => paymentOfMinAmount = val)),
              _buildField("Total EMI per Month", totalEmiCtrl, TextInputType.number,
                  validator: (v) => _validateNumber(v, "EMI per Month")),
              _buildField("Amount Invested Monthly", amountInvestedCtrl, TextInputType.number,
                  validator: (v) => _validateNumber(v, "Amount Invested")),
              _dropdownField("Payment Behaviour", ["Regular", "Regular with occasional delays", "Irregular"],
                  (val) => setState(() => paymentBehaviour = val)),
              _buildField("Credit History Months", creditHistoryMonthsCtrl, TextInputType.number,
                  validator: (v) => _validateNonNegative(v, "History Months")),

              const SizedBox(height: 20),
              _loading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate() &&
                            occupation != null &&
                            typeOfLoan != null &&
                            paymentOfMinAmount != null &&
                            paymentBehaviour != null &&
                            creditHistoryAge != null) {
                          _submitForm();
                        } else {
                          _showError("Please fill all dropdowns");
                        }
                      },
                      child: const Text("Submit Details",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                    )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller, TextInputType type,
      {String? Function(String?)? validator}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: type,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: validator,
      ),
    );
  }

  Widget _dropdownField(String label, List<String> options, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        value: null,
        items: options.map((opt) => DropdownMenuItem(value: opt, child: Text(opt))).toList(),
        onChanged: onChanged,
        validator: (v) => v == null ? "Select $label" : null,
      ),
    );
  }

  Widget _textField(String label, {required Function(String) onChanged}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onChanged: onChanged,
        validator: (v) => v == null || v.isEmpty ? "Enter $label" : null,
      ),
    );
  }

  // Validation helpers
  String? _validatePositive(String? v, String label) {
    if (v == null || v.isEmpty) return "Enter $label";
    final val = double.tryParse(v);
    if (val == null || val <= 0) return "$label must be positive";
    return null;
  }

  String? _validateNonNegative(String? v, String label) {
    if (v == null || v.isEmpty) return "Enter $label";
    final val = double.tryParse(v);
    if (val == null || val < 0) return "$label must be ≥ 0";
    return null;
  }

  String? _validateInt(String? v, String label) {
    if (v == null || v.isEmpty) return "Enter $label";
    if (int.tryParse(v) == null) return "$label must be an integer";
    return null;
  }

  String? _validateRange(String? v, String label, double min, double max) {
    if (v == null || v.isEmpty) return "Enter $label";
    final val = double.tryParse(v);
    if (val == null || val < min || val > max) {
      return "$label must be between $min and $max";
    }
    return null;
  }

  String? _validateChoice(String? v, String label, List<int> choices) {
    if (v == null || v.isEmpty) return "Enter $label";
    final val = int.tryParse(v);
    if (val == null || !choices.contains(val)) {
      return "$label must be one of ${choices.join(", ")}";
    }
    return null;
  }

  String? _validateNumber(String? v, String label) {
    if (v == null || v.isEmpty) return "Enter $label";
    if (double.tryParse(v) == null) return "$label must be a number";
    return null;
  }

  Future<void> _submitForm() async {
    setState(() => _loading = true);

    final inputData = {
      "Annual_Income": double.parse(annualIncomeCtrl.text),
      "Monthly_Inhand_Salary": double.parse(monthlySalaryCtrl.text),
      "Num_Bank_Accounts": int.parse(numAccountsCtrl.text),
      "Num_Credit_Card": int.parse(numCreditCardsCtrl.text),
      "Interest_Rate": double.parse(interestRateCtrl.text),
      "Num_of_Loan": int.parse(numLoansCtrl.text),
      "Delay_from_due_date": int.parse(delayDaysCtrl.text),
      "Num_of_Delayed_Payment": int.parse(delayedPaymentsCtrl.text),
      "Credit_Mix": int.parse(creditMixCtrl.text),
      "Outstanding_Debt": double.parse(outstandingDebtCtrl.text),
      "Credit_History_Year": int.parse(creditHistoryYearsCtrl.text),
      "Monthly_Balance": double.parse(monthlyBalanceCtrl.text),
      "upi_txn_count_30d": int.parse(upiTxnCountCtrl.text),
      "upi_spend_30d": double.parse(upiSpendCtrl.text),
      "bill_paid_on_time_rate_90d": double.parse(billPaidRateCtrl.text),
      "late_fee_flag_90d": int.parse(lateFeeCtrl.text),
      "salary_detected": int.parse(salaryDetectedCtrl.text),
      "merchant_diversity_30d": int.parse(merchantDiversityCtrl.text),

      // 🔹 Added fields
      "Age": int.parse(ageCtrl.text),
      "Occupation": occupation!,
      "Type_of_Loan": typeOfLoan!,
      "Changed_Credit_Limit": double.parse(changedCreditLimitCtrl.text),
      "Num_Credit_Inquiries": int.parse(numCreditInquiriesCtrl.text),
      "Credit_Utilization_Ratio": double.parse(creditUtilizationRatioCtrl.text),
      "Credit_History_Age": creditHistoryAge!,
      "Payment_of_Min_Amount": paymentOfMinAmount!,
      "Total_EMI_per_month": double.parse(totalEmiCtrl.text),
      "Amount_invested_monthly": double.parse(amountInvestedCtrl.text),
      "Payment_Behaviour": paymentBehaviour!,
      "Credit_History_Months": int.parse(creditHistoryMonthsCtrl.text),
    }; 

    try {
      final res = await http.post(
        Uri.parse("http://172.22.82.223:8000/predict"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(inputData),
      );

      if (res.statusCode == 200) {
  final result = jsonDecode(res.body);

  final auth = Provider.of<AuthProvider>(context, listen: false);
  final finance = Provider.of<FinanceProvider>(context, listen: false);

  // ✅ Save onboarding completion
  auth.completeOnboarding();

  // ✅ Store user inputs in provider
  finance.updateUserInputs(inputData);

  // ✅ Store credit scores in provider
  finance.updateCreditScores(
    lgbm: (result["credit_score_lgbm"] as num?)?.toDouble(),
    xgb: (result["credit_score_xgb"] as num?)?.toDouble(),
    category: result["risk_category"],
  );

  // ✅ Navigate to Dashboard
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (_) => DashboardScreen()),
    (route) => false,
  );

  // Show a toast/snackbar with score
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        "Onboarding complete ✅ Credit Score: ${result["credit_score_lgbm"]} | Risk: ${result["risk_category"]}",
      ),
      backgroundColor: Colors.green,
    ),
  );
      } else {
        _showError("Failed to fetch credit score. Try again.");
      }
    } catch (e) {
      _showError("Error: $e");
    }

    setState(() => _loading = false);
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.red),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoanApplyForm extends StatefulWidget {
  final String loanTitle;
  const LoanApplyForm({super.key, required this.loanTitle});

  @override
  State<LoanApplyForm> createState() => _LoanApplyFormState();
}

class _LoanApplyFormState extends State<LoanApplyForm> {
  final _formKey = GlobalKey<FormState>();
  final _controllers = List.generate(4, (_) => TextEditingController());
  bool _termsAccepted = false;

  @override
  void dispose() {
    for (var controller in _controllers) controller.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_termsAccepted) {
      _showSnackBar("Please accept Terms & Conditions", Colors.red);
      return;
    }
    if (_formKey.currentState!.validate()) {
      try {
        // ✅ Save loan application to Firestore
        await FirebaseFirestore.instance.collection('loan_applications').add({
          'fullName': _controllers[0].text.trim(),
          'email': _controllers[1].text.trim(),
          'loanAmount': _controllers[2].text.trim(),
          'monthlyIncome': _controllers[3].text.trim(),
          'loanTitle': widget.loanTitle,
          'status': 'Pending',
          'termsAccepted': _termsAccepted,
          'createdAt': FieldValue.serverTimestamp(),
        });

        _showSnackBar("Application submitted for ${widget.loanTitle}!", Colors.green);
        Navigator.pop(context);
      } catch (e) {
        _showSnackBar("Error: $e", Colors.red);
      }
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }

  void _showTermsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("📜 Terms & Conditions"),
        content: const SingleChildScrollView(
          child: Text(
            "1. Eligibility\n"
            "• Applicant must be at least 18 years of age and a resident of India.\n"
            "• Valid KYC documents (Aadhaar, PAN, etc.) and income details are mandatory.\n\n"
            "2. Loan Disbursement\n"
            "• Loan approval is subject to verification of information provided.\n"
            "• The sanctioned loan amount will be credited directly to the applicant's registered bank account.\n\n"
            "3. Interest & Charges\n"
            "• Interest will be charged at the rate communicated during approval.\n"
            "• Applicable processing fees and service charges, if any, will be disclosed before disbursement.\n\n"
            "4. Repayment\n"
            "• Repayments must be made as per the agreed EMI schedule.\n"
            "• Late or missed payments will attract additional penalty charges.\n"
            "• Prepayment or foreclosure is allowed as per policy, and may involve nominal charges.\n\n"
            "5. Default\n"
            "• Continuous failure to repay may lead to legal recovery action.\n"
            "• Default details may be reported to credit bureaus, impacting credit score.\n\n"
            "6. User Obligations\n"
            "• All information provided must be true, complete, and accurate.\n"
            "• The loan amount must not be used for unlawful or prohibited activities.\n\n"
            "7. Data Privacy\n"
            "• Personal and financial data will be collected for processing the loan in compliance with RBI guidelines.\n"
            "• Information may be shared with authorized third parties such as credit bureaus and regulators, but will not be misused or sold.\n\n"
            "8. Rights of the Bank/App\n"
            "• The bank reserves the right to accept, reject, or modify any loan application.\n"
            "• Terms & Conditions may be updated as per changes in law, RBI regulations, or bank policies.\n\n"
            "✅ By applying for a loan, you acknowledge that you have read, understood, and agreed to these Terms & Conditions.",
            style: TextStyle(fontSize: 14),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > 600;
    
    return Scaffold(
      appBar: AppBar(
        title: Text("Apply for ${widget.loanTitle}"),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: isWideScreen ? 500 : screenWidth * 0.9,
          ),
          padding: EdgeInsets.all(isWideScreen ? 24 : 16),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                ..._buildFormFields(),
                const SizedBox(height: 24),
                _buildTermsCheckbox(),
                const SizedBox(height: 24),
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildFormFields() {
    final fields = [
      {"label": "Full Name", "type": TextInputType.text},
      {"label": "Email", "type": TextInputType.emailAddress},
      {"label": "Loan Amount", "type": TextInputType.number},
      {"label": "Monthly Income", "type": TextInputType.number},
    ];

    return fields.asMap().entries.map((entry) {
      int index = entry.key;
      String label = entry.value["label"] as String;
      TextInputType type = entry.value["type"] as TextInputType;
      
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: TextFormField(
          controller: _controllers[index],
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
          keyboardType: type,
          validator: (val) => val?.isEmpty == true ? "Enter $label" : 
                             (label == "Email" && !val!.contains("@")) ? "Enter valid email" : null,
        ),
      );
    }).toList();
  }

  Widget _buildTermsCheckbox() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: _termsAccepted,
          onChanged: (val) => setState(() => _termsAccepted = val!),
          activeColor: Colors.indigo,
        ),
        Expanded(
          child: GestureDetector(
            onTap: _showTermsDialog,
            child: const Text(
              "I agree to the Terms & Conditions",
              style: TextStyle(
                decoration: TextDecoration.underline,
                color: Colors.indigo,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.indigo,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: _submitForm,
        child: const Text(
          "Submit Application",
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }
}

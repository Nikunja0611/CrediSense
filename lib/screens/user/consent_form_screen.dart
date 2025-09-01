import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class ConsentFormScreen extends StatefulWidget {
  const ConsentFormScreen({super.key});

  @override
  State<ConsentFormScreen> createState() => _ConsentFormScreenState();
}

class _ConsentFormScreenState extends State<ConsentFormScreen> {
  bool accepted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Consent Form"),
        centerTitle: true,
        backgroundColor: AppColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Intro
            Text(
              "Before we proceed, we need your consent.",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 12),

            // Consent Text
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  "By continuing, you agree to share your manual details "
                  "(income, loans, credit history, etc.) along with alternate data "
                  "like UPI transactions and SMS-derived financial activity. "
                  "This information will only be used to calculate and explain your credit score securely.",
                  style: const TextStyle(fontSize: 15, height: 1.4),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Checkbox
            Row(
              children: [
                Checkbox(
                  value: accepted,
                  onChanged: (val) {
                    setState(() => accepted = val ?? false);
                  },
                  activeColor: AppColors.secondary,
                ),
                const Expanded(
                  child: Text(
                    "I have read and understood the consent terms.",
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Continue Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      accepted ? AppColors.primary : Colors.grey.shade400,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: accepted
                    ? () {
                        Navigator.pushNamed(context, "/manualInputForm");
                      }
                    : null,
                child: const Text(
                  "Continue",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



import 'package:flutter/material.dart';
import 'loan_detail_screen.dart';

class LoanUser extends StatelessWidget {
  const LoanUser({super.key});

  final List<Map<String, dynamic>> loanCategories = const [
    {
      "title": "Personal Loan",
      "description": "Quick loans for personal needs with flexible EMIs.",
      "icon": Icons.account_balance_wallet,
    },
    {
      "title": "Home Loan",
      "description": "Affordable housing loans with long repayment tenure.",
      "icon": Icons.house,
    },
    {
      "title": "Education Loan",
      "description": "Finance for higher education with easy repayment.",
      "icon": Icons.school,
    },
    {
      "title": "Car/Vehicle Loan",
      "description": "Get your dream vehicle with our easy loan process.",
      "icon": Icons.directions_car,
    },
    {
      "title": "Business Loan",
      "description": "Expand or start your business with financial support.",
      "icon": Icons.business_center,
    },
    {
      "title": "Gold Loan",
      "description": "Instant loan by pledging your gold assets.",
      "icon": Icons.star,
    },
    {
      "title": "Agriculture Loan",
      "description": "Loans designed for farmers and agricultural needs.",
      "icon": Icons.agriculture,
    },
    {
      "title": "Medical Loan",
      "description": "Manage healthcare expenses with quick approval.",
      "icon": Icons.local_hospital,
    },
    {
      "title": "Travel Loan",
      "description": "Explore the world with financial support for travel.",
      "icon": Icons.flight_takeoff,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Loan Categories"),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: loanCategories.length,
        itemBuilder: (context, index) {
          final loan = loanCategories[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
            margin: const EdgeInsets.only(bottom: 15),
            child: ListTile(
              leading: Icon(loan["icon"], size: 35, color: Colors.indigo),
              title: Text(
                loan["title"],
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              subtitle: Text(loan["description"]),
              trailing: const Icon(Icons.arrow_forward_ios, size: 18),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LoanDetailScreen(
                      loanTitle: loan["title"],
                      loanDescription: loan["description"],
                      icon: loan["icon"],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
import 'package:flutter/material.dart';

class LoanApplicationsPage extends StatefulWidget {
  @override
  _LoanApplicationsPageState createState() => _LoanApplicationsPageState();
}

class _LoanApplicationsPageState extends State<LoanApplicationsPage> {
  Map<String, dynamic>? selectedApplicant;
  String searchQuery = '';

  final List<Map<String, dynamic>> applicants = [
    {
      'name': 'Fauget Cafe',
      'date': 'May 4th, 2024',
      'loanType': 'Education',
      'status': 'Accepted',
      'customerId': 'EC12346',
      'contact': '1234567890',
      'email': 'johndoe@example.com',
      'address': '123 Street, City, State',
      'employment': 'Software engineer',
      'amount': '\$10000',
      'purpose': 'Home renovation',
      'terms': '12 months @ \$900/month',
      'interest': '5%',
      'collateral': 'House property',
      'creditScore': '650',
      'dti': '25%',
      'debt': '\$2000 (credit card)',
    },
    {
      'name': 'Larana, Inc.',
      'date': 'May 2nd, 2024',
      'loanType': 'Home Loan',
      'status': 'Waiting',
      'customerId': 'EC22345',
      'contact': '9876543210',
      'email': 'larana@example.com',
      'address': '456 Avenue, City, State',
      'employment': 'Business Owner',
      'amount': '\$250000',
      'purpose': 'New house purchase',
      'terms': '120 months @ \$1500/month',
      'interest': '4.5%',
      'collateral': 'House property',
      'creditScore': '720',
      'dti': '30%',
      'debt': '\$10000 (personal loan)',
    },
    {
      'name': 'Claudia Alves',
      'date': 'May 3rd, 2024',
      'loanType': 'Car loan',
      'status': 'Rejected',
      'customerId': 'EC33456',
      'contact': '5551234567',
      'email': 'claudia@example.com',
      'address': '789 Lane, City, State',
      'employment': 'Designer',
      'amount': '\$30000',
      'purpose': 'New car',
      'terms': '60 months @ \$500/month',
      'interest': '6%',
      'collateral': 'Car',
      'creditScore': '580',
      'dti': '40%',
      'debt': '\$5000 (credit card)',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: selectedApplicant == null ? buildApplicantList() : buildApplicantDetail(),
    );
  }

  Widget buildApplicantList() {
    // Filtering applicants based on search query
    final filteredApplicants = applicants.where((applicant) {
      final query = searchQuery.toLowerCase();
      return applicant['name'].toLowerCase().contains(query) ||
          applicant['loanType'].toLowerCase().contains(query);
    }).toList();

    // Count stats
    final total = applicants.length;
    final approved = applicants.where((a) => a['status'] == 'Accepted').length;
    final rejected = applicants.where((a) => a['status'] == 'Rejected').length;
    final pending = applicants.where((a) => a['status'] == 'Waiting').length;

    return Column(
      children: [
        // Header
        Container(
          padding: EdgeInsets.all(16),
          color: Colors.blue,
          width: double.infinity,
          child: Text(
            "Loan Applications",
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),

        // Stats row
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              buildStatCard("TOTAL\nAPPLICATIONS", total, Colors.blue),
              buildStatCard("PENDING", pending, Colors.orange),
              buildStatCard("APPROVED", approved, Colors.green),
              buildStatCard("REJECTED", rejected, Colors.red),
            ],
          ),
        ),

        // Search bar
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: "Search here",
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onChanged: (value) {
              setState(() {
                searchQuery = value;
              });
            },
          ),
        ),

        // Applicants list
        Expanded(
          child: ListView.builder(
            itemCount: filteredApplicants.length,
            itemBuilder: (context, index) {
              final applicant = filteredApplicants[index];
              return ListTile(
                leading: Icon(Icons.person),
                title: Text(applicant['name']),
                subtitle: Text("${applicant['loanType']} • ${applicant['date']}"),
                trailing: Text(
                  applicant['status'],
                  style: TextStyle(
                    color: applicant['status'] == 'Accepted'
                        ? Colors.green
                        : applicant['status'] == 'Rejected'
                            ? Colors.red
                            : Colors.orange,
                  ),
                ),
                onTap: () {
                  setState(() {
                    selectedApplicant = applicant;
                  });
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget buildApplicantDetail() {
    final a = selectedApplicant!;
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            color: Colors.blue,
            padding: EdgeInsets.all(16),
            width: double.infinity,
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      selectedApplicant = null;
                    });
                  },
                ),
                Expanded(
                  child: Text(
                    "Loan Application",
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          buildSection("Applicant Information", [
            "Name of the applicant: ${a['name']}",
            "Customer ID: ${a['customerId']}",
            "Contact: ${a['contact']}",
            "Email: ${a['email']}",
            "Address: ${a['address']}",
            "Employment: ${a['employment']}",
          ]),
          buildSection("Loan Details", [
            "Requested amount: ${a['amount']}",
            "Purpose: ${a['purpose']}",
            "Repayment Terms: ${a['terms']}",
            "Interest rate: ${a['interest']}",
            "Collateral: ${a['collateral']}",
          ]),
          buildSection("Risk Assessment", [
            "Credit score: ${a['creditScore']}",
            "Debt to income ratio: ${a['dti']}",
            "Existing debt: ${a['debt']}",
          ]),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: Colors.orange), child: Text("Waitlist")),
              ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: Colors.green), child: Text("Approve")),
              ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: Colors.red), child: Text("Reject")),
            ],
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget buildSection(String title, List<String> lines) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          SizedBox(height: 8),
          for (var line in lines) Text(line),
        ],
      ),
    );
  }

  Widget buildStatCard(String title, int value, Color color) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4),
          Text(
            value.toString(),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }
}

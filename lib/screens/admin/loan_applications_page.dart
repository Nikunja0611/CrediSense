import 'package:flutter/material.dart';

class LoanApplicationsPage extends StatefulWidget {
  @override
  _LoanApplicationsPageState createState() => _LoanApplicationsPageState();
}

class _LoanApplicationsPageState extends State<LoanApplicationsPage> {
  Map<String, dynamic>? selectedApplicant;
  String searchQuery = '';
  String sortBy = 'Latest';

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
      'amount': '\$10,000',
      'purpose': 'Home renovation',
      'terms': '12 months | \$900/month',
      'interest': '5%',
      'collateral': 'House property',
      'creditScore': '650',
      'dti': '25%',
      'debt': '\$2,000 (credit card)',
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
      'amount': '\$250,000',
      'purpose': 'New house purchase',
      'terms': '120 months | \$1,500/month',
      'interest': '4.5%',
      'collateral': 'House property',
      'creditScore': '720',
      'dti': '30%',
      'debt': '\$10,000 (personal loan)',
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
      'amount': '\$30,000',
      'purpose': 'New car',
      'terms': '60 months | \$500/month',
      'interest': '6%',
      'collateral': 'Car',
      'creditScore': '580',
      'dti': '40%',
      'debt': '\$5,000 (credit card)',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
        // Header with back button
        Container(
          padding: EdgeInsets.fromLTRB(8, 40, 16, 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.primary.withOpacity(0.8)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          width: double.infinity,
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white, size: 24),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              Expanded(
                child: Text(
                  "Loan Applications",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Stats row
        Container(
          margin: EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(child: buildStatCard("TOTAL\nAPPLICATIONS", total, Theme.of(context).colorScheme.primary)),
              SizedBox(width: 8),
              Expanded(child: buildStatCard("PENDING", pending, Color(0xFFFF9800))),
              SizedBox(width: 8),
              Expanded(child: buildStatCard("APPROVED", approved, Color(0xFF4CAF50))),
              SizedBox(width: 8),
              Expanded(child: buildStatCard("REJECTED", rejected, Color(0xFFF44336))),
            ],
          ),
        ),

        // Search bar and sort
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).shadowColor.withOpacity(0.1),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search here",
                      prefixIcon: Icon(Icons.search, color: Theme.of(context).iconTheme.color?.withOpacity(0.6)),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(width: 12),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).shadowColor.withOpacity(0.1),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Sort by", style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color, fontSize: 12)),
                    SizedBox(width: 4),
                    Text("Latest", style: TextStyle(fontWeight: FontWeight.w500)),
                    Icon(Icons.keyboard_arrow_down, size: 16),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Header text
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Click on the user profile to view more information",
              style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color, fontSize: 12),
            ),
          ),
        ),

        // Applicants list
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: filteredApplicants.length,
            itemBuilder: (context, index) {
              final applicant = filteredApplicants[index];
              return Container(
                margin: EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).shadowColor.withOpacity(0.05),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.all(16),
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    child: Icon(Icons.person, color: Theme.of(context).colorScheme.primary),
                  ),
                  title: Text(
                    applicant['name'],
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 4),
                      Text(
                        "${applicant['date']}",
                        style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color, fontSize: 12),
                      ),
                      SizedBox(height: 2),
                      Text(
                        applicant['loanType'],
                        style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color, fontSize: 14),
                      ),
                    ],
                  ),
                  trailing: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getStatusColor(applicant['status']).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      applicant['status'],
                      style: TextStyle(
                        color: _getStatusColor(applicant['status']),
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      selectedApplicant = applicant;
                    });
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Accepted':
        return Color(0xFF4CAF50);
      case 'Rejected':
        return Color(0xFFF44336);
      case 'Waiting':
        return Color(0xFFFF9800);
      default:
        return Colors.grey;
    }
  }

  Widget buildApplicantDetail() {
    final a = selectedApplicant!;
    return SingleChildScrollView(
      child: Column(
        children: [
          // Header with back button
          Container(
            padding: EdgeInsets.fromLTRB(8, 40, 16, 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.primary.withOpacity(0.8)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            width: double.infinity,
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white, size: 24),
                  onPressed: () {
                    setState(() {
                      selectedApplicant = null;
                    });
                  },
                ),
                Expanded(
                  child: Text(
                    "Loan Applications",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                buildSection("Applicant Information", [
                  "Name of the applicant: ${a['name']}",
                  "Customer ID: ${a['customerId']}",
                  "Contact: ${a['contact']}",
                  "Email: ${a['email']}",
                  "Address: ${a['address']}",
                  "Employment: ${a['employment']}",
                ]),
                SizedBox(height: 16),
                buildSection("Loan Details", [
                  "Requested amount: ${a['amount']}",
                  "Purpose: ${a['purpose']}",
                  "Repayment Terms: ${a['terms']}",
                  "Interest rate: ${a['interest']}",
                  "Collateral: ${a['collateral']}",
                ]),
                SizedBox(height: 16),
                buildSection("Risk Assessment", [
                  "Credit score: ${a['creditScore']}",
                  "Debt to income ratio: ${a['dti']}",
                  "Existing debt: ${a['debt']}",
                ]),
                SizedBox(height: 24),
                
                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFFF9800),
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          "Waitlist",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF4CAF50),
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          "Approve",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFF44336),
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          "Reject",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),

                // Admin Notes section
                buildSection("Admin Notes", []),
                Container(
                  width: double.infinity,
                  height: 100,
                  margin: EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).inputDecorationTheme.fillColor ?? 
                           Theme.of(context).colorScheme.surface.withOpacity(0.05),
                    border: Border.all(color: Theme.of(context).dividerColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    maxLines: null,
                    expands: true,
                    style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
                    decoration: InputDecoration(
                      hintText: "Enter any notes about this application....",
                      hintStyle: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSection(String title, List<String> lines) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          if (lines.isNotEmpty) ...[
            SizedBox(height: 12),
            for (var line in lines)
              Padding(
                padding: EdgeInsets.only(bottom: 6),
                child: Text(
                  line,
                  style: TextStyle(fontSize: 14, color: Theme.of(context).textTheme.bodyMedium?.color),
                ),
              ),
          ],
        ],
      ),
    );
  }

  Widget buildStatCard(String title, int value, Color color) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: color,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            value.toString(),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
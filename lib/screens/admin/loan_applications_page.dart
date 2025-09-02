import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoanApplicationsPage extends StatefulWidget {
  @override
  _LoanApplicationsPageState createState() => _LoanApplicationsPageState();
}

class _LoanApplicationsPageState extends State<LoanApplicationsPage> {
  Map<String, dynamic>? selectedApplicant;
  String searchQuery = '';
  String sortBy = 'Latest';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: selectedApplicant == null ? buildApplicantList() : buildApplicantDetail(),
    );
  }

  Widget buildApplicantList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('loan_applications')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final applicants = snapshot.data!.docs.map((doc) {
          return {
            'id': doc.id,
            ...doc.data() as Map<String, dynamic>,
          };
        }).toList();

        // Filtering applicants based on search query
        final filteredApplicants = applicants.where((applicant) {
          final query = searchQuery.toLowerCase();
          return (applicant['fullName'] ?? '').toString().toLowerCase().contains(query) ||
                 (applicant['loanTitle'] ?? '').toString().toLowerCase().contains(query);
        }).toList();

        // Count stats
        final total = applicants.length;
        final approved = applicants.where((a) => a['status'] == 'Approved').length;
        final rejected = applicants.where((a) => a['status'] == 'Rejected').length;
        final pending = applicants.where((a) => a['status'] == 'Pending').length;

        return Column(
          children: [
            // Header with back button
            Container(
              padding: const EdgeInsets.fromLTRB(8, 40, 16, 16),
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
                    icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Expanded(
                    child: Text(
                      "Loan Applications",
                      style: const TextStyle(
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
              margin: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(child: buildStatCard("TOTAL\nAPPLICATIONS", total, Theme.of(context).colorScheme.primary)),
                  const SizedBox(width: 8),
                  Expanded(child: buildStatCard("PENDING", pending, const Color(0xFFFF9800))),
                  const SizedBox(width: 8),
                  Expanded(child: buildStatCard("APPROVED", approved, const Color(0xFF4CAF50))),
                  const SizedBox(width: 8),
                  Expanded(child: buildStatCard("REJECTED", rejected, const Color(0xFFF44336))),
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
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Search here",
                          prefixIcon: Icon(Icons.search, color: Theme.of(context).iconTheme.color?.withOpacity(0.6)),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                        onChanged: (value) {
                          setState(() {
                            searchQuery = value;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).shadowColor.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text("Sort by", style: TextStyle(fontSize: 12)),
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
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Click on the user profile to view more information",
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ),

            // Applicants list
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: filteredApplicants.length,
                itemBuilder: (context, index) {
                  final applicant = filteredApplicants[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).shadowColor.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                        child: Icon(Icons.person, color: Theme.of(context).colorScheme.primary),
                      ),
                      title: Text(
                        applicant['fullName'] ?? "Unnamed",
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(
                            applicant['createdAt'] != null
                                ? (applicant['createdAt'] as Timestamp).toDate().toString()
                                : "",
                            style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color, fontSize: 12),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            applicant['loanTitle'] ?? "",
                            style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color, fontSize: 14),
                          ),
                        ],
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _getStatusColor(applicant['status'] ?? '').withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          applicant['status'] ?? "Pending",
                          style: TextStyle(
                            color: _getStatusColor(applicant['status'] ?? ''),
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
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Approved':
        return const Color(0xFF4CAF50);
      case 'Rejected':
        return const Color(0xFFF44336);
      case 'Pending':
        return const Color(0xFFFF9800);
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
            padding: const EdgeInsets.fromLTRB(8, 40, 16, 16),
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
                  icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
                  onPressed: () {
                    setState(() {
                      selectedApplicant = null;
                    });
                  },
                ),
                Expanded(
                  child: const Text(
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
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                buildSection("Applicant Information", [
                  "Name: ${a['fullName'] ?? ''}",
                  "Email: ${a['email'] ?? ''}",
                ]),
                const SizedBox(height: 16),
                buildSection("Loan Details", [
                  "Requested amount: ${a['loanAmount'] ?? ''}",
                  "Monthly Income: ${a['monthlyIncome'] ?? ''}",
                  "Loan Type: ${a['loanTitle'] ?? ''}",
                ]),
                const SizedBox(height: 24),

                // Action buttons (update Firestore)
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          FirebaseFirestore.instance.collection('loan_applications').doc(a['id']).update({'status': 'Pending'});
                          setState(() => selectedApplicant = null);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF9800),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text("Waitlist", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          FirebaseFirestore.instance.collection('loan_applications').doc(a['id']).update({'status': 'Approved'});
                          setState(() => selectedApplicant = null);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4CAF50),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text("Approve", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          FirebaseFirestore.instance.collection('loan_applications').doc(a['id']).update({'status': 'Rejected'});
                          setState(() => selectedApplicant = null);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF44336),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text("Reject", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Admin Notes
                buildSection("Admin Notes", []),
                Container(
                  width: double.infinity,
                  height: 100,
                  margin: const EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).inputDecorationTheme.fillColor ??
                        Theme.of(context).colorScheme.surface.withOpacity(0.05),
                    border: Border.all(color: Theme.of(context).dividerColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const TextField(
                    maxLines: null,
                    expands: true,
                    decoration: InputDecoration(
                      hintText: "Enter any notes about this application....",
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Theme.of(context).colorScheme.primary)),
          if (lines.isNotEmpty) ...[
            const SizedBox(height: 12),
            for (var line in lines)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(line, style: TextStyle(fontSize: 14, color: Theme.of(context).textTheme.bodyMedium?.color)),
              ),
          ],
        ],
      ),
    );
  }

  Widget buildStatCard(String title, int value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(title,
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: color, height: 1.2),
              textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Text(value.toString(), style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}

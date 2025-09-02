import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../widgets/simple_app_bar.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Scaffold(
      appBar: const SimpleAppBar(title: 'Credisense'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(screenWidth * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ✅ Stats Grid from Firestore
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("loan_applications")
                    .snapshots(),
                builder: (context, snapshot) {
                  int total = 0, pending = 0, approved = 0, rejected = 0;

                  if (snapshot.hasData) {
                    final apps = snapshot.data!.docs
                        .map((d) => d.data() as Map<String, dynamic>)
                        .toList();
                    total = apps.length;
                    approved =
                        apps.where((a) => a['status'] == 'Approved').length;
                    rejected =
                        apps.where((a) => a['status'] == 'Rejected').length;
                    pending =
                        apps.where((a) => a['status'] == 'Pending').length;
                  }

                  return _buildStatsGrid(
                      context, isTablet, total, pending, approved, rejected);
                },
              ),
              SizedBox(height: screenWidth * 0.05),

              // ✅ Navigation Buttons
              _buildNavigationButtons(context, screenWidth),
              SizedBox(height: screenWidth * 0.05),

              // ✅ Search Bar
              _buildSearchBar(context),
              SizedBox(height: screenWidth * 0.05),

              // ✅ Defaulters List (dummy for now)
              _buildDefaultersList(context, screenWidth),
              SizedBox(height: screenWidth * 0.05),

              // ✅ Loan Applicants List from Firestore
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("loan_applications")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Text("No loan applications yet",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500));
                  }

                  final apps = snapshot.data!.docs.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;

                    // Format Firestore timestamp
                    String formattedDate = "N/A";
                    if (data["createdAt"] != null &&
                        data["createdAt"] is Timestamp) {
                      final createdAt =
                          (data["createdAt"] as Timestamp).toDate();
                      formattedDate =
                          "${createdAt.day}/${createdAt.month}/${createdAt.year}";
                    }

                    return {
                      "name": data["fullName"] ?? "Unknown", // ✅ Applicant name
                      "category":
                          data["loanTitle"] ?? "Loan", // ✅ Loan type/title
                      "status": data["status"] ?? "Pending", // ✅ Loan status
                      "amount": data["loanAmount"] ?? "0", // ✅ Loan amount
                      "income":
                          data["monthlyIncome"] ?? "0", // ✅ Monthly income
                      "email": data["email"] ?? "N/A", // ✅ Applicant email
                      "date": formattedDate, // ✅ Created date
                    };
                  }).toList();

                  return _buildLoanApplicants(context, screenWidth, apps);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 Stats Grid
  Widget _buildStatsGrid(BuildContext context, bool isTablet, int total,
      int pending, int approved, int rejected) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = constraints.maxWidth > 600 ? 4 : 2;
        double childAspectRatio = constraints.maxWidth > 600 ? 1.8 : 2.2;

        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: childAspectRatio,
          children: [
            _buildStatCard(context, 'TOTAL\nAPPLICATIONS', '$total',
                const Color(0xFF4285F4), Colors.white),
            _buildStatCard(context, 'PENDING', '$pending',
                const Color(0xFFFF5722), Colors.white),
            _buildStatCard(context, 'APPROVED', '$approved',
                const Color(0xFF4CAF50), Colors.white),
            _buildStatCard(context, 'REJECTED', '$rejected',
                const Color(0xFFFF4444), Colors.white),
          ],
        );
      },
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value,
      Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            flex: 2,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
                maxLines: 2,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Flexible(
            flex: 1,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                value,
                style: TextStyle(
                  color: textColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Loan Applicants Section
  Widget _buildLoanApplicants(BuildContext context, double screenWidth,
      List<Map<String, dynamic>> apps) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Loan Applicants',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Text(
              'Sort by',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        for (var app in apps)
          _buildApplicantItem(app["name"], app["category"], app["status"],
              app["date"], screenWidth),
      ],
    );
  }

  Widget _buildApplicantItem(String name, String category, String status,
      String date, double screenWidth) {
    Color statusColor = status == 'Approved'
        ? const Color(0xFF4CAF50)
        : status == 'Pending'
            ? const Color(0xFFFF9800)
            : const Color(0xFFFF5722);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.business, color: Colors.white, size: 20),
        ),
        title: Text(
          name,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: screenWidth < 350 ? 14 : 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(date, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
            Text(category,
                style: TextStyle(color: Colors.grey[600], fontSize: 12)),
          ],
        ),
        isThreeLine: true,
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Text(
            status,
            style: TextStyle(
              color: statusColor,
              fontWeight: FontWeight.bold,
              fontSize: screenWidth < 350 ? 12 : 14,
            ),
          ),
        ),
      ),
    );
  }

  // 🔹 Navigation Buttons
  Widget _buildNavigationButtons(BuildContext context, double screenWidth) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double buttonSize = constraints.maxWidth > 600 ? 60 : 50;
        double fontSize = constraints.maxWidth > 600 ? 14 : 12;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavButton(context, Icons.analytics, 'Analysis', '/analysis',
                buttonSize, fontSize),
            _buildNavButton(context, Icons.description, 'Applications',
                '/applications', buttonSize, fontSize),
            _buildNavButton(context, Icons.people, 'Community', '/community',
                buttonSize, fontSize),
            _buildNavButton(context, Icons.settings, 'Settings',
                '/adminsettings', buttonSize, fontSize),
          ],
        );
      },
    );
  }

  Widget _buildNavButton(BuildContext context, IconData icon, String label,
      String route, double size, double fontSize) {
    return Flexible(
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, route);
        },
        borderRadius: BorderRadius.circular(size / 2),
        child: Container(
          constraints: BoxConstraints(minWidth: size + 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  color: const Color(0xFF80CBC4),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  icon,
                  color: const Color(0xFF00695C),
                  size: size * 0.4,
                ),
              ),
              const SizedBox(height: 8),
              FittedBox(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 Search Bar
  Widget _buildSearchBar(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF1565C0),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.search, color: Colors.white),
                const SizedBox(width: 12),
                const Expanded(
                  child: TextField(
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Search here',
                      hintStyle: TextStyle(color: Colors.white70),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFF1565C0),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(Icons.tune, color: Colors.white),
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  // 🔹 Defaulters List (Dummy)
  Widget _buildDefaultersList(BuildContext context, double screenWidth) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFCDD2),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'DEFAULTERS LIST',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color(0xFF8E24AA),
            ),
          ),
          const SizedBox(height: 12),
          _buildDefaulterItem(context, 'John Doe', 'C123456', screenWidth),
          _buildDefaulterItem(context, 'John Smith', 'C123476', screenWidth),
          _buildDefaulterItem(context, 'David', 'C177456', screenWidth),
        ],
      ),
    );
  }

  Widget _buildDefaulterItem(
      BuildContext context, String name, String id, double screenWidth) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '$name | $id',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF2196F3),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              'View',
              style: TextStyle(
                color: Colors.white,
                fontSize: screenWidth < 350 ? 12 : 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
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
          padding: EdgeInsets.all(screenWidth * 0.04), // Responsive padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Stats Grid - Responsive
              _buildStatsGrid(context, isTablet),
              SizedBox(height: screenWidth * 0.05),

              // Navigation Buttons - Responsive
              _buildNavigationButtons(context, screenWidth),
              SizedBox(height: screenWidth * 0.05),

              // Search Bar - Responsive
              _buildSearchBar(context),
              SizedBox(height: screenWidth * 0.05),

              // Defaulters List - Responsive
              _buildDefaultersList(context, screenWidth),
              SizedBox(height: screenWidth * 0.05),

              // Loan Applicants - Responsive
              _buildLoanApplicants(context, screenWidth),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsGrid(BuildContext context, bool isTablet) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Determine grid layout based on available width
        int crossAxisCount = 2;
        double childAspectRatio = 2.2;
        
        if (constraints.maxWidth > 600) {
          crossAxisCount = 4; // 4 columns on tablets/wide screens
          childAspectRatio = 1.8;
        } else if (constraints.maxWidth < 350) {
          childAspectRatio = 1.8; // Adjust for very small screens
        }

        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: childAspectRatio,
          children: [
            _buildStatCard(context, 'TOTAL\nAPPLICATIONS', '1234', const Color(0xFF4285F4), Colors.white),
            _buildStatCard(context, 'PENDING', '1234', const Color(0xFFFF5722), Colors.white),
            _buildStatCard(context, 'APPROVED', '1234', const Color(0xFF4CAF50), Colors.white),
            _buildStatCard(context, 'REJECTED', '1234', const Color(0xFFFF4444), Colors.white),
          ],
        );
      },
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value, Color bgColor, Color textColor) {
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

  Widget _buildNavigationButtons(BuildContext context, double screenWidth) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Responsive button sizing
        double buttonSize = constraints.maxWidth > 600 ? 60 : 50;
        double fontSize = constraints.maxWidth > 600 ? 14 : 12;
        
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavButton(context, Icons.analytics, 'Analysis', '/analysis', buttonSize, fontSize),
            _buildNavButton(context, Icons.description, 'Applications', '/applications', buttonSize, fontSize),
            _buildNavButton(context, Icons.people, 'Community', '/community', buttonSize, fontSize),
            _buildNavButton(context, Icons.settings, 'Settings', '/adminsettings', buttonSize, fontSize),
          ],
        );
      },
    );
  }

  Widget _buildNavButton(BuildContext context, IconData icon, String label, String route, double size, double fontSize) {
    return Flexible(
      child: InkWell(
        onTap: () {
          // Changed from Navigator.pushNamed to Navigator.pushReplacementNamed
          // This prevents the back button from appearing on the destination screen
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

  Widget _buildDefaulterItem(BuildContext context, String name, String id, double screenWidth) {
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

  Widget _buildLoanApplicants(BuildContext context, double screenWidth) {
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
        _buildApplicantItem('Fauget Cafe', 'Education', 'Accepted', 'May 4th, 2024', screenWidth),
        _buildApplicantItem('Larana, Inc.', 'Home Loan', 'Waiting', 'May 3rd, 2024', screenWidth),
        _buildApplicantItem('Claudia Alves', 'Business', 'Rejected', 'May 2nd, 2024', screenWidth),
      ],
    );
  }

  Widget _buildApplicantItem(String name, String category, String status, String date, double screenWidth) {
    Color statusColor = status == 'Accepted'
        ? const Color(0xFF4CAF50)
        : status == 'Waiting'
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
          child: const Icon(
            Icons.business,
            color: Colors.white,
            size: 20,
          ),
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
            Text(
              date,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: screenWidth < 350 ? 11 : 12,
              ),
            ),
            Text(
              category,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: screenWidth < 350 ? 11 : 12,
              ),
            ),
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
}
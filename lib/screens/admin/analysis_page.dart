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
          padding: EdgeInsets.all(screenWidth * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatsGrid(isTablet),
              SizedBox(height: screenWidth * 0.05),
              _buildNavigationButtons(screenWidth),
              SizedBox(height: screenWidth * 0.05),
              _buildSearchBar(),
              SizedBox(height: screenWidth * 0.05),
              _buildDefaultersList(screenWidth),
              SizedBox(height: screenWidth * 0.05),
              _buildLoanApplicants(screenWidth),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsGrid(bool isTablet) {
    final stats = [
      {'title': 'TOTAL\nAPPLICATIONS', 'value': '1234', 'color': const Color(0xFF4285F4)},
      {'title': 'PENDING', 'value': '1234', 'color': const Color(0xFFFF5722)},
      {'title': 'APPROVED', 'value': '1234', 'color': const Color(0xFF4CAF50)},
      {'title': 'REJECTED', 'value': '1234', 'color': const Color(0xFFFF4444)},
    ];

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: isTablet ? 4 : 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: isTablet ? 1.8 : 2.2,
      children: stats.map((stat) => _buildStatCard(
        stat['title'] as String, 
        stat['value'] as String, 
        stat['color'] as Color
      )).toList(),
    );
  }

  Widget _buildStatCard(String title, String value, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            flex: 2,
            child: FittedBox(
              child: Text(title, textAlign: TextAlign.center, 
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                maxLines: 2),
            ),
          ),
          const SizedBox(height: 4),
          Flexible(
            child: FittedBox(
              child: Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons(double screenWidth) {
    final buttons = [
      {'icon': Icons.analytics, 'label': 'Analysis', 'route': '/analysis'},
      {'icon': Icons.description, 'label': 'Applications', 'route': '/applications'},
      {'icon': Icons.people, 'label': 'Community', 'route': '/community'},
      {'icon': Icons.settings, 'label': 'Settings', 'route': '/adminsettings'},
    ];

    final buttonSize = screenWidth > 600 ? 60.0 : 50.0;
    final fontSize = screenWidth > 600 ? 14.0 : 12.0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: buttons.map((btn) => 
        Flexible(child: _buildNavButton(
          btn['icon'] as IconData, 
          btn['label'] as String, 
          btn['route'] as String, 
          buttonSize, 
          fontSize
        ))
      ).toList(),
    );
  }

  Widget _buildNavButton(IconData icon, String label, String route, double size, double fontSize) {
    return Builder(
      builder: (context) => InkWell(
        onTap: () => Navigator.pushNamed(context, route),
        borderRadius: BorderRadius.circular(size / 2),
        child: Container(
          constraints: BoxConstraints(minWidth: size + 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: size, height: size,
                decoration: BoxDecoration(
                  color: const Color(0xFF80CBC4), shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: const Offset(0, 2))],
                ),
                child: Icon(icon, color: const Color(0xFF00695C), size: size * 0.4),
              ),
              const SizedBox(height: 8),
              FittedBox(child: Text(label, style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w500), textAlign: TextAlign.center)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF1565C0), borderRadius: BorderRadius.circular(25),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: const Offset(0, 2))],
            ),
            child: const Row(
              children: [
                Icon(Icons.search, color: Colors.white),
                SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Search here', hintStyle: TextStyle(color: Colors.white70),
                      border: InputBorder.none, isDense: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        Container(
          width: 48, height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFF1565C0), borderRadius: BorderRadius.circular(24),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: const Offset(0, 2))],
          ),
          child: IconButton(icon: const Icon(Icons.tune, color: Colors.white), onPressed: () {}),
        ),
      ],
    );
  }

  Widget _buildDefaultersList(double screenWidth) {
    final defaulters = [
      {'name': 'John Doe', 'id': 'C123456'},
      {'name': 'John Smith', 'id': 'C123476'},
      {'name': 'David', 'id': 'C177456'},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFCDD2), borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('DEFAULTERS LIST', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF8E24AA))),
          const SizedBox(height: 12),
          ...defaulters.map((d) => _buildDefaulterItem(d['name'] as String, d['id'] as String, screenWidth)),
        ],
      ),
    );
  }

  Widget _buildDefaulterItem(String name, String id, double screenWidth) {
    return Builder(
      builder: (context) => Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(25),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 2, offset: const Offset(0, 1))],
        ),
        child: Row(
          children: [
            Expanded(
              child: Text('$name | $id', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14, 
                color: Theme.of(context).textTheme.bodyLarge?.color)),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(color: const Color(0xFF2196F3), borderRadius: BorderRadius.circular(15)),
              child: Text('View', style: TextStyle(color: Colors.white, fontSize: screenWidth < 350 ? 12 : 13, fontWeight: FontWeight.w500)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoanApplicants(double screenWidth) {
    final applicants = [
      {'name': 'Fauget Cafe', 'category': 'Education', 'status': 'Accepted', 'date': 'May 4th, 2024'},
      {'name': 'Larana, Inc.', 'category': 'Home Loan', 'status': 'Waiting', 'date': 'May 3rd, 2024'},
      {'name': 'Claudia Alves', 'category': 'Business', 'status': 'Rejected', 'date': 'May 2nd, 2024'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Loan Applicants', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Text('Sort by', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
          ],
        ),
        const SizedBox(height: 12),
        ...applicants.map((a) => _buildApplicantItem(
          a['name'] as String, 
          a['category'] as String, 
          a['status'] as String, 
          a['date'] as String, 
          screenWidth
        )),
      ],
    );
  }

  Widget _buildApplicantItem(String name, String category, String status, String date, double screenWidth) {
    Color statusColor = status == 'Accepted'
        ? const Color(0xFF4CAF50)
        : status == 'Waiting'
            ? const Color(0xFFFF9800)
            : const Color(0xFFFF5722);

    return Builder(
      builder: (context) => Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
          leading: Container(
            width: 40, height: 40,
            decoration: BoxDecoration(color: Colors.grey[800], borderRadius: BorderRadius.circular(8)),
            child: const Icon(Icons.business, color: Colors.white, size: 20),
          ),
          title: Text(name, style: TextStyle(fontWeight: FontWeight.w600, fontSize: screenWidth < 350 ? 14 : 16)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(date, style: TextStyle(color: Colors.grey[600], fontSize: screenWidth < 350 ? 11 : 12)),
              Text(category, style: TextStyle(color: Colors.grey[600], fontSize: screenWidth < 350 ? 11 : 12)),
            ],
          ),
          isThreeLine: true,
          trailing: Text(status, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, 
            fontSize: screenWidth < 350 ? 12 : 14)),
        ),
      ),
    );
  }
}
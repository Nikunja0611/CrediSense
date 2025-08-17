import 'package:flutter/material.dart';
import '../../widgets/simple_app_bar.dart';


class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onPrimary;

    return Scaffold(
      appBar: const SimpleAppBar(title: 'Credisense'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Stats Grid
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 2.4, // more vertical space
                children: [
                  _buildStatCard(context, 'TOTAL\nAPPLICATIONS', '1234', Colors.blue, textColor),
                  _buildStatCard(context, 'PENDING', '1234', Colors.red, textColor),
                  _buildStatCard(context, 'APPROVED', '1234', Colors.green, textColor),
                  _buildStatCard(context, 'REJECTED', '1234', Colors.orange, textColor),
                ],
              ),
              const SizedBox(height: 20),

              // Navigation Buttons Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildNavButton(context, Icons.bar_chart, 'Analysis', '/analysis'),
                  _buildNavButton(context, Icons.description, 'Applications', '/applications'),
                  _buildNavButton(context, Icons.people, 'Community', '/community'),
                  _buildNavButton(context, Icons.settings, 'AdminSettings', '/adminsettings'),
                ],
              ),
              const SizedBox(height: 20),

              // Search Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Theme.of(context).colorScheme.surfaceVariant,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          hintText: 'Search here',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.tune),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Defaulters List
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 237, 133, 149),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('DEFAULTERS LIST', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    _buildDefaulterItem('John Doe', 'C123456'),
                    _buildDefaulterItem('John Smith', 'C123476'),
                    _buildDefaulterItem('David', 'C177456'),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Loan Applicants
              const Text('Loan Applicants', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              _buildApplicantItem('Fauget Cafe', 'Education', 'Accepted', 'May 4th, 2024'),
              _buildApplicantItem('Larana Inc.', 'Home Loan', 'Waiting', 'May 3rd, 2024'),
              _buildApplicantItem('Claudia Alves', 'Business', 'Accepted', 'May 2nd, 2024'),
            ],
          ),
        ),
      ),
    );
  }

  // Responsive Stat Card
  Widget _buildStatCard(BuildContext context, String title, String value, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(value, style: TextStyle(color: textColor, fontSize: 18)),
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton(BuildContext context, IconData icon, String label, String route) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, route),
      child: Column(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.teal[100],
            child: Icon(icon, color: Colors.teal[800]),
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildDefaulterItem(String name, String id) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        title: Text('$name | $id'),
        trailing: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(50, 30),
            padding: EdgeInsets.zero,
          ),
          child: const Text('View'),
        ),
      ),
    );
  }

  Widget _buildApplicantItem(String name, String category, String status, String date) {
    Color statusColor = status == 'Accepted'
        ? Colors.green
        : status == 'Waiting'
            ? Colors.orange
            : Colors.red;

    return ListTile(
      leading: const Icon(Icons.business),
      title: Text(name),
      subtitle: Text('$date\n$category'),
      isThreeLine: true,
      trailing: Text(status, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold)),
    );
  }
}
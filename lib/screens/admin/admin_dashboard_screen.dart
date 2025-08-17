import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import 'admin_home_screen.dart';
import 'admin_applications_screen.dart';
import 'admin_analysis_screen.dart';
import 'admin_community_screen.dart';
import 'admin_settings_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    AdminHomeScreen(),
    AdminApplicationsScreen(),
    AdminAnalysisScreen(),
    AdminCommunityScreen(),
    AdminSettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkPrimary : AppColors.primary;

    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: bg,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: "Applications"),
          BottomNavigationBarItem(icon: Icon(Icons.analytics), label: "Analysis"),
          BottomNavigationBarItem(icon: Icon(Icons.forum), label: "Community"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
        ],
      ),
    );
  }
}

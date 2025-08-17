import 'package:flutter/material.dart';

// Auth Screens
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';

// User Screens
import 'screens/user/dashboard_screen.dart';
import 'screens/user/transactions_screen.dart';
import 'screens/user/credit_score_screen.dart';
import 'screens/user/settings_screen.dart';

// Admin Screens
import 'screens/admin/admin_dashboard_screen.dart';
import 'screens/admin/admin_home_screen.dart';
import 'screens/admin/admin_applications_screen.dart';
import 'screens/admin/admin_analysis_screen.dart';
import 'screens/admin/admin_community_screen.dart';
import 'screens/admin/admin_settings_screen.dart';

class Routes {
  // Auth
  static const login = '/';
  static const signup = '/signup';

  // User
  static const dashboard = '/dashboard';
  static const transactions = '/transactions';
  static const creditScore = '/credit';
  static const settings = '/settings';

  // Admin Main
  static const admin = '/admin';

  // Admin Sub Pages
  static const adminHome = '/admin/home';
  static const adminApplications = '/admin/applications';
  static const adminAnalysis = '/admin/analysis';
  static const adminCommunity = '/admin/community';
  static const adminSettings = '/admin/settings';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      // Auth
      login: (ctx) => const LoginScreen(),
      signup: (ctx) => const SignupScreen(),

      // User
      dashboard: (ctx) => const DashboardScreen(),
      transactions: (ctx) => const TransactionsScreen(),
      creditScore: (ctx) => const CreditScoreScreen(),
      settings: (ctx) => const SettingsScreen(),

      // Admin
      admin: (ctx) => const AdminDashboardScreen(),
      adminHome: (ctx) => const AdminHomeScreen(),
      adminApplications: (ctx) => const AdminApplicationsScreen(),
      adminAnalysis: (ctx) => const AdminAnalysisScreen(),
      adminCommunity: (ctx) => const AdminCommunityScreen(),
      adminSettings: (ctx) => const AdminSettingsScreen(),
    };
  }
}

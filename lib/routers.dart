import 'package:flutter/material.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/user/dashboard_screen.dart';
import 'screens/user/transactions_screen.dart';
import 'screens/user/loan_users.dart';
import 'screens/user/credit_score_screen.dart';
import 'screens/user/settings_screen.dart';
import 'screens/admin/admin_dashboard_screen.dart';
import 'screens/admin/loan_applications_page.dart';
import 'screens/admin/community_page.dart';
import 'screens/admin/analysis_page.dart';
import 'screens/admin/admin_settings.dart';

class Routes {
  static const login = '/';
  static const signup = '/signup';
  static const dashboard = '/dashboard';
  static const transactions = '/transactions';
  static const loanuser = '/loanuser';
  static const creditScore = '/credit';
  static const settings = '/settings';
  static const admin = '/admin';
  static const analysis = '/analysis';
  static const community = '/community';
  static const applications = '/applications';
  static const adminsettings = '/adminsettings';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      login: (ctx) => const LoginScreen(),
      signup: (ctx) => const SignupScreen(),
      dashboard: (ctx) =>  DashboardScreen(),
      transactions: (ctx) => const TransactionsScreen(),
      loanuser: (ctx) => const LoanUser(),
      creditScore: (ctx) => const CreditScoreScreen(),
      settings: (ctx) => const SettingsScreen(),
      admin: (ctx) => const AdminDashboardScreen(),
      applications: (ctx) => LoanApplicationsPage(),
      community: (ctx) => const CommunityPage(),
      analysis: (ctx) => const AnalysisPage(),
      adminsettings: (ctx) => const AdminSettings(),
    };
  }
}
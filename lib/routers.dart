import 'package:flutter/material.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/user/dashboard_screen.dart';
import 'screens/user/transactions_screen.dart';
import 'screens/user/credit_score_screen.dart';
import 'screens/user/settings_screen.dart';
import 'screens/admin/admin_dashboard_screen.dart';

class Routes {
  static const login = '/';
  static const signup = '/signup';
  static const dashboard = '/dashboard';
  static const transactions = '/transactions';
  static const creditScore = '/credit';
  static const settings = '/settings';
  static const admin = '/admin';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      login: (ctx) => const LoginScreen(),
      signup: (ctx) => const SignupScreen(),
      dashboard: (ctx) => const DashboardScreen(),
      transactions: (ctx) => const TransactionsScreen(),
      creditScore: (ctx) => const CreditScoreScreen(),
      settings: (ctx) => const SettingsScreen(),
      admin: (ctx) => const AdminDashboardScreen(),
    };
  }
}

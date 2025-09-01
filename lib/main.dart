import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'providers/auth_provider.dart';
import 'providers/finance_provider.dart';
import 'providers/theme_provider.dart';
import 'services/mock_service.dart';
import 'providers/credit_score_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final mockService = MockService();
  await mockService.loadMockData();

  runApp(
    MultiProvider(
      providers: [
        Provider<MockService>.value(value: mockService),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => FinanceProvider(mockService)),
        ChangeNotifierProvider(create: (_) => ThemeProvider()), // ✅ Added
        ChangeNotifierProvider(create: (_) => CreditScoreProvider()),
      ],
      child: const CredisenseApp(),
    ),
  );
}

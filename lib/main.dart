import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'providers/auth_provider.dart';
import 'providers/finance_provider.dart';
import 'services/mock_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final mockService = MockService();
  await mockService.loadMockData(); // loads assets
  runApp(
    MultiProvider(
      providers: [
        Provider<MockService>.value(value: mockService),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => FinanceProvider(mockService)),
      ],
      child: const CredisenseApp(),
    ),
  );
}

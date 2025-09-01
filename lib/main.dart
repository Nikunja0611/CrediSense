import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart'; // ✅ Add this
import 'app.dart';
import 'providers/auth_provider.dart';
import 'providers/finance_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/language_provider.dart';
import 'services/mock_service.dart';
import 'firebase_options.dart';
import 'services/database_service.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await DatabaseService.database;



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize database
  
  
  final mockService = MockService();
  await mockService.loadMockData();

  // Create FinanceProvider and initialize SMS data
  final financeProvider = FinanceProvider(mockService);
  await financeProvider.initializeSMSData();

  runApp(
    MultiProvider(
      providers: [
        Provider<MockService>.value(value: mockService),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider.value(value: financeProvider),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
      ],
      child: const CredisenseApp(),
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'routers.dart';
import 'constants/app_colors.dart';
import 'providers/theme_provider.dart';

class CredisenseApp extends StatelessWidget {
  const CredisenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Credisense',
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.themeMode, // ✅ Dynamic theme
     theme: ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: AppColors.lightBackground,
  colorScheme: ColorScheme.light(
    primary: AppColors.primary,
    secondary: AppColors.secondary,
    background: AppColors.lightBackground,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.primary,
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w600,
      fontSize: 18,
    ),
    elevation: 0,
  ),
  cardTheme: CardTheme(
    color: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    elevation: 3,
    shadowColor: Colors.black12,
  ),
),

darkTheme: ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: AppColors.darkBackground,
  colorScheme: ColorScheme.dark(
    primary: AppColors.darkPrimary, // Muted blue in dark mode
    secondary: AppColors.secondary,
    background: AppColors.darkBackground,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.darkPrimary,
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w600,
      fontSize: 18,
    ),
    elevation: 0,
  ),
  cardTheme: CardTheme(
    color: AppColors.darkCard,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    elevation: 2,
    shadowColor: Colors.black54,
  ),
),

      initialRoute: Routes.login,
      routes: Routes.getRoutes(),
    );
  }
}

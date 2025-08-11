import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'routers.dart';
import 'constants/app_colors.dart';

class CredisenseApp extends StatelessWidget {
  const CredisenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Credisense',
      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.scaffold,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black87),
          titleTextStyle: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        textTheme: GoogleFonts.interTextTheme(),
      ),
      initialRoute: Routes.login,
      routes: Routes.getRoutes(),
    );
  }
}

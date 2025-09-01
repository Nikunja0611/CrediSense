import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'routers.dart';
import 'constants/app_colors.dart';
import 'providers/theme_provider.dart';
import 'providers/language_provider.dart';
import 'utils/font_helper.dart';

class CredisenseApp extends StatelessWidget {
  const CredisenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);

    return MaterialApp(
      title: 'Credisense',
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.themeMode, // ✅ Dynamic theme

      // Localization setup
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English
        Locale('hi'), // Hindi
        Locale('ta'), // Tamil
        Locale('te'), // Telugu
        Locale('kn'), // Kannada
        Locale('ml'), // Malayalam
        Locale('bn'), // Bengali
      ],
      locale: languageProvider.locale,

      // 🌞 Light theme
      theme: ThemeData(
        brightness: Brightness.light,
        fontFamily: FontHelper.getFontFamilyForLocale(languageProvider.locale),
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
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
      ),

      // 🌙 Dark theme
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: FontHelper.getFontFamilyForLocale(languageProvider.locale),
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
        cardTheme: CardThemeData(
          color: AppColors.darkCard,
          elevation: 2,
          shadowColor: Colors.black54,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
        ),
      ),

      initialRoute: Routes.login,
      routes: Routes.getRoutes(),
    );
  }
}
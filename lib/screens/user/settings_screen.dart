import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../providers/auth_provider.dart';
import '../../providers/language_provider.dart';
import '../../widgets/simple_app_bar.dart';
import '../../routers.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: SimpleAppBar(title: AppLocalizations.of(context)!.settingsTitle),
      body: ListView(
        children: [
          ListTile(
            title: Text('${AppLocalizations.of(context)!.accountTitle}: ${auth.user?.name ?? ''}'),
            subtitle: Text(auth.user?.email ?? ''),
          ),
          ListTile(
            title: Text(AppLocalizations.of(context)!.language),
            subtitle: Text(_getCurrentLanguageName(context)),
            onTap: () => _showLanguageDialog(context),
          ),
          SwitchListTile(
            title: Text(AppLocalizations.of(context)!.smsReading),
            value: true,
            onChanged: (_) {},
          ),
          SwitchListTile(
            title: Text(AppLocalizations.of(context)!.spendingAnalysis),
            value: true,
            onChanged: (_) {},
          ),
          SwitchListTile(
            title: Text(AppLocalizations.of(context)!.socialNetworkAnalysis),
            value: false,
            onChanged: (_) {},
          ),
          ListTile(
            title: Text(AppLocalizations.of(context)!.privacyDataControl),
            subtitle: Text(AppLocalizations.of(context)!.bankLevelSecurity),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: ElevatedButton(
              child: Text(AppLocalizations.of(context)!.logout),
              onPressed: () {
                auth.logout();
                Navigator.pushReplacementNamed(context, Routes.login);
              },
            ),
          ),
        ],
      ),
    );
  }

  String _getCurrentLanguageName(BuildContext context) {
    final locale = Provider.of<LanguageProvider>(context, listen: false).locale;
    switch (locale.languageCode) {
      case 'en': return 'English';
      case 'hi': return 'हिंदी';
      case 'ta': return 'தமிழ்';
      case 'te': return 'తెలుగు';
      case 'kn': return 'ಕನ್ನಡ';
      case 'ml': return 'മലയാളം';
      case 'bn': return 'বাংলা';
      default: return 'English';
    }
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.selectLanguage),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLanguageOption(context, 'English', 'en'),
            _buildLanguageOption(context, 'हिंदी', 'hi'),
            _buildLanguageOption(context, 'தமிழ்', 'ta'),
            _buildLanguageOption(context, 'తెలుగు', 'te'),
            _buildLanguageOption(context, 'ಕನ್ನಡ', 'kn'),
            _buildLanguageOption(context, 'മലയാളം', 'ml'),
            _buildLanguageOption(context, 'বাংলা', 'bn'),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(BuildContext context, String name, String code) {
    return ListTile(
      title: Text(name),
      onTap: () {
        Provider.of<LanguageProvider>(context, listen: false)
            .setLocale(Locale(code));
        Navigator.pop(context);
      },
    );
  }
}

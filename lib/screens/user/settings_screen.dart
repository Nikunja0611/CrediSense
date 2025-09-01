import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../providers/auth_provider.dart';
import '../../providers/finance_provider.dart';
import '../../providers/language_provider.dart';
import '../../widgets/simple_app_bar.dart';
import '../../routers.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool smsReadingEnabled = false;
  bool spendingAnalysisEnabled = true;
  bool socialNetworkAnalysisEnabled = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkSMSPermission();
    });
  }

  Future<void> _checkSMSPermission() async {
    final financeProvider = Provider.of<FinanceProvider>(context, listen: false);
    await financeProvider.checkSMSPermission();
    setState(() {
      smsReadingEnabled = financeProvider.hasSMSPermission;
    });
  }

  Future<void> _toggleSMSReading(bool value) async {
    final financeProvider = Provider.of<FinanceProvider>(context, listen: false);
    
    if (value) {
      // Request SMS permission
      await financeProvider.requestSMSPermission();
      setState(() {
        smsReadingEnabled = financeProvider.hasSMSPermission;
      });
      
      if (financeProvider.hasSMSPermission) {
        // Process SMS messages
        await financeProvider.processSMSMessages();
      }
    } else {
      setState(() {
        smsReadingEnabled = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final financeProvider = Provider.of<FinanceProvider>(context);
    
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
            subtitle: Text(smsReadingEnabled ? 'SMS permission granted' : 'SMS permission required'),
            value: smsReadingEnabled,
            onChanged: _toggleSMSReading,
          ),
          // SMS Live Monitoring Toggle
          Consumer<FinanceProvider>(
            builder: (context, financeProvider, child) {
              return SwitchListTile(
                title: const Text('SMS Live Monitoring'),
                subtitle: Text(
                  financeProvider.isMonitoringSMS 
                      ? 'Real-time SMS monitoring is active' 
                      : 'Real-time SMS monitoring is disabled'
                ),
                value: financeProvider.isMonitoringSMS,
                onChanged: (value) {
                  if (value) {
                    financeProvider.startRealTimeMonitoring();
                  } else {
                    financeProvider.stopRealTimeMonitoring();
                  }
                },
              );
            },
          ),

          if (financeProvider.isProcessingSMS)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 8),
                  Text('Processing SMS messages...', style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
          if (financeProvider.aggregates != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                'Processed ${financeProvider.smsTransactions.length} SMS transactions',
                style: TextStyle(fontSize: 12, color: Colors.green),
              ),
            ),
          SwitchListTile(
            title: Text(AppLocalizations.of(context)!.spendingAnalysis),
            value: spendingAnalysisEnabled,
            onChanged: (value) {
              setState(() {
                spendingAnalysisEnabled = value;
              });
            },
          ),
          SwitchListTile(
            title: Text(AppLocalizations.of(context)!.socialNetworkAnalysis),
            value: socialNetworkAnalysisEnabled,
            onChanged: (value) {
              setState(() {
                socialNetworkAnalysisEnabled = value;
              });
            },
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

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/simple_app_bar.dart';
import '../../routers.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: const SimpleAppBar(title: 'Settings & Privacy'),
      body: ListView(
        children: [
          ListTile(
            title: Text('Account: ${auth.user?.name ?? ''}'),
            subtitle: Text(auth.user?.email ?? ''),
          ),
          SwitchListTile(
            title: const Text('SMS Reading (Auto-tracking)'),
            value: true,
            onChanged: (_) {},
          ),
          SwitchListTile(
            title: const Text('Spending Analysis'),
            value: true,
            onChanged: (_) {},
          ),
          SwitchListTile(
            title: const Text('Social Network Analysis'),
            value: false,
            onChanged: (_) {},
          ),
          ListTile(
            title: const Text('Privacy & Data Control'),
            subtitle: const Text('We use bank-level security to protect data'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: ElevatedButton(
              child: const Text('Logout'),
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
}
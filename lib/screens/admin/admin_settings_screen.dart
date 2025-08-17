import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class AdminSettingsScreen extends StatelessWidget {
  const AdminSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings"), backgroundColor: AppColors.primary),
      body: ListView(
        children: [
          ListTile(leading: const Icon(Icons.person), title: const Text("Profile"), onTap: () {}),
          ListTile(leading: const Icon(Icons.brightness_6), title: const Text("Theme"), onTap: () {}),
          ListTile(leading: const Icon(Icons.logout), title: const Text("Logout"), onTap: () {}),
        ],
      ),
    );
  }
}

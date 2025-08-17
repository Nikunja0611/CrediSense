import 'package:flutter/material.dart';
import 'raise_ticket_page.dart'; // <-- Import your ticket form page

class AdminSettings extends StatelessWidget {
  const AdminSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Settings'),
        backgroundColor: Colors.blue[900],
      ),
      body: ListView(
        children: [
          _buildSettingsTile(
            icon: Icons.support_agent,
            title: 'Raise a Ticket',
            subtitle: 'Report an issue or request support',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RaiseTicketPage()),
              );
            },
          ),
          _buildSettingsTile(
            icon: Icons.security,
            title: 'Change Password',
            subtitle: 'Update your account password',
            onTap: () {},
          ),
          _buildSettingsTile(
            icon: Icons.notifications,
            title: 'Notifications',
            subtitle: 'Manage alert and notification preferences',
            onTap: () {},
          ),
          _buildSettingsTile(
            icon: Icons.people,
            title: 'Manage Users',
            subtitle: 'Add, edit, or remove users',
            onTap: () {},
          ),
          _buildSettingsTile(
            icon: Icons.settings_applications,
            title: 'System Preferences',
            subtitle: 'Adjust platform-wide configurations',
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout'),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue[900]),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}

import 'package:flutter/material.dart';
import 'raise_ticket_page.dart'; // <-- Import your ticket form page
import 'package:credisense/screens/auth/login_screen.dart'; // <-- Add this line

class AdminSettings extends StatelessWidget {
  const AdminSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Admin Settings',
          style: Theme.of(context).appBarTheme.titleTextStyle ?? 
                 TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back, 
            color: Theme.of(context).appBarTheme.iconTheme?.color ?? Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: ListView(
        children: [
          _buildSettingsTile(
            context: context,
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
            context: context,
            icon: Icons.security,
            title: 'Change Password',
            subtitle: 'Update your account password',
            onTap: () {
              // TODO: Implement change password functionality
              _showComingSoonDialog(context, 'Change Password');
            },
          ),
          _buildSettingsTile(
            context: context,
            icon: Icons.notifications,
            title: 'Notifications',
            subtitle: 'Manage alert and notification preferences',
            onTap: () {
              // TODO: Implement notifications settings
              _showComingSoonDialog(context, 'Notifications');
            },
          ),
          _buildSettingsTile(
            context: context,
            icon: Icons.people,
            title: 'Manage Users',
            subtitle: 'Add, edit, or remove users',
            onTap: () {
              // TODO: Implement user management
              _showComingSoonDialog(context, 'Manage Users');
            },
          ),
          _buildSettingsTile(
            context: context,
            icon: Icons.settings_applications,
            title: 'System Preferences',
            subtitle: 'Adjust platform-wide configurations',
            onTap: () {
              // TODO: Implement system preferences
              _showComingSoonDialog(context, 'System Preferences');
            },
          ),
          const Divider(),
          
          // Logout with confirmation dialog
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red.withOpacity(0.3)),
            ),
            child: ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text(
                'Logout',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: const Text('Sign out of your account'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.red),
              onTap: () => _showLogoutDialog(context),
            ),
          ),
          
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSettingsTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(
          icon, 
          color: Theme.of(context).colorScheme.primary,
          size: 24,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.titleMedium?.color,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios, 
          size: 16,
          color: Theme.of(context).textTheme.bodySmall?.color,
        ),
        onTap: onTap,
      ),
    );
  }

  // Logout confirmation dialog
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).cardColor,
          title: Text(
            'Confirm Logout',
            style: TextStyle(
              color: Theme.of(context).textTheme.titleLarge?.color,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Are you sure you want to logout? You will be redirected to the login screen.',
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                // Close the dialog first
                Navigator.of(context).pop();
                
                // Navigate to login screen and clear the navigation stack
                //Navigator.of(context).pushNamedAndRemoveUntil(
                //  'lib/screens/auth/login_screen.dart', // This should match your login route
                //  (Route<dynamic> route) => false, // Remove all previous routes
                //);
                
                // Alternative method if you're not using named routes:
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                  (Route<dynamic> route) => false,
                 );
              },
              child: const Text(
                'Logout',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  // Helper method for coming soon features
  void _showComingSoonDialog(BuildContext context, String feature) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).cardColor,
          title: Text(
            'Coming Soon',
            style: TextStyle(
              color: Theme.of(context).textTheme.titleLarge?.color,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            '$feature feature will be available in the next update.',
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'OK',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
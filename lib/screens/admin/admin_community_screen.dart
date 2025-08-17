import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class AdminCommunityScreen extends StatelessWidget {
  const AdminCommunityScreen({super.key});

  Widget _postTile(String user, String message, String date) {
    return ListTile(
      leading: CircleAvatar(child: Text(user[0])),
      title: Text(user, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(message),
      trailing: Text(date, style: const TextStyle(fontSize: 10, color: Colors.grey)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Community"), backgroundColor: AppColors.primary),
      body: ListView(
        children: [
          _postTile("Ravi", "How can I improve my credit score?", "12 Aug"),
          _postTile("Anita", "Best loan options for small business?", "11 Aug"),
        ],
      ),
    );
  }
}

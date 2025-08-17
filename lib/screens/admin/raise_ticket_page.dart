import 'package:flutter/material.dart';

class RaiseTicketPage extends StatelessWidget {
  const RaiseTicketPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Raise a Ticket'),
        backgroundColor: Colors.blue[900],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              "Need help? Tell us your issue and we'll get back to you within 24 hours.",
              style: TextStyle(fontStyle: FontStyle.italic, color: Colors.purple),
            ),
            const SizedBox(height: 20),

            // Issue Type
            const Text('Issue type', style: TextStyle(fontWeight: FontWeight.bold)),
            Column(
              children: [
                RadioListTile(value: 'Credit Score Issues', groupValue: null, onChanged: (_) {}, title: const Text('Credit Score Issues')),
                RadioListTile(value: 'Loan/EMI Queries', groupValue: null, onChanged: (_) {}, title: const Text('Loan/EMI Queries')),
                RadioListTile(value: 'Transaction Problems', groupValue: null, onChanged: (_) {}, title: const Text('Transaction Problems')),
                RadioListTile(value: 'Account/Login Issues', groupValue: null, onChanged: (_) {}, title: const Text('Account/Login Issues')),
                RadioListTile(value: 'Others', groupValue: null, onChanged: (_) {}, title: const Text('Others')),
              ],
            ),

            const SizedBox(height: 16),

            // Subject
            TextField(
              decoration: InputDecoration(
                labelText: 'Subject',
                hintText: 'Example: Incorrect credit score updates',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 16),

            // Description
            TextField(
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Description',
                hintText: 'Describe your issue in detail...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 16),

            // Contact Info
            TextField(
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                labelText: 'Phone number',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 16),

            // Priority
            const Text('Priority', style: TextStyle(fontWeight: FontWeight.bold)),
            RadioListTile(value: 'Low', groupValue: null, onChanged: (_) {}, title: const Text('Low (General Inquiry)')),
            RadioListTile(value: 'Medium', groupValue: null, onChanged: (_) {}, title: const Text('Medium (Needs attention soon)')),
            RadioListTile(value: 'High', groupValue: null, onChanged: (_) {}, title: const Text('High (Urgent issue)')),

            const SizedBox(height: 16),

            // Submit Button
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[900],
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text('Submit', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}

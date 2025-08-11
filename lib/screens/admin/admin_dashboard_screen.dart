import 'package:flutter/material.dart';
import '../../widgets/simple_app_bar.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Minimal admin UI matching Admin_finshield_prototype.pdf
    return Scaffold(
      appBar: const SimpleAppBar(title: 'Admin Dashboard'),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          children: [
            Card(
              child: ListTile(
                title: const Text('Active Loans'),
                subtitle: const Text('120 active'),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [Text('₹ 12,34,567'), Text('Change +4.2%')],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Card(
              child: ListTile(
                title: const Text('Delinquency Rate'),
                subtitle: const Text('5.2%'),
                trailing: const Icon(Icons.trending_down, color: Colors.green),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                itemCount: 8,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (ctx, i) => Card(
                  child: ListTile(
                    leading: CircleAvatar(child: Text('U${i+1}')),
                    title: Text('Loan #L00${100 + i}'),
                    subtitle: const Text('Amount: ₹10,000'),
                    trailing: ElevatedButton(onPressed: () {}, child: const Text('View')),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

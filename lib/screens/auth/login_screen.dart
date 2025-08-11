import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../routers.dart';
import '../../widgets/simple_app_bar.dart';
import '../../constants/app_colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _form = GlobalKey<FormState>();
  String email = '';
  String password = '';
  bool loading = false;

  void _submit() async {
    if (!_form.currentState!.validate()) return;
    _form.currentState!.save();
    setState(() => loading = true);
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final ok = await auth.login(email: email, password: password);
    setState(() => loading = false);
    if (ok) {
      if (auth.user?.role == 'admin') {
        Navigator.pushReplacementNamed(context, Routes.admin);
      } else {
        Navigator.pushReplacementNamed(context, Routes.dashboard);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Login failed')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SimpleAppBar(title: 'Sign in'),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Form(
          key: _form,
          child: Column(
            children: [
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                initialValue: 'sarah@example.com',
                keyboardType: TextInputType.emailAddress,
                onSaved: (v) => email = v!.trim(),
                validator: (v) => v != null && v.contains('@') ? null : 'Enter valid email',
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Password'),
                initialValue: 'password123',
                obscureText: true,
                onSaved: (v) => password = v!.trim(),
                validator: (v) => (v != null && v.length >= 4) ? null : 'Password too short',
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                onPressed: loading ? null : _submit,
                child: loading ? const CircularProgressIndicator() : const Text('Login'),
              ),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, Routes.signup),
                child: const Text('Create an account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

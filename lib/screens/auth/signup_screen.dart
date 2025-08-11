import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../routers.dart';
import '../../widgets/simple_app_bar.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _form = GlobalKey<FormState>();
  String name = '';
  String email = '';
  String password = '';
  bool loading = false;

  void _submit() async {
    if (!_form.currentState!.validate()) return;
    _form.currentState!.save();
    setState(() => loading = true);
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final ok = await auth.signup(name: name, email: email, password: password);
    setState(() => loading = false);
    if (ok) {
      Navigator.pushReplacementNamed(context, Routes.dashboard);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Signup failed')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SimpleAppBar(title: 'Sign up'),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Form(
          key: _form,
          child: Column(children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Full name'),
              onSaved: (v) => name = v!.trim(),
              validator: (v) => (v != null && v.isNotEmpty) ? null : 'Required',
            ),
            const SizedBox(height: 12),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
              onSaved: (v) => email = v!.trim(),
              validator: (v) => v != null && v.contains('@') ? null : 'Enter valid email',
            ),
            const SizedBox(height: 12),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
              onSaved: (v) => password = v!.trim(),
              validator: (v) => (v != null && v.length >= 4) ? null : 'Password too short',
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: loading ? null : _submit,
              child: loading ? const CircularProgressIndicator() : const Text('Create account'),
            ),
          ]),
        ),
      ),
    );
  }
}

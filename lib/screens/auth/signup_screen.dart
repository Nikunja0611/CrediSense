import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../routers.dart';

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
  String confirmPassword = '';
  bool loading = false;

  void _submit() async {
    if (!_form.currentState!.validate()) return;
    _form.currentState!.save();

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match")),
      );
      return;
    }

    setState(() => loading = true);
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final ok = await auth.signup(name: name, email: email, password: password);
    setState(() => loading = false);

    if (ok) {
      // 👇 redirect to Consent Form instead of Dashboard
      Navigator.pushReplacementNamed(context, Routes.consentForm);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Signup failed')));
    }
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required bool obscure,
    required FormFieldSetter<String> onSaved,
    required FormFieldValidator<String> validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Color(0xFF004B8D))),
        const SizedBox(height: 6),
        TextFormField(
          obscureText: obscure,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: const Color(0xFF004B8D).withOpacity(0.1),
            hintStyle: const TextStyle(color: Colors.black54),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          style: const TextStyle(color: Colors.black87, fontSize: 14),
          onSaved: onSaved,
          validator: validator,
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18.0),
        child: Form(
          key: _form,
          child: Column(
            children: [
              const SizedBox(height: 40),
              CircleAvatar(
                radius: 40,
                backgroundColor: const Color(0xFF004B8D).withOpacity(0.1),
                child: const Icon(Icons.person_add,
                    size: 50, color: Color(0xFF004B8D)),
              ),
              const SizedBox(height: 30),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildTextField(
                      label: "Full Name",
                      hint: "Enter your name",
                      obscure: false,
                      onSaved: (v) => name = v!.trim(),
                      validator: (v) =>
                          (v != null && v.isNotEmpty) ? null : 'Required',
                    ),
                    _buildTextField(
                      label: "Email",
                      hint: "Enter your email",
                      obscure: false,
                      onSaved: (v) => email = v!.trim(),
                      validator: (v) =>
                          v != null && v.contains('@') ? null : 'Enter valid email',
                    ),
                    _buildTextField(
                      label: "Password",
                      hint: "Enter your password",
                      obscure: true,
                      onSaved: (v) => password = v!.trim(),
                      validator: (v) =>
                          (v != null && v.length >= 4) ? null : 'Too short',
                    ),
                    _buildTextField(
                      label: "Confirm Password",
                      hint: "Re-enter your password",
                      obscure: true,
                      onSaved: (v) => confirmPassword = v!.trim(),
                      validator: (v) =>
                          (v != null && v.length >= 4) ? null : 'Too short',
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: loading ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF004B8D),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: loading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text("Create Account",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "Already have an account? Login",
                  style: TextStyle(
                      color: Color(0xFF004B8D), fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

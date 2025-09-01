import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../providers/auth_provider.dart';
import '../../routers.dart';
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

    final role = await auth.login(email: email, password: password);
    setState(() => loading = false);

    if (role == "admin") {
      Navigator.pushReplacementNamed(context, Routes.admin);
    } else if (role == "user") {
      Navigator.pushReplacementNamed(context, Routes.dashboard);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.loginFailed)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? AppColors.darkBackground
          : Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Profile icon
              CircleAvatar(
                radius: 40,
                backgroundColor: AppColors.primary.withOpacity(0.4),
                child: const Icon(Icons.person,
                    size: 50, color: AppColors.primary),
              ),
              const SizedBox(height: 30),

              // Card container
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      offset: const Offset(3, 3),
                      blurRadius: 6,
                    ),
                  ],
                  border: Border.all(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey.shade800
                          : Colors.black54,
                      width: 0.6),
                ),
                child: Form(
                  key: _form,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.usernameLabel,
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColors.primary.withOpacity(0.3),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        onSaved: (v) => email = v!.trim(),
                        validator: (v) => v != null && v.contains('@')
                            ? null
                            : AppLocalizations.of(context)!.enterValidEmail,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        AppLocalizations.of(context)!.passwordLabel,
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColors.primary.withOpacity(0.3),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onSaved: (v) => password = v!.trim(),
                        validator: (v) => (v != null && v.length >= 4)
                            ? null
                            : AppLocalizations.of(context)!.passwordTooShort,
                      ),
                      const SizedBox(height: 25),
                      SizedBox(
                        width: double.infinity,
                        height: 45,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            foregroundColor: Colors.white,
                            textStyle: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          onPressed: loading ? null : _submit,
                          child: loading
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : Text(AppLocalizations.of(context)!
                                  .loginButton), // Text will now show clearly
                        ),
                      ),
                      const SizedBox(height: 12),
                      Center(
                        child: TextButton(
                          onPressed: () =>
                              Navigator.pushNamed(context, Routes.signup),
                          child: Text(
                            AppLocalizations.of(context)!.notRegistered,
                            style: TextStyle(color: AppColors.primary),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

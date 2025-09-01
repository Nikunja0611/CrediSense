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

  // Controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  String name = '';
  String password = '';
  String confirmPassword = '';
  String dob = '';
  String gender = '';
  String address = '';
  String occupation = '';
  String employer = '';
  String income = '';
  String empType = '';
  String phoneNumber = ''; //  NEW: phone number

  bool loading = false;
  bool otpSent = false;
  bool otpLoading = false;

  // -------------------------
  // SEND OTP
  // -------------------------
  Future<void> _sendOtp() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final inputEmail = emailController.text.trim();

    if (inputEmail.isEmpty || !inputEmail.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter a valid email")),
      );
      return;
    }

    setState(() => otpLoading = true);
    final ok = await auth.sendEmailOtp(inputEmail); //  hits backend
    setState(() => otpLoading = false);

    if (ok) {
      setState(() => otpSent = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("OTP sent to email")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to send OTP")),
      );
    }
  }

  // -------------------------
  // SUBMIT SIGNUP
  // -------------------------
  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    _form.currentState!.save();

    final email = emailController.text.trim();
    final otp = otpController.text.trim();

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match")),
      );
      return;
    }

    final auth = Provider.of<AuthProvider>(context, listen: false);

    //  Verify OTP with backend before signup
    String result = await auth.verifyEmailOtp(email, otp);

    if (!otpSent || result != "success") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid or missing OTP")),
      );
      return;
    }

    setState(() => loading = true);

    final ok = await auth.signup(
      name: name,
      email: email,
      password: password,
      phoneNumber: phoneNumber, // ✅ pass real phone number
      dob: dob,
      gender: gender,
      address: address,
      occupation: occupation,
      employer: employer,
      incomeRange: income,
      employmentType: empType,
    );

    setState(() => loading = false);

    if (ok) {
      Navigator.pushReplacementNamed(context, Routes.dashboard);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Signup failed')));
    }
  }

  // -------------------------
  // TEXT FIELD BUILDER
  // -------------------------
  Widget _buildTextField({
    required String label,
    required String hint,
    bool obscure = false,
    FormFieldSetter<String>? onSaved,
    FormFieldValidator<String>? validator,
    TextInputType type = TextInputType.text,
    TextEditingController? controller,
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
          controller: controller,
          obscureText: obscure,
          keyboardType: type,
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

  // -------------------------
  // UI
  // -------------------------
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

              // Signup Card
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
                      onSaved: (v) => name = v!.trim(),
                      validator: (v) =>
                          (v != null && v.isNotEmpty) ? null : 'Required',
                    ),
                    _buildTextField(
                      label: "Email",
                      hint: "Enter your email",
                      type: TextInputType.emailAddress,
                      controller: emailController,
                      onSaved: (_) {},
                      validator: (v) => v != null && v.contains('@')
                          ? null
                          : 'Enter valid email',
                    ),
                    _buildTextField(
                      label: "Phone Number", // ✅ NEW FIELD
                      hint: "Enter your phone number",
                      type: TextInputType.phone,
                      onSaved: (v) => phoneNumber = v!.trim(),
                      validator: (v) =>
                          (v != null && v.length >= 10) ? null : 'Enter valid phone',
                    ),
                    _buildTextField(
                      label: "Date of Birth",
                      hint: "DD/MM/YYYY",
                      type: TextInputType.datetime,
                      onSaved: (v) => dob = v!.trim(),
                      validator: (v) =>
                          (v != null && v.isNotEmpty) ? null : 'Required',
                    ),
                    _buildTextField(
                      label: "Gender",
                      hint: "Male/Female/Other",
                      onSaved: (v) => gender = v!.trim(),
                      validator: (v) =>
                          (v != null && v.isNotEmpty) ? null : 'Required',
                    ),
                    _buildTextField(
                      label: "Address",
                      hint: "Street, City, State, Pincode, Country",
                      onSaved: (v) => address = v!.trim(),
                      validator: (v) =>
                          (v != null && v.isNotEmpty) ? null : 'Required',
                    ),
                    _buildTextField(
                      label: "Occupation",
                      hint: "Student, Engineer, Doctor...",
                      onSaved: (v) => occupation = v!.trim(),
                      validator: (v) =>
                          (v != null && v.isNotEmpty) ? null : 'Required',
                    ),
                    _buildTextField(
                      label: "Employer Name",
                      hint: "Company / Institute",
                      onSaved: (v) => employer = v!.trim(),
                    ),
                    _buildTextField(
                      label: "Monthly Income Range",
                      hint: "10k-20k / 50k-1L / etc.",
                      onSaved: (v) => income = v!.trim(),
                    ),
                    _buildTextField(
                      label: "Employment Type",
                      hint: "Salaried / Self-employed / Student",
                      onSaved: (v) => empType = v!.trim(),
                    ),
                    _buildTextField(
                      label: "Password",
                      hint: "Enter your password",
                      obscure: true,
                      onSaved: (v) => password = v!.trim(),
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return 'Password is required';
                        }
                        final auth =
                            Provider.of<AuthProvider>(context, listen: false);
                        if (!auth.isStrongPassword(v)) {
                          return 'Password must be at least 8 chars,\ninclude upper, lower, number & symbol';
                        }
                        return null;
                      },
                    ),
                    _buildTextField(
                      label: "Confirm Password",
                      hint: "Re-enter your password",
                      obscure: true,
                      onSaved: (v) => confirmPassword = v!.trim(),
                      validator: (v) =>
                          (v != null && v.length >= 4) ? null : 'Too short',
                    ),

                    // -------------------------
                    // OTP section
                    // -------------------------
                    if (otpSent)
                      _buildTextField(
                        label: "Enter OTP",
                        hint: "Enter OTP received",
                        type: TextInputType.number,
                        controller: otpController,
                        validator: (v) => (v != null && v.length == 6)
                            ? null
                            : 'Enter 6-digit OTP',
                      ),

                    if (!otpSent)
                      ElevatedButton(
                        onPressed: otpLoading ? null : _sendOtp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF004B8D),
                        ),
                        child: otpLoading
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.white),
                              )
                            : const Text("Send OTP",
                                style: TextStyle(color: Colors.white)),
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
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : const Text(
                                "Create Account",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
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
                    color: Color(0xFF004B8D),
                    fontWeight: FontWeight.w500,
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

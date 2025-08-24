

import 'package:flutter/material.dart';

class LoanApplyForm extends StatefulWidget {
  final String loanTitle;
  const LoanApplyForm({super.key, required this.loanTitle});

  @override
  State<LoanApplyForm> createState() => _LoanApplyFormState();
}

class _LoanApplyFormState extends State<LoanApplyForm> {
  final _formKey = GlobalKey<FormState>();
  String name = "", email = "", amount = "", income = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Apply for ${widget.loanTitle}"),
        backgroundColor: Colors.indigo,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: "Full Name"),
                validator: (val) =>
                    val == null || val.isEmpty ? "Enter your name" : null,
                onSaved: (val) => name = val!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Email"),
                keyboardType: TextInputType.emailAddress,
                validator: (val) =>
                    val == null || !val.contains("@") ? "Enter valid email" : null,
                onSaved: (val) => email = val!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Loan Amount"),
                keyboardType: TextInputType.number,
                validator: (val) =>
                    val == null || val.isEmpty ? "Enter loan amount" : null,
                onSaved: (val) => amount = val!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Monthly Income"),
                keyboardType: TextInputType.number,
                validator: (val) =>
                    val == null || val.isEmpty ? "Enter income" : null,
                onSaved: (val) => income = val!,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              "Application submitted for ${widget.loanTitle}!")),
                    );
                    Navigator.pop(context);
                  }
                },
                child: const Text(
                  "Submit Application",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
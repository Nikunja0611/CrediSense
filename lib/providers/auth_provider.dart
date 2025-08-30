// auth_provider.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

import '../models/user.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserModel? _user;
  UserModel? get user => _user;
  bool get isAuthenticated => _user != null;

  // Hardcoded admin credentials (⚠️ keep secure)
  static const String adminEmail = "crediadmin123@gmail.com";
  static const String adminPassword = "Admin#232345";

  // Your backend server base URL (⚠️ replace with your laptop IP or hosted URL)
  static const String backendUrl = "http://192.168.1.109:3000";
 // Example

  // ---------------------------
  // LOGIN
  // ---------------------------
  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      // 🔹 Special case for Admin
      if (email == adminEmail && password == adminPassword) {
        _user = UserModel(
          id: "admin",
          name: "App Admin",
          email: adminEmail,
          role: "admin",
          phoneNumber: "",
          dob: "",
          gender: "",
          address: "",
          occupation: "",
          employer: "",
          incomeRange: "",
          employmentType: "",
        );
        notifyListeners();
        return "admin";
      }

      // 🔹 Normal user login with Firebase
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final doc =
          await _firestore.collection("users").doc(result.user!.uid).get();

      if (!doc.exists) return null;

      _user = _mapFirebaseUser(result.user!, doc.data()!);
      notifyListeners();
      return _user!.role;
    } catch (e) {
      debugPrint("Login error: $e");
      return null;
    }
  }

  // ---------------------------
  // SIGNUP
  // ---------------------------
  Future<bool> signup({
    required String name,
    required String email,
    required String password,
    required String phoneNumber,
    required String dob,
    required String gender,
    required String address,
    required String occupation,
    required String employer,
    required String incomeRange,
    required String employmentType,
  }) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final userData = {
        "name": name,
        "email": email,
        "role": "user",
        "phoneNumber": phoneNumber,
        "dob": dob,
        "gender": gender,
        "address": address,
        "occupation": occupation,
        "employer": employer,
        "incomeRange": incomeRange,
        "employmentType": employmentType,
      };

      await _firestore.collection("users").doc(result.user!.uid).set(userData);

      _user = UserModel(
        id: result.user!.uid,
        name: name,
        email: email,
        role: "user",
        phoneNumber: phoneNumber,
        dob: dob,
        gender: gender,
        address: address,
        occupation: occupation,
        employer: employer,
        incomeRange: incomeRange,
        employmentType: employmentType,
      );

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint("Signup error: $e");
      return false;
    }
  }

  // ---------------------------
  // EMAIL OTP (via Backend)
  // ---------------------------

  /// Call backend to send OTP
  Future<bool> sendEmailOtp(String email) async {
    try {
      final response = await http.post(
        Uri.parse("$backendUrl/send-otp"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email}),
      );

      if (response.statusCode == 200) {
        debugPrint("OTP sent successfully");
        return true;
      } else {
        debugPrint("Failed to send OTP: ${response.body}");
        return false;
      }
    } catch (e) {
      debugPrint("sendEmailOtp error: $e");
      return false;
    }
  }

  /// Call backend to verify OTP
  Future<String> verifyEmailOtp(String email, String otp) async {
    try {
      final response = await http.post(
        Uri.parse("$backendUrl/verify-otp"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "otp": otp}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["status"]; // "success", "invalid", "expired"
      } else {
        return "invalid";
      }
    } catch (e) {
      debugPrint("verifyEmailOtp error: $e");
      return "invalid";
    }
  }

  // ---------------------------
  // LOGOUT
  // ---------------------------
  Future<void> logout() async {
    await _auth.signOut();
    _user = null;
    notifyListeners();
  }
  // ---------------------------
  // Validators
  // ---------------------------
  bool isStrongPassword(String password) {
    final regex = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
    );
    return regex.hasMatch(password);
  }


  // ---------------------------
  // Helper: Map Firebase User
  // ---------------------------
  UserModel _mapFirebaseUser(User user, Map<String, dynamic> data) {
    return UserModel(
      id: user.uid,
      name: data["name"] ?? user.displayName ?? "User",
      email: user.email ?? "",
      role: data["role"] ?? "user",
      phoneNumber: data["phoneNumber"] ?? "",
      dob: data["dob"] ?? "",
      gender: data["gender"] ?? "",
      address: data["address"] ?? "",
      occupation: data["occupation"] ?? "",
      employer: data["employer"] ?? "",
      incomeRange: data["incomeRange"] ?? "",
      employmentType: data["employmentType"] ?? "",
    );
  }

}

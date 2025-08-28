import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserModel? _user;
  UserModel? get user => _user;
  bool get isAuthenticated => _user != null;

  // Hardcoded admin credentials
static const String adminEmail = "crediadmin123@gmail.com";
static const String adminPassword = "Admin#232345";

  bool isStrongPassword(String password) {
    final regex = RegExp(
        r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');
    return regex.hasMatch(password);
  }
  // Convert Firebase User + Firestore data to UserModel
  UserModel _mapFirebaseUser(User user, Map<String, dynamic> data) {
    return UserModel(
      id: user.uid,
      name: data["name"] ?? user.displayName ?? "User",
      email: user.email ?? "",
      role: data["role"] ?? "user",
    );
  }

  // LOGIN
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
        );
        notifyListeners();
        return "admin"; // return role
      }

      // 🔹 Normal user login
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final doc =
          await _firestore.collection("users").doc(result.user!.uid).get();

      if (!doc.exists) {
        return null; // user not found in DB
      }

      _user = _mapFirebaseUser(result.user!, doc.data()!);
      notifyListeners();
      return _user!.role;
    } catch (e) {
      debugPrint("Login error: $e");
      return null;
    }
  }

  // SIGNUP (only for normal users)
  Future<bool> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // save in Firestore with role = user
      await _firestore.collection("users").doc(result.user!.uid).set({
        "name": name,
        "email": email,
        "role": "user", // default role
      });

      _user = UserModel(
        id: result.user!.uid,
        name: name,
        email: email,
        role: "user",
      );
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint("Signup error: $e");
      return false;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    _user = null;
    notifyListeners();
  }
}

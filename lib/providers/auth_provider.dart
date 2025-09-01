import 'package:flutter/material.dart';
import '../models/user.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _user;

  UserModel? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get isFirstLogin => _user?.isFirstLogin ?? false;

  // ---- LOGIN ----
  Future<bool> login({required String email, required String password}) async {
    await Future.delayed(const Duration(milliseconds: 450));

    // ✅ Mock logic: simulate returning vs. new users
    bool isReturningUser = email.contains('returning');

    _user = UserModel(
      id: 'u1',
      name: email.contains('admin') ? 'Admin' : 'Sarah',
      email: email,
      role: email.contains('admin') ? 'admin' : 'user',
      isFirstLogin: !isReturningUser, // 👈 New users → true
    );

    notifyListeners();
    return true;
  }

  // ---- SIGNUP ----
  Future<bool> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 450));

    _user = UserModel(
      id: 'u2',
      name: name,
      email: email,
      role: 'user',
      isFirstLogin: true, // 👈 Always first login for signup
    );

    notifyListeners();
    return true;
  }

  // ---- COMPLETE ONBOARDING ----
  void completeOnboarding() {
    if (_user != null) {
      _user = _user!.copyWith(isFirstLogin: false); // ✅ after manual input
      notifyListeners();
    }
  }

  // ---- LOGOUT ----
  Future<void> logout() async {
    _user = null;
    notifyListeners();
  }
}

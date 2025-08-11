import 'package:flutter/material.dart';
import '../models/user.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _user;

  UserModel? get user => _user;
  bool get isAuthenticated => _user != null;

  // mock login
  Future<bool> login({required String email, required String password}) async {
    await Future.delayed(const Duration(milliseconds: 450));
    // super simple demo: if email contains admin -> admin
    _user = UserModel(
      id: 'u1',
      name: email.contains('admin') ? 'Admin' : 'Sarah',
      email: email,
      role: email.contains('admin') ? 'admin' : 'user',
    );
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    _user = null;
    notifyListeners();
  }

  Future<bool> signup({required String name, required String email, required String password}) async {
    await Future.delayed(const Duration(milliseconds: 450));
    _user = UserModel(id: 'u2', name: name, email: email, role: 'user');
    notifyListeners();
    return true;
  }
}

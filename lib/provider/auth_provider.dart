import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  final ApiService api;
  User? user;
  bool loading = false;

  AuthProvider(this.api);

  Future<void> login(String phone, String password) async {
    loading = true; notifyListeners();
    final res = await api.login(phone, password);
    final token = res['access_token'];
    await api.saveToken(token);
    final u = res['user'];
    user = User.fromJson(u);
    loading = false; notifyListeners();
  }

  Future<void> register(String name, String phone, String password, {String role = 'mother'}) async {
    loading = true; notifyListeners();
    await api.register(name, phone, password, role: role);
    loading = false; notifyListeners();
  }

  Future<void> logout() async {
    await api.clearToken();
    user = null;
    notifyListeners();
  }

  bool get isLoggedIn => user != null;
}

import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  final ApiService api;
  User? user;
  bool loading = false;

  AuthProvider(this.api);

  Future<void> login(String idNumber, String pin, String idType) async {
    loading = true;
    notifyListeners();
    try {
      final res = await api.login(idNumber, pin, idType, context: null);
      if (res['message'] == 'OTP sent to your phone') {
        // OTP request successful, wait for OTP verification
        return;
      } else {
        throw Exception('Unexpected login response: ${res.toString()}');
      }
    } catch (e) {
      rethrow;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> verifyOtp(String idNumber, String otp, {BuildContext? context}) async {
    loading = true;
    notifyListeners();
    try {
      final res = await api.verifyOtp(idNumber, otp, context: context);
      if (res.containsKey('access_token') && res.containsKey('user')) {
        final token = res['access_token'] as String;
        await api.saveToken(token);
        final userData = res['user'] as Map<String, dynamic>;
        user = User.fromJson(userData);
        print('User logged in: ${user?.toJson()}');
      } else {
        throw Exception('Invalid OTP verification response: ${res.toString()}');
      }
    } catch (e) {
      print('Error in verifyOtp: $e');
      rethrow;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> register(
    String name,
    String phone,
    String pin, {
    String role = 'mother',
    required String idType,
    required String idNumber,
    BuildContext? context,
  }) async {
    loading = true;
    notifyListeners();
    try {
      await api.register(
        name,
        phone,
        pin,
        idType: idType,
        idNumber: idNumber,
        role: role,
        context: context,
      );
    } catch (e) {
      print('Error in register: $e');
      rethrow;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    try {
      await api.clearToken();
      user = null;
      print('User logged out');
    } finally {
      notifyListeners();
    }
  }

  bool get isLoggedIn => user != null;
}
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/app_constants.dart';

class ApiService {
  final _storage = const FlutterSecureStorage();

  Future<String?> get token async => await _storage.read(key: 'access_token');

  Map<String, String> _headers(String? token) => {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      };

  // Auth
  Future<Map<String, dynamic>> login(String phone, String password) async {
    final url = Uri.parse('${AppConstants.API_PREFIX}/auth/login');
    final res = await http.post(url,
        headers: _headers(null),
        body: jsonEncode({"phone": phone, "password": password}));
    return _handleResponse(res);
  }

  Future<Map<String, dynamic>> register(String name, String phone, String password, {String role = 'mother'}) async {
    final url = Uri.parse('${AppConstants.API_PREFIX}/auth/register');
    final res = await http.post(url,
        headers: _headers(null),
        body: jsonEncode({"name": name, "phone": phone, "password": password, "role": role}));
    return _handleResponse(res);
  }

  // Mothers
  Future<Map<String, dynamic>> registerMother(Map<String, dynamic> body) async {
    final url = Uri.parse('${AppConstants.API_PREFIX}/mothers/');
    final t = await token;
    final res = await http.post(url, headers: _headers(t), body: jsonEncode(body));
    return _handleResponse(res);
  }

  Future<List<dynamic>> getMothers() async {
    final url = Uri.parse('${AppConstants.API_PREFIX}/mothers/');
    final t = await token;
    final res = await http.get(url, headers: _headers(t));
    final parsed = _handleResponse(res);
    return parsed is List ? parsed : (parsed['data'] ?? []);
  }

  // Appointments
  Future<List<dynamic>> getUpcomingAppointments() async {
    final url = Uri.parse('${AppConstants.API_PREFIX}/appointments/upcoming');
    final t = await token;
    final res = await http.get(url, headers: _headers(t));
    final parsed = _handleResponse(res);
    return parsed is List ? parsed : (parsed['data'] ?? []);
  }

  Future<Map<String, dynamic>> createAppointment(Map<String, dynamic> body) async {
    final url = Uri.parse('${AppConstants.API_PREFIX}/appointments/create');
    final t = await token;
    final res = await http.post(url, headers: _headers(t), body: jsonEncode(body));
    return _handleResponse(res);
  }

  // Payments (backend initiates IntaSend checkout)
  Future<Map<String, dynamic>> initiatePayment(double amount, String phone) async {
    final url = Uri.parse('${AppConstants.API_PREFIX}/payments/checkout');
    final t = await token;
    final res = await http.post(url, headers: _headers(t), body: jsonEncode({"amount": amount, "phone": phone}));
    return _handleResponse(res);
  }

  // Token storage
  Future<void> saveToken(String token) => _storage.write(key: 'access_token', value: token);
  Future<void> clearToken() => _storage.delete(key: 'access_token');

  // Basic error handling
  dynamic _handleResponse(http.Response res) {
    if (res.statusCode >= 200 && res.statusCode < 300) {
      try {
        return jsonDecode(res.body);
      } catch (_) {
        return {"message": res.body};
      }
    } else {
      try {
        final body = jsonDecode(res.body);
        throw Exception(body['error'] ?? body['message'] ?? res.body);
      } catch (e) {
        throw Exception('HTTP ${res.statusCode}: ${res.body}');
      }
    }
  }
}

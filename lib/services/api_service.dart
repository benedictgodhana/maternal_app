import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/app_constants.dart';

class ApiService {
  final _storage = const FlutterSecureStorage();

  Future<String?> get token async {
    final t = await _storage.read(key: 'access_token');
    print('Retrieved token: $t');
    return t;
  }

  Map<String, String> _headers(String? token) {
    final headers = {
      "Content-Type": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };
    print('Headers: $headers');
    return headers;
  }

  // Auth
  Future<Map<String, dynamic>> login(String phone, String password) async {
    final url = Uri.parse('${AppConstants.API_PREFIX}/login');
    print('Login request to: $url with body: {"phone": "$phone", "password": "****"}');
    final res = await http.post(
      url,
      headers: _headers(null),
      body: jsonEncode({"phone": phone, "password": password}),
    );
    print('Login response: status=${res.statusCode}, body=${res.body}');
    return _handleResponse(res);
  }

  Future<Map<String, dynamic>> register(String name, String phone, String password, {String role = 'mother'}) async {
    final url = Uri.parse('${AppConstants.API_PREFIX}/register');
    print('Register request to: $url with body: {"name": "$name", "phone": "$phone", "password": "****", "role": "$role"}');
    final res = await http.post(
      url,
      headers: _headers(null),
      body: jsonEncode({"name": name, "phone": phone, "password": password, "role": role}),
    );
    print('Register response: status=${res.statusCode}, body=${res.body}');
    return _handleResponse(res);
  }

  // Mothers
  Future<Map<String, dynamic>> registerMother(Map<String, dynamic> body) async {
    final url = Uri.parse('${AppConstants.API_PREFIX}/mothers/');
    final t = await token;
    print('Register mother request to: $url with body: $body');
    final res = await http.post(url, headers: _headers(t), body: jsonEncode(body));
    print('Register mother response: status=${res.statusCode}, body=${res.body}');
    return _handleResponse(res);
  }

  Future<List<dynamic>> getMothers() async {
    final url = Uri.parse('${AppConstants.API_PREFIX}/mothers/');
    final t = await token;
    print('Get mothers request to: $url');
    final res = await http.get(url, headers: _headers(t));
    print('Get mothers response: status=${res.statusCode}, body=${res.body}');
    final parsed = _handleResponse(res);
    return parsed is List ? parsed : (parsed['data'] ?? []);
  }

  // Appointments
  Future<List<dynamic>> getUpcomingAppointments() async {
    final url = Uri.parse('${AppConstants.API_PREFIX}/appointments/upcoming');
    final t = await token;
    print('Get upcoming appointments request to: $url');
    final res = await http.get(url, headers: _headers(t));
    print('Get upcoming appointments response: status=${res.statusCode}, body=${res.body}');
    final parsed = _handleResponse(res);
    return parsed is List ? parsed : (parsed['data'] ?? []);
  }

  Future<Map<String, dynamic>> createAppointment(Map<String, dynamic> body) async {
    final url = Uri.parse('${AppConstants.API_PREFIX}/appointments/create');
    final t = await token;
    print('Create appointment request to: $url with body: $body');
    final res = await http.post(url, headers: _headers(t), body: jsonEncode(body));
    print('Create appointment response: status=${res.statusCode}, body=${res.body}');
    return _handleResponse(res);
  }

  // Payments
  Future<Map<String, dynamic>> initiatePayment(double amount, String phone) async {
    final url = Uri.parse('${AppConstants.API_PREFIX}/payments/checkout');
    final t = await token;
    print('Initiate payment request to: $url with body: {"amount": $amount, "phone": "$phone"}');
    final res = await http.post(url, headers: _headers(t), body: jsonEncode({"amount": amount, "phone": phone}));
    print('Initiate payment response: status=${res.statusCode}, body=${res.body}');
    return _handleResponse(res);
  }

  // Token storage
  Future<void> saveToken(String token) async {
    print('Saving token: $token');
    await _storage.write(key: 'access_token', value: token);
  }

  Future<void> clearToken() async {
    print('Clearing token');
    await _storage.delete(key: 'access_token');
  }

  // Basic error handling
  dynamic _handleResponse(http.Response res) {
    print('Handling response: status=${res.statusCode}, body=${res.body}');
    if (res.statusCode >= 200 && res.statusCode < 300) {
      try {
        return jsonDecode(res.body);
      } catch (e) {
        print('Error decoding JSON: $e');
        return {"message": res.body};
      }
    } else {
      try {
        final body = jsonDecode(res.body);
        final error = body['error'] ?? body['message'] ?? res.body;
        print('Error response: $error');
        throw Exception(error);
      } catch (e) {
        print('Error parsing error response: $e');
        throw Exception('HTTP ${res.statusCode}: ${res.body}');
      }
    }
  }
}
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/app_constants.dart';

class ApiService with ChangeNotifier {
  final _storage = const FlutterSecureStorage();
  bool _loading = false;

  bool get loading => _loading;

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
  Future<Map<String, dynamic>> login(
    String idNumber,
    String pin,
    String idType, {
    BuildContext? context,
  }) async {
    _loading = true;
    notifyListeners();
    try {
      final url = Uri.parse('${AppConstants.API_PREFIX}/login');
      print(
        'Login request to: $url with body: {"id_number": "$idNumber", "pin": "****", "id_type": "$idType"}',
      );
      final res = await http.post(
        url,
        headers: _headers(null),
        body: jsonEncode({"id_number": idNumber, "pin": pin, "id_type": idType}),
      );
      print('Login response: status=${res.statusCode}, body=${res.body}');
      return _handleResponse(res, context: context);
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> verifyOtp(
    String idNumber,
    String otp, {
    BuildContext? context,
  }) async {
    _loading = true;
    notifyListeners();
    try {
      final url = Uri.parse('${AppConstants.API_PREFIX}/verify-otp');
      print(
        'Verify OTP request to: $url with body: {"id_number": "$idNumber", "otp": "$otp"}',
      );
      final res = await http.post(
        url,
        headers: _headers(null),
        body: jsonEncode({"id_number": idNumber, "otp": otp}),
      );
      print('Verify OTP response: status=${res.statusCode}, body=${res.body}');
      final responseData = _handleResponse(res, context: context);
      if (responseData.containsKey('access_token')) {
        await saveToken(responseData['access_token']);
      }
      return responseData;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> register(
    String name,
    String phone,
    String pin, {
    String role = 'mother',
    required String idType,
    required String idNumber,
    BuildContext? context,
  }) async {
    _loading = true;
    notifyListeners();
    try {
      final url = Uri.parse('${AppConstants.API_PREFIX}/register');
      print(
        'Register request to: $url with body: {"name": "$name", "phone": "$phone", "pin": "****", "role": "$role", "id_type": "$idType", "id_number": "$idNumber"}',
      );
      final res = await http.post(
        url,
        headers: _headers(null),
        body: jsonEncode({
          "name": name,
          "phone": phone,
          "pin": pin,
          "role": role,
          "id_type": idType,
          "id_number": idNumber,
        }),
      );
      print('Register response: status=${res.statusCode}, body=${res.body}');
      return _handleResponse(res, context: context);
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  // Mothers
  Future<Map<String, dynamic>> registerMother(Map<String, dynamic> body) async {
    _loading = true;
    notifyListeners();
    try {
      final url = Uri.parse('${AppConstants.API_PREFIX}/mothers/');
      final t = await token;
      print('Register mother request to: $url with body: $body');
      final res = await http.post(
        url,
        headers: _headers(t),
        body: jsonEncode(body),
      );
      print('Register mother response: status=${res.statusCode}, body=${res.body}');
      return _handleResponse(res);
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<List<dynamic>> getMothers() async {
    _loading = true;
    notifyListeners();
    try {
      final url = Uri.parse('${AppConstants.API_PREFIX}/mothers/');
      final t = await token;
      print('Get mothers request to: $url');
      final res = await http.get(url, headers: _headers(t));
      print('Get mothers response: status=${res.statusCode}, body=${res.body}');
      final parsed = _handleResponse(res);
      return parsed is List ? parsed : (parsed['data'] ?? []);
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  // Appointments
  Future<List<dynamic>> getUpcomingAppointments() async {
    _loading = true;
    notifyListeners();
    try {
      final url = Uri.parse('${AppConstants.API_PREFIX}/appointments/upcoming');
      final t = await token;
      print('Get upcoming appointments request to: $url');
      final res = await http.get(url, headers: _headers(t));
      print('Get upcoming appointments response: status=${res.statusCode}, body=${res.body}');
      final parsed = _handleResponse(res);
      return parsed is List ? parsed : (parsed['data'] ?? []);
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> createAppointment(Map<String, dynamic> body) async {
    _loading = true;
    notifyListeners();
    try {
      final url = Uri.parse('${AppConstants.API_PREFIX}/appointments/create');
      final t = await token;
      print('Create appointment request to: $url with body: $body');
      final res = await http.post(
        url,
        headers: _headers(t),
        body: jsonEncode(body),
      );
      print('Create appointment response: status=${res.statusCode}, body=${res.body}');
      return _handleResponse(res);
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  // Payments
  Future<Map<String, dynamic>> initiatePayment(double amount, String phone) async {
    _loading = true;
    notifyListeners();
    try {
      final url = Uri.parse('${AppConstants.API_PREFIX}/payments/checkout');
      final t = await token;
      print('Initiate payment request to: $url with body: {"amount": $amount, "phone": "$phone"}');
      final res = await http.post(
        url,
        headers: _headers(t),
        body: jsonEncode({"amount": amount, "phone": phone}),
      );
      print('Initiate payment response: status=${res.statusCode}, body=${res.body}');
      return _handleResponse(res);
    } finally {
      _loading = false;
      notifyListeners();
    }
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
  dynamic _handleResponse(http.Response res, {BuildContext? context}) {
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
        if (context != null) {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text('Error'),
              content: Text(error.toString()),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: Text('OK'),
                ),
              ],
            ),
          );
        }
        throw Exception(error);
      } catch (e) {
        print('Error parsing error response: $e');
        if (context != null) {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text('Error'),
              content: Text('HTTP ${res.statusCode}: ${res.body}'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: Text('OK'),
                ),
              ],
            ),
          );
        }
        throw Exception('HTTP ${res.statusCode}: ${res.body}');
      }
    }
  }
}
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/appointment.dart';

class AppointmentProvider with ChangeNotifier {
  final ApiService api;
  List<Appointment> appointments = [];
  bool loading = false;

  AppointmentProvider(this.api, {required ApiService apiService});

  Future<void> fetchUpcoming() async {
    loading = true; notifyListeners();
    final res = await api.getUpcomingAppointments();
    appointments = (res).map((e) => Appointment.fromJson(e as Map<String, dynamic>)).toList();
    loading = false; notifyListeners();
  }

  Future<void> createAppointment(int motherId, DateTime date, String type) async {
    final body = {"mother_id": motherId, "date": date.toIso8601String(), "type": type};
    await api.createAppointment(body);
    await fetchUpcoming();
  }
}

import 'package:flutter/material.dart';
import 'package:maternal_app/pages/payment_page.dart';
import 'package:maternal_app/pages/profile_page.dart';
import 'package:maternal_app/pages/reminders_page.dart';
import 'package:maternal_app/provider/appointment_provider.dart';
import 'package:maternal_app/provider/auth_provider.dart';
import 'package:provider/provider.dart';
import 'config/app_constants.dart';
import 'services/api_service.dart';
import 'providers/auth_provider.dart';
import 'providers/appointment_provider.dart';
import 'pages/splash_page.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/home_page.dart' as home;
import 'pages/appointment_page.dart' as appointment;
import 'pages/settings_page.dart' as settings;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ApiService api = ApiService();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider(api)),
        ChangeNotifierProvider(create: (_) => AppointmentProvider(api, apiService: api)),
      ],
      child: MaterialApp(
        title: 'Mama Health',
        theme: ThemeData(primarySwatch: Colors.teal),
        initialRoute: '/',
        routes: {
          '/': (_) => OnboardingPage1(onFinish: () {  },),
          '/login': (_) => LoginPage(),
          '/register': (_) => RegisterPage(),
          '/home': (_) => home.HomePage(),
          '/appointment': (_) => appointment.AppointmentPage(),
          '/profile': (_) => ProfilePage(),
          '/settings': (_) => settings.SettingsPage(),
          '/reminders': (_) => RemindersPage(),
          '/payment': (_) => PaymentPage(),
        },
      ),
    );
  }
}

class SettingsPage {
}

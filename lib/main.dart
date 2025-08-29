import 'package:flutter/material.dart';
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
import 'pages/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ApiService api = ApiService();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider(api)),
        ChangeNotifierProvider(create: (_) => AppointmentProvider(api)),
      ],
      child: MaterialApp(
        title: 'Mama Health',
        theme: ThemeData(primarySwatch: Colors.teal),
        initialRoute: '/',
        routes: {
          '/': (_) => SplashPage(),
          '/login': (_) => LoginPage(),
          '/register': (_) => RegisterPage(),
          '/home': (_) => HomePage(),
        },
      ),
    );
  }
}

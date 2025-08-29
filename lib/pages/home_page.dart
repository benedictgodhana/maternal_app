import 'package:flutter/material.dart';
import 'package:maternal_app/provider/auth_provider.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'appointment_page.dart';
import 'reminders_page.dart';
import 'payment_page.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  @override State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _idx = 0;
  final _pages = [AppointmentPage(), RemindersPage(), PaymentPage(), ProfilePage()];

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Dashboard')),
      body: _pages[_idx],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _idx,
        onTap: (i) => setState(() => _idx = i),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Appointments'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Reminders'),
          BottomNavigationBarItem(icon: Icon(Icons.payment), label: 'Payments'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
      floatingActionButton: auth.user != null && auth.user!.role != 'mother' ? FloatingActionButton(
        onPressed: () {
          // clinic staff action: register mother quick
          Navigator.push(context, MaterialPageRoute(builder: (_) => AppointmentPage(initialCreateMother: true)));
        },
        child: Icon(Icons.add),
        tooltip: 'Register mother / create appointment',
      ) : null,
    );
  }
}

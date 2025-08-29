import 'package:flutter/material.dart';

class RemindersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // For MVP, we show static text; backend will send SMS reminders
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(children: [
        Text('Reminders', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height:12),
        Text('SMS reminders are managed by the clinic. This page will display upcoming reminder logs (future work).'),
      ]),
    );
  }
}

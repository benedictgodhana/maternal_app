import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentPage extends StatefulWidget {
  @override State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final amountCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  bool busy = false;
  final api = ApiService();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(children: [
        Text('Payments', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height:12),
        TextField(controller: amountCtrl, decoration: InputDecoration(labelText: 'Amount (KES)'), keyboardType: TextInputType.number),
        SizedBox(height:8),
        TextField(controller: phoneCtrl, decoration: InputDecoration(labelText: 'Phone (2547...)'), keyboardType: TextInputType.phone),
        SizedBox(height:12),
        ElevatedButton(
          onPressed: busy ? null : () async {
            setState(() => busy = true);
            try {
              final res = await api.initiatePayment(double.parse(amountCtrl.text), phoneCtrl.text);
              // Expect backend to return url / checkout reference, e.g. res['checkout_url'] or res['data']['checkout_url']
              final url = res['checkout_url'] ?? (res['data'] != null ? res['data']['checkout_url'] : null);
              if (url != null) {
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Cannot open payment URL')));
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Payment initiated. Check backend logs.')));
              }
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
            } finally {
              setState(() => busy = false);
            }
          },
          child: busy ? CircularProgressIndicator(color: Colors.white) : Text('Pay'),
          style: ElevatedButton.styleFrom(minimumSize: Size.fromHeight(48)),
        )
      ]),
    );
  }
}

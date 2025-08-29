import 'package:flutter/material.dart';
import 'package:maternal_app/provider/appointment_provider.dart';
import 'package:provider/provider.dart';
import '../providers/appointment_provider.dart';

class AppointmentPage extends StatefulWidget {
  final bool initialCreateMother;
  const AppointmentPage({this.initialCreateMother=false});
  @override State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AppointmentProvider>(context, listen:false).fetchUpcoming();
    });
  }

  @override
  Widget build(BuildContext context) {
    final apptProv = Provider.of<AppointmentProvider>(context);
    return Padding(
      padding: EdgeInsets.all(12),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Upcoming appointments', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextButton(onPressed: () => _openCreateDialog(context), child: Text('Create'))
          ]),
          SizedBox(height: 8),
          if (apptProv.loading) CircularProgressIndicator(),
          if (!apptProv.loading && apptProv.appointments.isEmpty) Text('No upcoming appointments'),
          if (!apptProv.loading) Expanded(
            child: ListView.builder(
              itemCount: apptProv.appointments.length,
              itemBuilder: (_, i) {
                final a = apptProv.appointments[i];
                return Card(
                  child: ListTile(
                    title: Text('${a.type} — ${a.date.toLocal()}'.split('.')[0]),
                    subtitle: Text('Status: ${a.status}'),
                  ),
                );
              }
            ),
          )
        ],
      ),
    );
  }

  void _openCreateDialog(BuildContext ctx) {
    final motherIdCtrl = TextEditingController();
    DateTime? selected;
    showDialog(context: ctx, builder: (_) {
      return AlertDialog(
        title: Text('Create appointment'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(controller: motherIdCtrl, decoration: InputDecoration(labelText: 'Mother ID')),
          SizedBox(height:8),
          ElevatedButton(onPressed: () async {
            final dt = await showDatePicker(context: ctx, initialDate: DateTime.now(), firstDate: DateTime.now().subtract(Duration(days:1)), lastDate: DateTime.now().add(Duration(days:365)));
            if (dt != null) selected = dt;
          }, child: Text('Pick date')),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text('Cancel')),
          TextButton(onPressed: () async {
            if (motherIdCtrl.text.isEmpty || selected == null) return;
            await Provider.of<AppointmentProvider>(ctx, listen:false).createAppointment(int.parse(motherIdCtrl.text), selected!, 'ANC');
            Navigator.pop(ctx);
          }, child: Text('Create'))
        ],
      );
    });
  }
}

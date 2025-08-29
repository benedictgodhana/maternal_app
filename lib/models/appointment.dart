class Appointment {
  final int id;
  final int motherId;
  final DateTime date;
  final String type;
  final String status;

  Appointment({required this.id, required this.motherId, required this.date, required this.type, required this.status});

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'],
      motherId: json['mother_id'],
      date: DateTime.parse(json['date']),
      type: json['type'] ?? 'ANC',
      status: json['status'] ?? 'scheduled',
    );
  }
}

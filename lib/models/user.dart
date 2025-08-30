class User {
  final int id;
  final String name;
  final String phone;
  final String role;
  final String idType;
  final String idNumber;
  final String pin;

  User({
    required this.id,
    required this.name,
    required this.phone,
    required this.role,
    required this.idType,
    required this.idNumber,
    required this.pin,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      role: json['role'] ?? 'mother',
      idType: json['idType'] ?? 'National ID',
      idNumber: json['idNumber'] ?? '',
      pin: json['pin'] ?? '',
    );
  }

  get dob => null;

  get email => null;

  get profilePicture => null;

  get reminders => null;

  get appointments => null;

  get healthTips => null;

  toJson() {}
}
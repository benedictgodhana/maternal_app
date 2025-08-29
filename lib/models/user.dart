class User {
  final int id;
  final String name;
  final String phone;
  final String role;

  User({required this.id, required this.name, required this.phone, required this.role});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      role: json['role'] ?? 'mother',
    );
  }
}

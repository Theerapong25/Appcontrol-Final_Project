// lib/models/user_model.dart
class UserModel {
  final String id;
  final String username;
  final String email;
  final String passwordHash;
  final String fullName;
  final DateTime createdAt;
  final String role;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.passwordHash,
    required this.fullName,
    required this.createdAt,
    this.role = 'User',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'passwordHash': passwordHash,
      'fullName': fullName,
      'createdAt': createdAt.toIso8601String(),
      'role': role,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      passwordHash: json['passwordHash'],
      fullName: json['fullName'],
      createdAt: DateTime.parse(json['createdAt']),
      role: json['role'] ?? 'User',
    );
  }
}

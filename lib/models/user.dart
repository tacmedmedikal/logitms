class User {
  final String id;
  final String email;
  final String fullName;
  final String? phone;
  final UserRole role;
  final DateTime createdAt;
  final bool isActive;

  User({
    required this.id,
    required this.email,
    required this.fullName,
    this.phone,
    required this.role,
    required this.createdAt,
    this.isActive = true,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['full_name'] as String,
      phone: json['phone'] as String?,
      role: UserRole.values.firstWhere(
        (e) => e.name == json['role'],
        orElse: () => UserRole.viewer,
      ),
      createdAt: DateTime.parse(json['created_at'] as String),
      isActive: json['is_active'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'phone': phone,
      'role': role.name,
      'created_at': createdAt.toIso8601String(),
      'is_active': isActive,
    };
  }
}

enum UserRole {
  admin,
  manager,
  dispatcher,
  driver,
  viewer,
}

extension UserRoleExtension on UserRole {
  String get displayName {
    switch (this) {
      case UserRole.admin:
        return 'Admin';
      case UserRole.manager:
        return 'Yonetici';
      case UserRole.dispatcher:
        return 'Sevkiyatci';
      case UserRole.driver:
        return 'Surucu';
      case UserRole.viewer:
        return 'Izleyici';
    }
  }
}

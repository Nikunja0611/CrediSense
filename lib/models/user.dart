class UserModel {
  final String id;
  final String name;
  final String email;
  final String role;
  final bool isFirstLogin;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.isFirstLogin = true,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? role,
    bool? isFirstLogin,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      isFirstLogin: isFirstLogin ?? this.isFirstLogin,
    );
  }
}

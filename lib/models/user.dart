class UserModel {
  final String id;
  final String name;
  final String email;
  final String role; // "user" or "admin"

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.role = 'user',
  });
}

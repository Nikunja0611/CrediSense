class UserModel {
  final String id;
  final String name;
  final String email;
  final String role; // "user" or "admin"
  final String phoneNumber;
  final String dob;
  final String gender;
  final String address; // you can split later into street/city/pincode if needed
  final String occupation;
  final String employer;
  final String incomeRange;
  final String employmentType; // Salaried, Self-employed, Student, etc.
  final String? otp; // ✅ Added for email OTP storage (optional)

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.role = 'user',
    required this.phoneNumber,
    required this.dob,
    required this.gender,
    required this.address,
    required this.occupation,
    required this.employer,
    required this.incomeRange,
    required this.employmentType,
    this.otp,
  });

  /// Convert object to JSON (for Firebase)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'phoneNumber': phoneNumber,
      'dob': dob,
      'gender': gender,
      'address': address,
      'occupation': occupation,
      'employer': employer,
      'incomeRange': incomeRange,
      'employmentType': employmentType,
      'otp': otp,
    };
  }

  /// Convert JSON from Firebase to UserModel
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      role: map['role'] ?? 'user',
      phoneNumber: map['phoneNumber'] ?? '',
      dob: map['dob'] ?? '',
      gender: map['gender'] ?? '',
      address: map['address'] ?? '',
      occupation: map['occupation'] ?? '',
      employer: map['employer'] ?? '',
      incomeRange: map['incomeRange'] ?? '',
      employmentType: map['employmentType'] ?? '',
      otp: map['otp'], // optional
    );
  }

  /// Create a copy of user with some updated fields
  UserModel copyWith({
    String? name,
    String? email,
    String? role,
    String? phoneNumber,
    String? dob,
    String? gender,
    String? address,
    String? occupation,
    String? employer,
    String? incomeRange,
    String? employmentType,
    String? otp,
  }) {
    return UserModel(
      id: id, // keep original id
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      dob: dob ?? this.dob,
      gender: gender ?? this.gender,
      address: address ?? this.address,
      occupation: occupation ?? this.occupation,
      employer: employer ?? this.employer,
      incomeRange: incomeRange ?? this.incomeRange,
      employmentType: employmentType ?? this.employmentType,
      otp: otp ?? this.otp,
    );
  }
}

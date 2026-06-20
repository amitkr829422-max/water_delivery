class UserModel {
  final String uid;
  final String phoneNumber;
  final String name;
  final String role; // customer, delivery, admin

  UserModel({
    required this.uid,
    required this.phoneNumber,
    required this.name,
    required this.role,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      name: map['name'] ?? '',
      role: map['role'] ?? 'customer',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'phoneNumber': phoneNumber,
      'name': name,
      'role': role,
    };
  }
}

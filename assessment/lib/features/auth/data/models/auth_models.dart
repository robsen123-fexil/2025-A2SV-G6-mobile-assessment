import 'package:assessment/features/auth/domain/entities/user.dart';

class UserModel extends User {
  UserModel({required super.id, required super.name, required super.email});

  factory UserModel.fromjson(Map<String, dynamic> json) {
    // Extract user data from the nested 'data' field
    final userData = json['data'] ?? json;

    return UserModel(
      id: userData['id']?.toString() ?? '', // Convert to String and handle null
      name: userData['name']?.toString() ?? '',
      email: userData['email']?.toString() ?? '',
    );
  }

  Map<String, dynamic> tojson() {
    return {'id': id, 'name': name, 'email': email};
  }
}

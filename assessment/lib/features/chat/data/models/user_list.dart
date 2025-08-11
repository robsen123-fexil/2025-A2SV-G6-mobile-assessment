import 'package:assessment/features/chat/domain/entities/user_list.dart';

class UserListModel extends UserList {
  const UserListModel({
    required super.id,
    required super.name,
    required super.email,
  });


  factory UserListModel.fromjson(Map<String, dynamic> json) {
    return UserListModel(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
    );
  }

  Map<String, dynamic> tojson() {
    return {'_id': id, 'name': name, 'email': email};
  }
}
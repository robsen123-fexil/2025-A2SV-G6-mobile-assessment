import '../../domain/entities/chat_room.dart';

class ChatUserModel extends ChatUser {
  const ChatUserModel({
    required super.id,
    required super.name,
    required super.email,
  });

  factory ChatUserModel.fromjson(Map<String, dynamic> json) {
    return ChatUserModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> tojson() {
    return {'_id': id, 'name': name, 'email': email};
  }
}

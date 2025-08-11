import 'package:assessment/features/chat/data/models/chat_user_model.dart';
import 'package:assessment/features/chat/domain/entities/chat_room.dart';
 




class ChatRoomModel extends ChatRoom {
  const ChatRoomModel({
    required super.id,
    required super.user1,
    required super.user2,
  });

  factory ChatRoomModel.fromjson(Map<String, dynamic> json) {
    return ChatRoomModel(
      id: json['_id'],
      user1: ChatUserModel.fromjson(json['user1']),
      user2: ChatUserModel.fromjson(json['user2']),
    );
  }
}
  

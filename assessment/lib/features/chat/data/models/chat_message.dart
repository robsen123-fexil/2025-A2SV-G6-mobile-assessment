import 'package:assessment/features/auth/data/models/auth_models.dart';
import 'package:assessment/features/auth/domain/entities/user.dart';
import 'package:assessment/features/chat/data/models/chat_room_model.dart';
import 'package:assessment/features/chat/data/models/chat_user_model.dart';
import 'package:assessment/features/chat/data/models/user_list.dart';
import 'package:assessment/features/chat/domain/entities/chat_message.dart';
import 'package:flutter/cupertino.dart';

class ChatMessageModel extends ChatMessage {
  const ChatMessageModel({
    required super.id,
    required super.sender,
    required super.chat,
    required super.content,
    required super.type,
  });

  factory ChatMessageModel.fromjson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['_id'],
      sender:UserModel.fromjson(json['name']),
      content: json['content'],
      chat: ChatRoomModel.fromjson(json['chat']),
      type: json['type'],
    );
  }


}


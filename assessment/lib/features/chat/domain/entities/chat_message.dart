import 'package:assessment/features/auth/domain/entities/user.dart';
import 'package:assessment/features/chat/domain/entities/chat_room.dart';

class ChatMessage {
  final String id;
  final User sender;
  final ChatRoom chat;
  final String content;
  final String type;
  const ChatMessage({
    required this.id,
    required this.sender,
    required this.chat,
    required this.content,
    required this.type,
  });
}

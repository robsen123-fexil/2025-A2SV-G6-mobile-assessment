import 'package:assessment/features/chat/domain/entities/chat_message.dart';
import 'package:assessment/features/chat/domain/entities/user_list.dart';
import 'package:assessment/features/chat/domain/entities/chat_room.dart';

abstract class ChatState {}

// ---------- Users listing ----------
class UsersInitial extends ChatState {}

class UsersLoading extends ChatState {}

class UsersLoaded extends ChatState {
  final List<UserList> users;
  UsersLoaded(this.users);
}

class UsersFailure extends ChatState {
  final String message;
  UsersFailure(this.message);
}

// ---------- Chatted List ----------
class ChatsInitial extends ChatState {}

class ChatsLoading extends ChatState {}

class ChatsLoaded extends ChatState {
  final List<ChatRoom> chats;
  ChatsLoaded(this.chats);
}

class ChatsFailure extends ChatState {
  final String message;
  ChatsFailure(this.message);
}

// ---------- Initiate Chat ----------
class InitiateChatInitial extends ChatState {}

class InitiateChatLoading extends ChatState {}

class InitiateChatLoaded extends ChatState {
  final ChatRoom chat;
  InitiateChatLoaded(this.chat);
}

class InitiateChatFailure extends ChatState {
  final String message;
  InitiateChatFailure(this.message);
}

// ---------- Get Chat Messages ----------
class MessagesInitial extends ChatState {}

class MessagesLoading extends ChatState {}

class MessagesLoaded extends ChatState {
  final List<ChatMessage> messages;
  MessagesLoaded(this.messages);
}

class MessagesFailure extends ChatState {
  final String message;
  MessagesFailure(this.message);
}

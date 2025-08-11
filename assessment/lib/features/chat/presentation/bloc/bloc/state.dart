import 'package:assessment/features/chat/domain/entities/user_list.dart';
import 'package:assessment/features/chat/domain/entities/chat_room.dart';

abstract class UserState{}

class UsersLoading extends UserState {}

class UsersLoaded extends UserState {
  final List<UserList> users;
  UsersLoaded(this.users);
}

class UsersFailure extends UserState {
  final String message;
  UsersFailure(this.message);
}

class ChattedLoading extends UserState {}

class ChattedLoaded extends UserState {
  final List<ChatRoom> chats;
  ChattedLoaded(this.chats);
}

class ChattedFailure extends UserState {
  final String message;
  ChattedFailure(this.message);
}

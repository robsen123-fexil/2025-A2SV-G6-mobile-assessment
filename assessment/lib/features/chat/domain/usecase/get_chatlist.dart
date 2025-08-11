import 'package:assessment/core/error/failure.dart';
import 'package:assessment/core/usecase/usecase.dart';
import 'package:assessment/features/chat/domain/entities/chat_room.dart';
import 'package:assessment/features/chat/domain/repositories/chat_repositories.dart';
import 'package:dartz/dartz.dart';

class GetChatList implements UseCase<List<ChatRoom>, String>   {
  final ChatRepositories chatRepositories;
  GetChatList({required this.chatRepositories});

  @override
  Future<Either<Failure, List<ChatRoom>>> call(String token) {
    return chatRepositories.getMyChats(token);
  }
}

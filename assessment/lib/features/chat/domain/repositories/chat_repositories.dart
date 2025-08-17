import 'package:assessment/core/error/failure.dart';
import 'package:assessment/features/chat/domain/entities/chat_message.dart';
import 'package:assessment/features/chat/domain/entities/chat_room.dart';
import 'package:assessment/features/chat/domain/entities/user_list.dart';
import 'package:dartz/dartz.dart';

abstract class ChatRepositories {
  Future<Either<Failure, List<ChatRoom>>> getMyChats(String token);
  Future<Either<Failure, ChatRoom>> initateddata(
    String token,
    String recieverid,
  );
    Future<Either<Failure, List<ChatMessage>>> getChatMessage(
    String token,
    String chatid,
  );
   Future<Either<Failure, List<UserList>>> getUsers(String token);
}



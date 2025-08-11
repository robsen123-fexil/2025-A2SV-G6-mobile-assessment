import 'package:assessment/core/error/failure.dart';
import 'package:assessment/features/chat/domain/entities/chat_room.dart';
import 'package:dartz/dartz.dart';

abstract class ChatRepositories {
  Future<Either<Failure, List<ChatRoom>>> getMyChats(String token);
}
abstract class InitaiatechatRepostiory {
  Future<Either<Failure, List<dynamic>>> initateddata(
    String token,
    String recieverid,
  );
}

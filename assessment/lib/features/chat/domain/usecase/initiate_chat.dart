import 'package:assessment/core/error/failure.dart';
import 'package:assessment/core/usecase/usecase.dart';
import 'package:assessment/features/chat/domain/entities/chat_room.dart';
import 'package:assessment/features/chat/domain/repositories/chat_repositories.dart';
import 'package:dartz/dartz.dart';

class InitiateChat implements UseCase<ChatRoom, InitiateChatParams> {
  final ChatRepositories repository;

  InitiateChat({required this.repository});

  @override
  Future<Either<Failure, ChatRoom>> call(InitiateChatParams params) {
    return repository.initateddata(params.token, params.recieverid);
  }
}

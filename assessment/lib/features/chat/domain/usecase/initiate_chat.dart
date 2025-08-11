import 'package:assessment/core/error/failure.dart';
import 'package:assessment/core/usecase/usecase.dart';
import 'package:assessment/features/chat/domain/repositories/chat_repositories.dart';
import 'package:dartz/dartz.dart';

class InitiateChat implements UseCase<List<dynamic>, InitiateChatParams> {
  final InitaiatechatRepostiory repository;

  InitiateChat({required this.repository});

  @override
  Future<Either<Failure, List<dynamic>>> call(InitiateChatParams params) {
    return repository.initateddata(params.token, params.recieverid);
  }
}
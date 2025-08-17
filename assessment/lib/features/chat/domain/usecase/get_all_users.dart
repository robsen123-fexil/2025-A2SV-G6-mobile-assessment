import 'package:assessment/core/error/failure.dart';
import 'package:assessment/features/chat/domain/entities/user_list.dart';
import 'package:assessment/features/chat/domain/repositories/chat_repositories.dart';
import 'package:dartz/dartz.dart';

class GetAllUsers {
  final ChatRepositories repository;

  GetAllUsers(this.repository);

  Future<Either<Failure, List<UserList>>> call(String token) async {
    return await repository.getUsers(token);
  }
}

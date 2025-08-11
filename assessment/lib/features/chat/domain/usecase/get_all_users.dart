import 'package:assessment/core/error/failure.dart';
import 'package:assessment/features/chat/domain/entities/user_list.dart';
import 'package:dartz/dartz.dart';

import '../repositories/user_repository.dart';

class GetAllUsers {
  final GetAllUserRepository repository;

  GetAllUsers(this.repository);

  Future<Either<Failure, List<UserList>>> call(String token) async {
    return await repository.getUsers(token);
  }
}

import 'package:assessment/core/error/failure.dart';
import 'package:assessment/features/chat/domain/entities/user_list.dart';
import 'package:dartz/dartz.dart';

abstract class GetAllUserRepository {
  Future<Either<Failure, List<UserList>>> getUsers(String token);
}

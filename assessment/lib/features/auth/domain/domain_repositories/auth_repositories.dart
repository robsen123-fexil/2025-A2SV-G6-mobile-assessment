import 'package:assessment/core/error/failure.dart';
import 'package:assessment/features/auth/domain/entities/user.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRepositories {
  Future<Either<Failure, User>> login(String email, String password);

  Future<Either<Failure , User>> register(String email , String password);

  Future<Either<Failure , Unit>> logout();
}

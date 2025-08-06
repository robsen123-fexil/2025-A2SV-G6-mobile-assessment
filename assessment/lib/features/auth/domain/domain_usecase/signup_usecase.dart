import 'package:assessment/core/error/failure.dart';
import 'package:assessment/core/usecase/usecase.dart';
import 'package:assessment/features/auth/domain/domain_repositories/auth_repositories.dart';
import 'package:assessment/features/auth/domain/entities/user.dart';
import 'package:dartz/dartz.dart';

class SignupUsecase implements UseCase<User, SignupParams> {
  final AuthRepositories repositories;

  SignupUsecase(this.repositories);
  @override
  Future<Either<Failure, User>> call(SignupParams params) {
    return repositories.register(params.email, params.password);
  }
}


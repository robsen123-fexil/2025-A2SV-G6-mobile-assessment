import 'package:assessment/core/error/failure.dart';
import 'package:assessment/core/usecase/usecase.dart';
import 'package:assessment/features/auth/domain/domain_repositories/auth_repositories.dart';
import 'package:assessment/features/auth/domain/entities/user.dart';
import 'package:dartz/dartz.dart';

class LoginUseCase implements UseCase<User, LoginParams> {
  final AuthRepositories repository;

  LoginUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(LoginParams params) {
    return repository.login(params.email, params.password);
  }
}



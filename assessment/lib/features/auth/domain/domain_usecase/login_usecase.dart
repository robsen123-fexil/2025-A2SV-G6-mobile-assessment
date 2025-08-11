import 'package:assessment/core/error/failure.dart';
import 'package:assessment/core/usecase/usecase.dart';
import 'package:assessment/features/auth/domain/domain_repositories/auth_repositories.dart';
import 'package:dartz/dartz.dart';

class LoginUseCase implements UseCase<String, LoginParams> {
  final AuthRepositories repository;

  LoginUseCase({required this.repository});

  @override
  Future<Either<Failure, String>> call(LoginParams params) {
    return repository.login(params.email, params.password);
  }
}

import 'package:assessment/core/error/failure.dart';
import 'package:assessment/core/usecase/usecase.dart';
import 'package:assessment/features/auth/domain/domain_repositories/auth_repositories.dart';
import 'package:dartz/dartz.dart';

class LogoutUsecase implements UseCase<Unit, NoParams> {
  final AuthRepositories repository;

  LogoutUsecase(this.repository);
  @override
  Future<Either<Failure, Unit>> call(params) {
    return repository.logout();
  }
}

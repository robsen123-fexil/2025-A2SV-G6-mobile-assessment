import 'package:assessment/core/error/failure.dart';
import 'package:assessment/core/network_info/network_info.dart';
import 'package:assessment/features/auth/data/datasources/auth_datasource.dart';
import 'package:assessment/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:assessment/features/auth/domain/domain_repositories/auth_repositories.dart';
import 'package:assessment/features/auth/domain/entities/user.dart';
import 'package:dartz/dartz.dart';

class AuthRepositoriesImp implements AuthRepositories {
  final AuthRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  final AuthLocalDataSource localDataSource;

  AuthRepositoriesImp({
    required this.remoteDataSource,
    required this.networkInfo,
    required this.localDataSource,
  });
  @override
  Future<Either<Failure, String>> login(String email, String password) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.login(email, password);
        return result.fold((failure) => Left(failure), (token) async {
          // persist and log token on successful login
          try {
            await localDataSource.saveToken(token);
            // print token to terminal as requested
            // ignore: avoid_print
            print('Login succeeded. Access token: ' + token);
          } catch (e) {
            // ignore: avoid_print
            print('Failed to save token locally: $e');
          }
          return Right(token);
        });
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, Unit>> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }

@override
  Future<Either<Failure, User>> register(
    String name,
    String email,
    String password,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        print('Calling remote data source for registration...');
        final result = await remoteDataSource.register(name, email, password);
        return result.fold(
          (failure) {
            print('Registration failed: $failure');
            return Left(failure);
          },
          (user) {
            print('Registration successful for user: ${user.email}');
            return Right(user);
          },
        );
      } catch (e) {
        print('Unexpected error in repository: $e');
        return Left(ServerFailure('Unexpected error occurred'));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }
}

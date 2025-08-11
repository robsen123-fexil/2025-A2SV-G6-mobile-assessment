import 'package:assessment/core/error/failure.dart';
import 'package:assessment/core/network_info/network_info.dart';
import 'package:assessment/features/chat/data/data_sources/user_list_data_source.dart';
import 'package:assessment/features/chat/domain/entities/user_list.dart' as entity;
import 'package:assessment/features/chat/domain/repositories/user_repository.dart';
import 'package:dartz/dartz.dart';

class UserListRepositoryImpl implements GetAllUserRepository {
  final GetAllUserRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  UserListRepositoryImpl({required this.remoteDataSource, required this.networkInfo});

  @override
  Future<Either<Failure, List<entity.UserList>>> getUsers(String token) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getUsers(token);
        return result.fold((failure) => Left(failure), (users) => Right(users));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

}

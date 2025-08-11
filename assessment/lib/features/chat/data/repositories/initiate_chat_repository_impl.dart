import 'package:assessment/core/error/failure.dart';
import 'package:assessment/core/network_info/network_info.dart';
import 'package:assessment/features/chat/data/data_sources/chat_remote_datasource.dart';
import 'package:assessment/features/chat/domain/repositories/chat_repositories.dart';
import 'package:dartz/dartz.dart';

class InitiateChatRepositoryImpl implements InitaiatechatRepostiory {
  final ChatRemoteDatasource remoteDataSource;
  final NetworkInfo networkInfo;

  InitiateChatRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<dynamic>>> initateddata(
      String token, String recieverid) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.initiateChat(token, recieverid);
        return result.fold((failure) => Left(failure), (data) => Right(data));
      } catch (e) {
        return Left(ServerFailure(e.toString()))
;      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }
}

import 'package:assessment/core/error/failure.dart';
import 'package:assessment/core/network_info/network_info.dart';
import 'package:assessment/features/chat/data/data_sources/chat_remote_datasource.dart';
import 'package:assessment/features/chat/domain/entities/chat_room.dart';
import 'package:assessment/features/chat/domain/repositories/chat_repositories.dart';
import 'package:dartz/dartz.dart';

class ChatRepositoryImpl implements ChatRepositories {
  final ChatRemoteDatasource remoteDataSource;
  final NetworkInfo networkInfo;
  
  ChatRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,

  });

  @override
  Future<Either<Failure, List<ChatRoom>>> getMyChats(String token) async{
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getMyChats(token);
        return result.fold((failure) => Left(failure), (chats) => Right(chats));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }
}
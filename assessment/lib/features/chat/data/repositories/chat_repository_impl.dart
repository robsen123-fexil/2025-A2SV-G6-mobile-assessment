import 'package:assessment/core/error/failure.dart';
import 'package:assessment/core/network_info/network_info.dart';
import 'package:assessment/features/chat/data/data_sources/chat_remote_datasource.dart';
import 'package:assessment/features/chat/domain/entities/chat_message.dart';
import 'package:assessment/features/chat/domain/entities/chat_room.dart';
import 'package:assessment/features/chat/domain/entities/user_list.dart';
import 'package:assessment/features/chat/domain/entities/user_list.dart' as entity;
import 'package:assessment/features/chat/domain/repositories/chat_repositories.dart';
import 'package:dartz/dartz.dart';

class ChatRepositoryImpl implements ChatRepositories, ChatDetailRepository {
  final ChatRemoteDatasource remoteDataSource;
  final NetworkInfo networkInfo;

  ChatRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<ChatRoom>>> getMyChats(String token) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getMyChats(token);
        print(result);
        return result.fold((failure) => Left(failure), (chats) => Right(chats));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<ChatMessage>>> getChatMessage(
    String token,
    String chatid,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getChatMessage(token, chatid);
        return result.fold((failure) => Left(failure), (chats) => Right(chats));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

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

  @override
  Future<Either<Failure, ChatRoom>> initateddata(String token, String recieverid) {
    // TODO: implement initateddata
    throw UnimplementedError();
  }
}

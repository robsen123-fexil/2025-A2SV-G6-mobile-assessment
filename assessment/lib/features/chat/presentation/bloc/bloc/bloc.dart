import 'package:assessment/core/network_info/network_info.dart';
import 'package:assessment/features/chat/data/data_sources/chat_remote_datasource.dart';
import 'package:assessment/features/chat/data/data_sources/user_list_data_source.dart';
import 'package:assessment/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:assessment/features/chat/data/repositories/user_list_repositoryimpl.dart';
import 'package:assessment/features/chat/domain/usecase/get_all_users.dart';
import 'package:assessment/features/chat/domain/usecase/get_chatlist.dart';
import 'package:assessment/features/chat/domain/usecase/initiate_chat.dart';
import 'package:assessment/features/chat/presentation/bloc/bloc/event.dart';
import 'package:assessment/features/chat/presentation/bloc/bloc/state.dart';
import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;

import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:assessment/features/chat/data/repositories/initiate_chat_repository_impl.dart';
import 'package:assessment/core/usecase/usecase.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc(UserState initialState) : super(initialState) {
    on<FetchUsersRequested>((event, emit) async {
      emit(UsersLoading());
      final repo = UserListRepositoryImpl(
        remoteDataSource: GetAllUserRemoteDataSourceImpl(
          client: http.Client(),
          networkInfo: NetworkInfoImpl(
            InternetConnectionChecker.createInstance(),
          ),
        ),
        networkInfo: NetworkInfoImpl(
          InternetConnectionChecker.createInstance(),
        ),
      );
      final usecase = GetAllUsers(repo);
      final result = await usecase(event.token);
      result.fold(
        (failure) => emit(UsersFailure(failure.message)),
        (users) => emit(UsersLoaded(users)),
      );
    });

    // on<FetchChattedRequest>((event, emit) async{
    //   emit(ChattedLoading());
    //   final repo = ChatRepositoryImpl(
    //     remoteDataSource: ChatRemoteDatasourceImpl(
    //       client: http.Client(),
    //       networkInfo: NetworkInfoImpl(
    //         InternetConnectionChecker.createInstance(),
    //       ),
    //     ),
    //     networkInfo: NetworkInfoImpl(
    //       InternetConnectionChecker.createInstance(),
    //     ),
    //   );
    //   final usecase = GetChatList(repo);
    //   final result = await usecase(event.token);
    //   result.fold(
    //     (failure) => emit(ChattedFailure(failure.message)),
    //     (chats) => emit(ChattedLoaded(chats)),
    //   );


    // });

    on<FetchChattedRequest>((event, emit) async{
      emit(ChattedLoading());
      final repo = ChatRepositoryImpl(
        remoteDataSource: ChatRemoteDatasourceImpl(
          client: http.Client(),
          
          networkInfo: NetworkInfoImpl(
            InternetConnectionChecker.createInstance(),
          ),
        ),
        networkInfo: NetworkInfoImpl(
          InternetConnectionChecker.createInstance(),
        ),
      );
      final usecase = GetChatList(chatRepositories: repo);
      final result = await usecase(event.token);
      result.fold(
        (failure) => emit(ChattedFailure(failure.message)),
        (chats) => emit(ChattedLoaded(chats)),
      );


    });

    on<InitiateChatRequested>((event, emit) async {
      // Optionally, we could keep current list while initiating; here we just attempt and then refresh chats
      final repo = InitiateChatRepositoryImpl(
        remoteDataSource: ChatRemoteDatasourceImpl(
          client: http.Client(),
          networkInfo: NetworkInfoImpl(
            InternetConnectionChecker.createInstance(),
          ),
        ),
        networkInfo: NetworkInfoImpl(
          InternetConnectionChecker.createInstance(),
        ),
      );

      final usecase = InitiateChat(repository: repo);
      await usecase(
        InitiateChatParams(token: event.token, recieverid: event.recieverid),
      );

      // After initiating, refresh the chat list regardless of the result to reflect any changes
      add(FetchChattedRequest(event.token));
    });
  }
}

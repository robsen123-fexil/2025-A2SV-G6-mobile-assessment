import 'package:assessment/features/chat/domain/repositories/chat_repositories.dart';
import 'package:assessment/features/chat/presentation/bloc/bloc/event.dart';
import 'package:assessment/features/chat/presentation/bloc/bloc/state.dart';
import 'package:bloc/bloc.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {

  final ChatRepositories chatRepositories;
  ChatBloc(
    this.chatRepositories,
  
  ) : super(UsersInitial()) {
    on<FetchUsersRequested>((event, emit) async {
      emit(UsersLoading());
      try {
        final result = await chatRepositories.getUsers(event.token);
        result.fold(
          (failure) => emit(UsersFailure(failure.toString())),
          (users) => emit(UsersLoaded(users)),
        );
      } catch (e) {
        emit(UsersFailure(e.toString()));
      }
    });

    on<FetchFriendsRequested>((event, emit) async {
      emit(ChatsLoading());
      try {
        final result = await chatRepositories.getMyChats(event.tokens);
        result.fold(
          (failure) => emit(ChatsFailure(failure.toString())),
          (chats) => emit(ChatsLoaded(chats)),
        );
      } catch (e) {
        emit(ChatsFailure(e.toString()));
      }
    });

    on<InitiateChatRequested>((event, emit) async {
      emit(InitiateChatLoading());
      try {
        final result = await chatRepositories.initateddata(
          event.tokens,
          event.receiverid,
        );
        result.fold(
          (failure) => emit(InitiateChatFailure(failure.toString())),
          (chat) => emit(InitiateChatLoaded(chat)),
        );
      } catch (e) {
        emit(InitiateChatFailure(e.toString()));
      }
    });
  }
}

import 'package:assessment/features/auth/domain/entities/user.dart';
import 'package:assessment/features/chat/domain/entities/user_list.dart' as entity;

abstract class AuthState {}
class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthSuccess extends AuthState {
  final User user;
  AuthSuccess(this.user);
}
class LoginSuccess extends AuthState {
  final String token;
  LoginSuccess(this.token);
}
class AuthFailure extends AuthState {
  final String message;
  AuthFailure(this.message);
}

class UsersLoading extends AuthState {}

class UsersLoaded extends AuthState {
  final List<entity.UserList> users;
  UsersLoaded(this.users);
}

class UsersFailure extends AuthState {
  final String message;
  UsersFailure(this.message);
}

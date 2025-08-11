import 'package:assessment/features/auth/domain/entities/user.dart';

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

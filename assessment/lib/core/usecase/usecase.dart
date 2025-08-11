import 'package:assessment/core/error/failure.dart';
import 'package:dartz/dartz.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams {}

class SignupParams {
  final String name;
  final String email;
  final String password;

  SignupParams({
    required this.name,
    required this.email,
    required this.password,
  });
}

class LoginParams {

  final String email;
  final String password;

  LoginParams({ required this.email, required this.password});
}

class InitiateChatParams {
  final String token;
  final String recieverid;

  InitiateChatParams({required this.token, required this.recieverid});
}
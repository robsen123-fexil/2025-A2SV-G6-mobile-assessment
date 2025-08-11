abstract class AuthEvent {}

class RegisterRequested extends AuthEvent {
  final String name;
  final String email;
  final String password;

  RegisterRequested(this.name, this.email, this.password);
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  LoginRequested({required this.email, required this.password});
}
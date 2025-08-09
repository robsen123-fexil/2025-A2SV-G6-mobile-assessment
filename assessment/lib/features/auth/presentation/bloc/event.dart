abstract class AuthEvent {}

class RegisterRequested extends AuthEvent {
  final String name;
  final String email;
  final String password;

  RegisterRequested(this.name, this.email, this.password);
}


abstract class UserEvent {}

class FetchUsersRequested extends UserEvent {
  final String token;
  FetchUsersRequested(this.token);
}

class FetchChattedRequest extends UserEvent {
  final String token;
  FetchChattedRequest(this.token);
}

class InitiateChatRequested extends UserEvent {
  final String token;
  final String recieverid;
  InitiateChatRequested(this.token, this.recieverid);
}

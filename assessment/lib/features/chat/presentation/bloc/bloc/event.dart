// abstract class UserEvent {}

// class FetchUsersRequested extends UserEvent {
//   final String token;
//   FetchUsersRequested(this.token);
// }

// class FetchChattedRequest extends UserEvent {
//   final String token;
//   FetchChattedRequest(this.token);
// }

// class InitiateChatRequested extends UserEvent {
//   final String token;
//   final String recieverid;
//   InitiateChatRequested(this.token, this.recieverid);
// }
// class GetChatMessageRequested extends UserEvent {
//   final String token;
//   final String chatid;
//   GetChatMessageRequested(this.token, this.chatid);
// }

abstract class ChatEvent {}

class FetchUsersRequested extends ChatEvent {
  final String token;

  FetchUsersRequested(this.token);
}

class FetchFriendsRequested extends ChatEvent {
  final String tokens;
  FetchFriendsRequested(this.tokens);
}

class InitiateChatRequested extends ChatEvent {
  final String tokens;
  final String receiverid;
  InitiateChatRequested(this.tokens, this.receiverid);
}

class FetchChattedRequest extends ChatEvent {
  final String tokens;
  final String chatid;
  FetchChattedRequest(this.tokens, this.chatid);
}

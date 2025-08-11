class ChatRoom {
  final String id; // Chat room ID
  final ChatUser user1; // First participant
  final ChatUser user2; // Second participant

  const ChatRoom({required this.id, required this.user1, required this.user2});
}

class ChatUser {
  final String id;
  final String name;
  final String email;

  const ChatUser({required this.id, required this.name, required this.email});
}


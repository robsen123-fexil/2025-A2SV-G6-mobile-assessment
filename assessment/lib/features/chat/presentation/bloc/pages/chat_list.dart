import 'dart:ui';

import 'package:assessment/features/auth/data/data_repositories/auth_repositories_imp.dart';
import 'package:assessment/features/chat/presentation/bloc/bloc/event.dart';
import 'package:assessment/features/chat/presentation/bloc/bloc/state.dart'
    as user_state;
import 'package:assessment/features/chat/presentation/bloc/bloc/bloc.dart';
import 'package:assessment/features/chat/domain/entities/chat_room.dart';
import 'package:assessment/features/chat/presentation/bloc/pages/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatScreen extends StatefulWidget {
  final String token;
  final AuthRepositoriesImp authRepository;
  const ChatScreen({
    super.key,
    required this.token,
    required this.authRepository,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();
    // Dispatch initial events on the provided ChatBloc
    final bloc = context.read<ChatBloc>();
    bloc.add(FetchUsersRequested(widget.token));
    bloc.add(FetchFriendsRequested(widget.token));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF4A90E2), Color(0xFF357ABD)],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // Header with search icon
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(Icons.search, color: Colors.white, size: 24),
                    ],
                  ),
                ),

                // Status section
                SizedBox(
                  height: 100,
                  child: BlocConsumer<ChatBloc, user_state.ChatState>(
                    listener: (context, state) {
                      // handle side effects if needed
                    },
                    buildWhen:
                        (prev, curr) =>
                            curr is user_state.UsersLoading ||
                            curr is user_state.UsersLoaded ||
                            curr is user_state.UsersFailure,
                    builder: (context, state) {
                      if (state is user_state.UsersLoading) {
                        return Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        );
                      }
                      if (state is user_state.UsersFailure) {
                        return Center(
                          child: Text(
                            state.message,
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      }
                      // Keep full user objects to access ids for initiating chats
                      List users = [];
                      if (state is user_state.UsersLoaded) {
                        users = state.users;
                      }
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        itemCount: users.length + 1, // +1 for 'My status'
                        itemBuilder: (context, index) {
                          final isMyStatus = index == 0;
                          final name =
                              isMyStatus ? 'My status' : users[index - 1].name;
                          return Container(
                            margin: EdgeInsets.only(right: 16),
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    if (!isMyStatus) {
                                      final receiverId = users[index - 1].id;
                                      context.read<ChatBloc>().add(
                                        InitiateChatRequested(
                                          widget.token,
                                          receiverId,
                                        ),
                                      );
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) => ChatDetailScreen(
                                                token: widget.token,
                                                recievername: name,
                                                recieverid: receiverId,
                                                chatid: chat.id,
                                              ),
                                        ),
                                      );
                                    }
                                  },
                                  child: Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border:
                                          isMyStatus
                                              ? Border.all(
                                                color: Colors.white,
                                                width: 2,
                                              )
                                              : Border.all(
                                                color: Colors.green,
                                                width: 2,
                                              ),
                                    ),
                                    child: CircleAvatar(
                                      radius: 28,
                                      backgroundColor: Colors.grey[300],
                                      child: Icon(
                                        Icons.person,
                                        color: Colors.grey[600],
                                        size: 28,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  name,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),

                SizedBox(height: 20),

                // Chats section
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: BlocConsumer<ChatBloc, user_state.ChatState>(
                      listener: (context, state) {},
                      buildWhen:
                          (prev, curr) =>
                              curr is user_state.ChatsLoading ||
                              curr is user_state.ChatsLoaded ||
                              curr is user_state.ChatsFailure,
                      builder: (context, state) {
                        if (state is user_state.ChatsLoading) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (state is user_state.ChatsFailure) {
                          return Center(child: Text(state.message));
                        }
                        // Use full chat objects to have access to receiver id and name
                        List<ChatRoom> chats = [];
                        if (state is user_state.ChatsLoaded) {
                          chats = state.chats;
                        }
                        return ListView.builder(
                          padding: EdgeInsets.only(top: 20),
                          itemCount: chats.length,
                          itemBuilder: (context, index) {
                            final chat = chats[index];
                            final name = chat.user2.name;
                            final receiverId = chat.user2.id;
                            return GestureDetector(
                              onTap: () {
                                context.read<ChatBloc>().add(
                                  InitiateChatRequested(
                                    widget.token,
                                    receiverId,
                                  ),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 25,
                                      backgroundColor: _getAvatarColor(index),
                                      child: Icon(
                                        Icons.person,
                                        color: Colors.white,
                                        size: 25,
                                      ),
                                    ),
                                    SizedBox(width: 15),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            name,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getAvatarColor(int index) {
    final colors = [
      Color(0xFF4A90E2),
      Color(0xFF50C878),
      Color(0xFFFF6B6B),
      Color(0xFFFFD93D),
      Color(0xFF6BCF7F),
      Color(0xFF4ECDC4),
    ];
    return colors[index % colors.length];
  }
}

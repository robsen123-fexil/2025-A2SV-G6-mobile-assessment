import 'dart:ui';

import 'package:assessment/features/chat/presentation/bloc/bloc/event.dart';
import 'package:assessment/features/chat/presentation/bloc/bloc/state.dart'
    as user_state;
import 'package:assessment/features/chat/presentation/bloc/bloc/bloc.dart';
import 'package:assessment/features/chat/domain/entities/chat_room.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatScreen extends StatefulWidget {
  final String token;
  const ChatScreen({super.key, required this.token});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final UserBloc _userBloc;
  @override
  void initState() {
    super.initState();
    _userBloc = UserBloc(user_state.UsersLoading())
      ..add(FetchUsersRequested(widget.token))
      ..add(FetchChattedRequest(widget.token));
  }

  @override
  void dispose() {
    _userBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _userBloc,
      child: Scaffold(
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
                  child: BlocBuilder<UserBloc, user_state.UserState>(
                    buildWhen: (prev, curr) =>
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
                      List<String> names = [];
                      if (state is user_state.UsersLoaded) {
                        names = state.users.map((e) => e.name).toList();
                      }
                      // Prepend 'My status'
                      final statusNames = ['My status', ...names];
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        itemCount: statusNames.length,
                        itemBuilder: (context, index) {
                          final isMyStatus = index == 0;
                          final name = statusNames[index];
                          return Container(
                            margin: EdgeInsets.only(right: 16),
                            child: Column(
                              children: [
                                Container(
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
                    child: BlocBuilder<UserBloc, user_state.UserState>(
                      buildWhen: (prev, curr) =>
                          curr is user_state.ChattedLoading ||
                          curr is user_state.ChattedLoaded ||
                          curr is user_state.ChattedFailure,
                      builder: (context, state) {
                        if (state is user_state.ChattedLoading) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (state is user_state.ChattedFailure) {
                          return Center(child: Text(state.message));
                        }
                        // Use full chat objects to have access to receiver id and name
                        List<ChatRoom> chats = [];
                        if (state is user_state.ChattedLoaded) {
                          chats = state.chats;
                        }
                        return ListView.builder(
                          padding: EdgeInsets.only(top: 20),
                          itemCount: chats.length,
                          itemBuilder: (context, index) {
                            final chat = chats[index];
                            final name = chat.user1.name;
                            final receiverId = chat.user1.id;
                            return GestureDetector(
                              onTap: () {
                                context.read<UserBloc>().add(
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

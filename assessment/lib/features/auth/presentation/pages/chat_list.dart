import 'dart:ui';

import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  final List<Map<String, dynamic>> statusUsers = [
    {'name': 'My status', 'avatar': 'assets/my_status.jpg', 'isMyStatus': true},
    {'name': 'Azil', 'avatar': 'assets/azil.jpg', 'isMyStatus': false},
    {'name': 'Marina', 'avatar': 'assets/marina.jpg', 'isMyStatus': false},
    {'name': 'Dean', 'avatar': 'assets/dean.jpg', 'isMyStatus': false},
    {'name': 'Max', 'avatar': 'assets/max.jpg', 'isMyStatus': false},
  ];

  final List<Map<String, dynamic>> chats = [
    {
      'name': 'Alex Linderson',
      'message': 'How are you today?',
      'time': '2 min ago',
      'avatar': 'assets/alex.jpg',
      'unread': true,
    },
    {
      'name': 'Team Align',
      'message': 'Don\'t forget to join the meeting',
      'time': '2 min ago',
      'avatar': 'assets/team.jpg',
      'unread': true,
    },
    {
      'name': 'John Abraham',
      'message': 'You\'re going to love it!',
      'time': '2 min ago',
      'avatar': 'assets/john_a.jpg',
      'unread': true,
    },
    {
      'name': 'Sabila Sayma',
      'message': 'Perfect! Thanks a lot 😊',
      'time': '2 min ago',
      'avatar': 'assets/sabila.jpg',
      'unread': true,
    },
    {
      'name': 'John Borino',
      'message': 'I\'ll send you the files now 😊',
      'time': '2 min ago',
      'avatar': 'assets/john_b.jpg',
      'unread': true,
    },
    {
      'name': 'Angel Dayna',
      'message': 'Wow, this is really epic',
      'time': '2 min ago',
      'avatar': 'assets/angel.jpg',
      'unread': true,
    },
  ];

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
                  children: [Icon(Icons.search, color: Colors.white, size: 24)],
                ),
              ),

              // Status section
              Container(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  itemCount: statusUsers.length,
                  itemBuilder: (context, index) {
                    final user = statusUsers[index];
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
                                  user['isMyStatus']
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
                                size: 30,
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            user['name'],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              SizedBox(height: 20),

              // Chat list
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: ListView.builder(
                    padding: EdgeInsets.only(top: 20),
                    itemCount: chats.length,
                    itemBuilder: (context, index) {
                      final chat = chats[index];
                      return Container(
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    chat['name'],
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    chat['message'],
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  chat['time'],
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[500],
                                  ),
                                ),
                                SizedBox(height: 8),
                                if (chat['unread'])
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: Color(0xFF4A90E2),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
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

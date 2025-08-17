import 'dart:convert';

import 'package:assessment/core/error/failure.dart';
import 'package:assessment/core/network_info/network_info.dart';
import 'package:assessment/features/chat/data/models/chat_message.dart';
import 'package:assessment/features/chat/data/models/chat_room_model.dart';
import 'package:assessment/features/chat/domain/entities/chat_message.dart';
import 'package:assessment/features/chat/domain/entities/chat_room.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

abstract class ChatRemoteDatasource {
  Future<Either<Failure, List<ChatRoom>>> getMyChats(String token);
  Future<Either<Failure, ChatRoom>> initiateChat(
    String token,
    String receiverId,
  );

  Future<Either<Failure, List<ChatMessage>>> getChatMessage(
    String token,
    String chatid,
  );
}

class ChatRemoteDatasourceImpl implements ChatRemoteDatasource {
  final http.Client client;
  final NetworkInfo networkInfo;

  ChatRemoteDatasourceImpl({required this.client, required this.networkInfo});

  @override
  Future<Either<Failure, List<ChatRoom>>> getMyChats(String token) async {
    try {
      final response = await client.get(
        Uri.parse(
          'https://g5-flutter-learning-path-be-tvum.onrender.com/api/v3/chats',
        ),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = jsonDecode(response.body);
        print(decoded);
        List<dynamic> list;
        if (decoded is List) {
          list = decoded;
        } else if (decoded is Map<String, dynamic> && decoded['data'] is List) {
          list = decoded['data'] as List<dynamic>;
        } else {
          return Left(ServerFailure('Invalid chats response format'));
        }
        // Debug print (optional)
        // print('Chats decoded list length: ${list.length}');
        try {
          final chats =
              list
                  .map((e) => ChatRoomModel.fromjson(e as Map<String, dynamic>))
                  .toList();
          return Right(chats);
        } catch (e) {
          return Left(ServerFailure('Failed to parse chats: $e'));
        }
      } else {
        // Try to surface server error message if present
        try {
          final err = jsonDecode(response.body);
          final msg =
              (err is Map && err['message'] is String)
                  ? err['message'] as String
                  : 'Failed to fetch chats (status ${response.statusCode})';
          return Left(ServerFailure(msg));
        } catch (_) {
          return Left(
            ServerFailure(
              'Failed to fetch chats (status ${response.statusCode})',
            ),
          );
        }
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ChatRoom>> initiateChat(
    String token,
    String receiverId,
  ) async {
    try {
      final response = await client.post(
        Uri.parse(
          'https://g5-flutter-learning-path-be-tvum.onrender.com/api/v3/chats',
        ),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          // Adjust the key if backend expects a different field name
          'userId': receiverId,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = jsonDecode(response.body);
        try {
          if (decoded is Map<String, dynamic>) {
            final obj = (decoded['data'] is Map<String, dynamic>)
                ? decoded['data'] as Map<String, dynamic>
                : decoded;
            return Right(ChatRoomModel.fromjson(obj));
          } else if (decoded is List && decoded.isNotEmpty) {
            final first = decoded.first;
            if (first is Map<String, dynamic>) {
              return Right(ChatRoomModel.fromjson(first));
            }
          }
          return Left(ServerFailure('Invalid initiate chat response format'));
        } catch (e) {
          return Left(ServerFailure('Failed to parse initiated chat: $e'));
        }
      } else {
        try {
          final err = jsonDecode(response.body);
          final msg =
              (err is Map && err['message'] is String)
                  ? err['message'] as String
                  : 'Failed to initiate chat (status ${response.statusCode})';
          return Left(ServerFailure(msg));
        } catch (_) {
          return Left(
            ServerFailure(
              'Failed to initiate chat (status ${response.statusCode})',
            ),
          );
        }
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ChatMessage>>> getChatMessage(
    String token,
    String chatid,
  ) async {
    try {
      if (await networkInfo.isConnected) {
        final response = await client.get(
          Uri.parse(
            'https://g5-flutter-learning-path-be-tvum.onrender.com/api/v3/chats/$chatid/messages',
          ),
          headers: {'Authorization': 'Bearer $token'},
        );
        if (response.statusCode == 200 || response.statusCode == 201) {
          final decoded = jsonDecode(response.body);
          if (decoded is List) {
            return Right(
              decoded.map((e) => ChatMessageModel.fromjson(e)).toList(),
            );
          } else if (decoded is Map<String, dynamic> &&
              decoded['data'] is List) {
            return Right(
              decoded['data'].map((e) => ChatMessageModel.fromjson(e)).toList(),
            );
          }
        }
        return Left(ServerFailure('Server Failed'));
      } else {
        return Left(NetworkFailure('No internet connection'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

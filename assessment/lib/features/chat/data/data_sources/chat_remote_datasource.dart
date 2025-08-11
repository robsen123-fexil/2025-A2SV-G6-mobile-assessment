import 'dart:convert';

import 'package:assessment/core/error/failure.dart';
import 'package:assessment/core/network_info/network_info.dart';
import 'package:assessment/features/chat/data/models/chat_room_model.dart';
import 'package:assessment/features/chat/domain/entities/chat_room.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

abstract class ChatRemoteDatasource {
  Future<Either<Failure, List<ChatRoom>>> getMyChats(String token);
  Future<Either<Failure, List<dynamic>>> initiateChat(
    String token,
    String receiverId,
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
          final chats = list
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
          final msg = (err is Map && err['message'] is String)
              ? err['message'] as String
              : 'Failed to fetch chats (status ${response.statusCode})';
          return Left(ServerFailure(msg));
        } catch (_) {
          return Left(ServerFailure('Failed to fetch chats (status ${response.statusCode})'));
        }
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<dynamic>>> initiateChat(
      String token, String receiverId) async {
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
          'receiverId': receiverId,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = jsonDecode(response.body);
        if (decoded is List) {
          return Right(decoded);
        } else if (decoded is Map<String, dynamic>) {
          // Some endpoints wrap data in a 'data' field
          final data = decoded['data'];
          if (data is List) {
            return Right(data);
          } else if (data != null) {
            return Right([data]);
          } else {
            // If it's a single object or another shape, return as a single-item list
            return Right([decoded]);
          }
        } else {
          return Left(ServerFailure('Invalid initiate chat response format'));
        }
      } else {
        try {
          final err = jsonDecode(response.body);
          final msg = (err is Map && err['message'] is String)
              ? err['message'] as String
              : 'Failed to initiate chat (status ${response.statusCode})';
          return Left(ServerFailure(msg));
        } catch (_) {
          return Left(ServerFailure('Failed to initiate chat (status ${response.statusCode})'));
        }
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

import 'dart:convert';

import 'package:assessment/core/error/failure.dart';
import 'package:assessment/core/network_info/network_info.dart';
import 'package:assessment/features/chat/data/models/user_list.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

abstract class GetAllUserRemoteDataSource {
  Future<Either<Failure, List<UserListModel>>> getUsers(String token);
}

class GetAllUserRemoteDataSourceImpl implements GetAllUserRemoteDataSource {
  final http.Client client;
  final NetworkInfo networkInfo;
  final baseurl =
      "https://g5-flutter-learning-path-be-tvum.onrender.com/api/v3/users";

  GetAllUserRemoteDataSourceImpl({required this.client, required this.networkInfo});

  @override
  Future<Either<Failure, List<UserListModel>>> getUsers(String token) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await client.get(
          Uri.parse(baseurl),
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        );
        if (response.statusCode == 200 || response.statusCode == 201) {
          // Debug: print body to understand the format
          // ignore: avoid_print
          final decoded = jsonDecode(response.body);
          List<dynamic> list;
          if (decoded is List) {
            list = decoded;
          } else if (decoded is Map<String, dynamic> && decoded['data'] is List) {
            list = decoded['data'] as List<dynamic>;
          } else {
            return Left(ServerFailure('Invalid users response format'));
          }
          return Right(list.map((json) => UserListModel.fromjson(json as Map<String, dynamic>)).toList());
        } else {
          // Try to extract message if present
          try {
            final err = jsonDecode(response.body);
            final msg = (err is Map && err['message'] is String)
                ? err['message'] as String
                : 'Failed to load users (status ${response.statusCode})';
            return Left(ServerFailure(msg));
          } catch (_) {
            return Left(ServerFailure('Failed to load users (status ${response.statusCode})'));
          }
        }
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }
}
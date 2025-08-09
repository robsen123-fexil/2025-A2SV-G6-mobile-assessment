import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:assessment/core/error/failure.dart';
import 'package:assessment/core/network_info/network_info.dart';
import 'package:assessment/features/auth/data/models/auth_models.dart';
import 'package:assessment/features/auth/domain/entities/user.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

abstract class AuthRemoteDataSource {
  Future<Either<Failure, String>> login(String email, String password);

  Future<Either<Failure, User>> register(
    String name,
    String email,
    String password,
  );
  Future<Unit> logout(String token);
}

class AuthRemoteDatasourceImpl implements AuthRemoteDataSource {
  final http.Client client;
  final NetworkInfo networkInfo;
  final baseurl =
      "https://g5-flutter-learning-path-be-tvum.onrender.com/api/v3/auth/login";
  AuthRemoteDatasourceImpl({required this.client, required this.networkInfo});

  @override
  Future<Either<Failure, String>> login(String email, String password) async {
    if (await networkInfo.isConnected) {
      print(email);
      try {
        final response = await client.post(
          Uri.parse('$baseurl'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'email': email, 'password': password}),
        );
        print('+++++++++++++++++++++++++');
        print(response.body);
        if (response.statusCode == 200 || response.statusCode == 201) {
          print(response.statusCode);
          final json = jsonDecode(response.body);
          if (json['data'] != null && json['data']['access_token'] != null) {
            return Right(json['data']['access_token']);
          } else {
            return Left(
              ServerFailure('Invalid response format: missing access token'),
            );
          }
        } else {
          final error = jsonDecode(response.body);
          return Left(ServerFailure(error['message'] ?? 'Failed to login'));
        }
      } catch (e) {
        return Left(ServerFailure('Network error: ${e.toString()}'));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Unit> logout(String token) {
    // TODO: implement logout
    throw UnimplementedError();
  }


@override
  Future<Either<Failure, User>> register(
    String name,
    String email,
    String password,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        print('Attempting to register user: $email');
        final response = await client
            .post(
              Uri.parse(
                "https://g5-flutter-learning-path-be-tvum.onrender.com/api/v3/auth/register",
              ),
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json', // Add this line
              },
              body: jsonEncode({
                'name': name,
                'email': email,
                'password': password,
              }),
            )
            .timeout(Duration(seconds: 10)); // Add timeout

        print('Register API Response:');
        print('Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');

        if (response.statusCode == 200 || response.statusCode == 201) {
          try {
            final jsonMap = json.decode(response.body);
            if (jsonMap is! Map<String, dynamic>) {
              return Left(ServerFailure('Invalid response format'));
            }
            return Right(UserModel.fromjson(jsonMap));
          } catch (e) {
            return Left(ServerFailure('Failed to parse response: $e'));
          }
        } else {
          try {
            final error = jsonDecode(response.body);
            return Left(
              ServerFailure(
                error['message'] ??
                    'Registration failed with status ${response.statusCode}',
              ),
            );
          } catch (_) {
            return Left(
              ServerFailure(
                'Registration failed with status ${response.statusCode}',
              ),
            );
          }
        }
      } on SocketException catch (e) {
        print('SocketException: $e');
        return Left(NetworkFailure('Network error: ${e.message}'));
      } on TimeoutException catch (e) {
        print('TimeoutException: $e');
        return Left(NetworkFailure('Request timed out'));
      } catch (e) {
        print('Unexpected error: $e');
        return Left(ServerFailure('Unexpected error: $e'));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }
}

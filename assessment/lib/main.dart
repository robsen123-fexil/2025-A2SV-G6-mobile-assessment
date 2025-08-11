import 'package:assessment/core/network_info/network_info.dart';
import 'package:assessment/features/auth/data/data_repositories/auth_repositories_imp.dart';
import 'package:assessment/features/auth/data/datasources/auth_datasource.dart';
import 'package:assessment/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:assessment/features/auth/presentation/pages/splash_screen.dart';
import 'package:assessment/features/chat/presentation/bloc/pages/chat_list.dart';
import 'package:assessment/features/chat/presentation/bloc/pages/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

Future<String?> printAccessToken() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('access_token');
  if (token != null) {
    print(token);
  } else {
    print('No access token found');
  }
  return token;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final networkInfo = NetworkInfoImpl(
      InternetConnectionChecker.createInstance(),
    );

    final authRepository = AuthRepositoriesImp(
      remoteDataSource: AuthRemoteDatasourceImpl(
        client: http.Client(),
        networkInfo: networkInfo,
      ),
      networkInfo: networkInfo,
      localDataSource: AuthLocalDataSourceImpl(),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChatDetailScreen(),
    );
  }
}

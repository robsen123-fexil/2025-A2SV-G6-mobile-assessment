import 'package:assessment/core/network_info/network_info.dart';
import 'package:assessment/features/auth/data/data_repositories/auth_repositories_imp.dart';
import 'package:assessment/features/auth/data/datasources/auth_datasource.dart';
import 'package:assessment/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:assessment/features/auth/domain/domain_repositories/auth_repositories.dart';
import 'package:assessment/features/auth/presentation/pages/login_page.dart';
import 'package:assessment/features/auth/presentation/pages/splash_screen.dart';
import 'package:assessment/features/chat/domain/repositories/chat_repositories.dart';
import 'package:assessment/features/chat/presentation/bloc/bloc/bloc.dart';
import 'package:assessment/features/chat/presentation/bloc/pages/chat_list.dart';
import 'package:assessment/features/chat/presentation/bloc/pages/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:assessment/features/chat/data/data_sources/chat_remote_datasource.dart';
import 'package:assessment/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:assessment/features/chat/data/data_sources/user_list_data_source.dart';
import 'package:assessment/features/chat/data/repositories/user_list_repositoryimpl.dart';
import 'package:assessment/features/chat/data/repositories/initiate_chat_repository_impl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Common clients and services

  // Chat dependencies
  final ChatRepositories chatRepo;
  final AuthRepositories authRepo;

  runApp(MyApp(authRepositories: authRepo, chatRepositories: chatRepo));
}

class MyApp extends StatelessWidget {
  final AuthRepositories authRepositories;
  final ChatRepositories chatRepositories;

  const MyApp({
    super.key,
    required this.authRepositories,
    required this.chatRepositories,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (_) => ChatBloc(chatRepositories))],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(authRepository: authRepositories),
      ),
    );
  }
}

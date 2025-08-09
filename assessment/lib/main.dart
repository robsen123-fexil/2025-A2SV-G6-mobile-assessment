import 'package:assessment/core/error/failure.dart';
import 'package:assessment/core/network_info/network_info.dart';
import 'package:assessment/core/usecase/usecase.dart';
import 'package:assessment/features/auth/data/data_repositories/auth_repositories_imp.dart';
import 'package:assessment/features/auth/data/datasources/auth_datasource.dart';
import 'package:assessment/features/auth/domain/domain_usecase/login_usecase.dart';
import 'package:assessment/features/auth/domain/domain_usecase/signup_usecase.dart';
import 'package:assessment/features/auth/presentation/pages/chat_list.dart';
import 'package:assessment/features/auth/presentation/pages/chat_screen.dart';
import 'package:assessment/features/auth/presentation/pages/login_page.dart';
import 'package:assessment/features/auth/presentation/pages/register_page.dart';
import 'package:assessment/features/auth/presentation/pages/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // // Initialize dependencies
  // final networkChecker = await InternetConnectionChecker.createInstance();
  // final networkInfo = NetworkInfoImpl(networkChecker);
  // final client = http.Client();

  // final remoteDataSource = AuthRemoteDatasourceImpl(
  //   client: client,
  //   networkInfo: networkInfo,
  // );

  // final repository = AuthRepositoriesImp(
  //   remoteDataSource: remoteDataSource,
  //   networkInfo: networkInfo,
  // );

  // final registerusecase = SignupUsecase(repositories:repository);

  // // Test login and print results to terminal
  // print('=== Testing Register API ===');
 

  // try {
  //   final result = await registerusecase(
  //     SignupParams(name: 'sjksksjkksj', email: 'email1bjkhj2skjskljs412@gmail.com', password: 'passwoe124'),
  //   );

  //   result.fold(
  //     (failure) {
  //       print(' Login Failed');
  //       print('Error: ${failure.message}');
  //       print('Type: ${failure.runtimeType}');
  //     },
  //     (token) {
  //       print(' Login Successful');
  //       print('Token: $token');
  //     },
  //   );
  // } catch (e, stackTrace) {
  //   print('❌ Exception occurred during login');
  //   print('Error: $e');
  //   print('Stack trace: $stackTrace');
  // } finally { 
  //   // Close the HTTP client when done
  //   client.close();
  //   print('\n=== Test completed ===');
  // }


  runApp(const MyApp());
}   

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
       home: SignUpScreen(
        authRepository: AuthRepositoriesImp(remoteDataSource: AuthRemoteDatasourceImpl(client: http.Client(), networkInfo: NetworkInfoImpl(InternetConnectionChecker.createInstance())), networkInfo: NetworkInfoImpl(InternetConnectionChecker.createInstance())),),
    );
  }
}

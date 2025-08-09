import 'package:assessment/features/auth/domain/domain_repositories/auth_repositories.dart';
import 'package:assessment/features/auth/presentation/bloc/bloc.dart';
import 'package:assessment/features/auth/presentation/bloc/event.dart';
import 'package:assessment/features/auth/presentation/bloc/state.dart';
import 'package:assessment/features/auth/presentation/pages/chat_list.dart';
import 'package:assessment/features/auth/presentation/widgets/texfieild.dart';
import 'package:assessment/features/auth/presentation/widgets/textbutton.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatelessWidget {
  final AuthRepositories authRepository;

  const LoginScreen({Key? key, required this.authRepository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthBloc(authRepository),
      child: _LoginView(),
    );
  }
}

class _LoginView extends StatefulWidget {
  @override
  __LoginViewState createState() => __LoginViewState();
}

class __LoginViewState extends State<_LoginView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            _showMessage('Login successful');
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ChatScreen()),
            );
          } else if (state is AuthFailure) {
            _showMessage('Login failed: ${state.message}');
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            final isLoading = state is AuthLoading;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Login',
                          style: GoogleFonts.caveatBrush(
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w900,
                            fontSize: 48,
                            color: const Color.fromARGB(255, 29, 17, 193),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    Padding(
                      padding: const EdgeInsets.only(left: 24),
                      child: Text('Email'),
                    ),
                    textfield(
                      controller: _emailController,
                      hintText: 'ex: jon.smith@email.com',
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 24, top: 20),
                      child: Text('Password'),
                    ),
                    textfield(
                      controller: _passwordController,
                      hintText: '*******',
                      obsecure: true,
                    ),

                    SizedBox(height: 20),

                    Textbutton('SIGN IN', () {
                      final email = _emailController.text.trim();
                      final password = _passwordController.text.trim();

                      if (email.isEmpty || password.isEmpty) {
                        _showMessage('Please fill all fields');
                        return;
                      }

                      context.read<AuthBloc>().add(
                        LoginRequested(email: email, password: password),
                      );
                    }, isLoading: isLoading),

                    SizedBox(height: 20),

                    Text.rich(
                      TextSpan(
                        text: 'DON\'T YOU HAVE AN ACCOUNT? ',
                        style: TextStyle(color: Colors.black),
                        children: [
                          TextSpan(
                            text: 'SIGN UP',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer:
                                TapGestureRecognizer()
                                  ..onTap = () {
                                    // Navigate to your SignUpScreen here
                                    Navigator.pushNamed(context, '/signup');
                                  },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

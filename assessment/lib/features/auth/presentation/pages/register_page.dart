import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:assessment/features/auth/domain/domain_repositories/auth_repositories.dart';
import 'package:assessment/features/auth/presentation/bloc/bloc.dart';
import 'package:assessment/features/auth/presentation/bloc/event.dart';
import 'package:assessment/features/auth/presentation/bloc/state.dart';
import 'package:assessment/features/auth/presentation/pages/login_page.dart';
import 'package:assessment/features/auth/presentation/widgets/texfieild.dart';
import 'package:assessment/features/auth/presentation/widgets/textbutton.dart';

class SignUpScreen extends StatelessWidget {
  final AuthRepositories authRepository;

  const SignUpScreen({Key? key, required this.authRepository})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthBloc(authRepository),
      child: _SignUpView(),
    );
  }
}

class _SignUpView extends StatefulWidget {
  @override
  __SignUpViewState createState() => __SignUpViewState();
}

class __SignUpViewState extends State<_SignUpView> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _termsAccepted = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
            _showMessage(
              'Registration successful! Welcome, ${state.user.name}',
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => LoginScreen(
                  authRepository: context.read<AuthBloc>().authRepository,
                ),
              ),
            );
          } else if (state is AuthFailure) {
            _showMessage('Registration failed: ${state.message}');
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
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.arrow_back),
                          color: Colors.blue,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue, width: 2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'ECOM',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 30),
                    Text(
                      'Create your account',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),

                    Padding(
                      padding: EdgeInsets.only(left: 24),
                      child: Text('Name'),
                    ),
                    SizedBox(height: 10),
                    textfield(
                      controller: _nameController,
                      hintText: 'Enter your name',
                    ),

                    Padding(
                      padding: EdgeInsets.only(left: 24),
                      child: Text('Email'),
                    ),
                    textfield(
                      controller: _emailController,
                      hintText: 'ex: jon.smith@email.com',
                    ),

                    Padding(
                      padding: EdgeInsets.only(left: 24),
                      child: Text('Password'),
                    ),
                    textfield(
                      controller: _passwordController,
                      hintText: '*******',
                      obsecure: true,
                    ),

                    Padding(
                      padding: EdgeInsets.only(left: 24),
                      child: Text('Confirm Password'),
                    ),
                    textfield(
                      controller: _confirmPasswordController,
                      hintText: '*******',
                      obsecure: true,
                    ),

                    Row(
                      children: [
                        Checkbox(
                          value: _termsAccepted,
                          onChanged: (value) {
                            setState(() {
                              _termsAccepted = value ?? false;
                            });
                          },
                        ),
                        Text('I understand the terms & policy.'),
                      ],
                    ),
                    SizedBox(height: 20),

                    // Your custom button with loading indicator
                    Textbutton('SIGN UP', () {
                      if (!_termsAccepted) {
                        _showMessage('Please accept the terms & policy');
                        return;
                      }

                      final name = _nameController.text.trim();
                      final email = _emailController.text.trim();
                      final password = _passwordController.text.trim();
                      final confirmPassword =
                          _confirmPasswordController.text.trim();

                      if (name.isEmpty ||
                          email.isEmpty ||
                          password.isEmpty ||
                          confirmPassword.isEmpty) {
                        _showMessage('Please fill all fields');
                        return;
                      }

                      if (password != confirmPassword) {
                        _showMessage('Passwords do not match');
                        return;
                      }

                      context.read<AuthBloc>().add(
                        RegisterRequested(name, email, password),
                      );
                    }, isLoading: isLoading),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Have an account? '),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(
                                  authRepository:
                                      context.read<AuthBloc>().authRepository,
                                ),
                              ),
                            );
                          },
                          child: Text('SIGN IN'),
                        ),
                      ],
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

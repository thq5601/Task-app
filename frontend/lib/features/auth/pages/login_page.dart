import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/auth/cubit/auth_cubit.dart';
import 'package:frontend/features/auth/pages/signup_page.dart';
import 'package:frontend/features/home/page/home_page.dart';
import 'package:frontend/widget/reusable_button.dart';
import 'package:frontend/widget/reusable_textform.dart';

class LoginPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const LoginPage());
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  void _loginValidate() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().login(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.error)));
          } else if (state is AuthLoggedIn) {
            Navigator.pushAndRemoveUntil(
              context,
              HomePage.route(),
              (_) => false,
            );
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Login.',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Email field
                    ReusableTextForm(
                      hintText: 'Email',
                      controller: emailController,
                      prefixIcon: Icons.email,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email address';
                        }

                        String emailPattern =
                            r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
                        RegExp regExp = RegExp(emailPattern);

                        if (!regExp.hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    ReusableTextForm(
                      hintText: 'Password',
                      controller: passwordController,
                      isPassword: true,
                      prefixIcon: Icons.lock,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password is required';
                        }

                        if (value.length < 8 ||
                            value.length > 32 ||
                            !RegExp(r'[A-Z]').hasMatch(value) ||
                            !RegExp(r'[a-z]').hasMatch(value) ||
                            !RegExp(r'[0-9]').hasMatch(value) ||
                            !RegExp(
                              r'[!@#$%^&*(),.?":{}|<>]',
                            ).hasMatch(value)) {
                          return 'Password incorrect';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 16),
                    ReusableButton(
                      text: 'Login',
                      backgroundColor: Colors.black,
                      onPressed: _loginValidate,
                    ),
                    const SizedBox(height: 16),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(SignupPage.route());
                      },
                      child: RichText(
                        text: TextSpan(
                          style: Theme.of(context).textTheme.titleMedium,
                          text: 'Don\'t have an account? ',
                          children: [
                            const TextSpan(
                              text: 'Sign Up',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

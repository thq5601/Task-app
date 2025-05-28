import 'package:flutter/material.dart';
import 'package:frontend/widget/reusable_button.dart';
import 'package:frontend/widget/reusable_textform.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      //
    }
    ;
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Sign Up.',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 32),

                // Name field
                ReusableTextForm(
                  hintText: 'Full Name',
                  controller: nameController,
                  prefixIcon: Icons.person,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Full name is required';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

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
                SizedBox(height: 16),
                ReusableTextForm(
                  hintText: 'Password',
                  controller: passwordController,
                  isPassword: true,
                  prefixIcon: Icons.lock,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password is required';
                    }

                    if (value.length < 8) {
                      return 'Password must be at least 8 characters long';
                    }

                    if (value.length > 32) {
                      return 'Password must be less than 32 characters';
                    }

                    // Check for at least one uppercase letter
                    if (!RegExp(r'[A-Z]').hasMatch(value)) {
                      return 'Password must contain at least one uppercase letter';
                    }

                    // Check for at least one lowercase letter
                    if (!RegExp(r'[a-z]').hasMatch(value)) {
                      return 'Password must contain at least one lowercase letter';
                    }

                    // Check for at least one digit
                    if (!RegExp(r'[0-9]').hasMatch(value)) {
                      return 'Password must contain at least one number';
                    }

                    // Check for at least one special character
                    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
                      return 'Password must contain at least one special character';
                    }

                    return null;
                  },
                ),

                SizedBox(height: 16),
                ReusableButton(
                  text: 'Sign Up',
                  backgroundColor: Colors.black,
                  onPressed: _submitForm,
                ),
                SizedBox(height: 16),
                RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.titleMedium,
                    text: 'Already have an account? ',
                    children: [
                      TextSpan(
                        text: 'Sign In',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ignore_for_file: file_names, deprecated_member_use

import 'dart:ui';
import 'package:blue_art_mad2/components/dialog_box.dart';
import 'package:blue_art_mad2/components/loading_box.dart';
import 'package:blue_art_mad2/network/auth/register.dart';
import 'package:blue_art_mad2/routes/app_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _unameIN = TextEditingController();
  final TextEditingController _emailIN = TextEditingController();
  final TextEditingController _passIN = TextEditingController();
  final TextEditingController _confirmIN = TextEditingController();

  bool _showPassword = true;

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    final username = _unameIN.text.trim();
    final email = _emailIN.text.trim();
    final password = _passIN.text.trim();
    final confirmPass = _confirmIN.text.trim();

    try {
      showLoadingDialog(context, 'Signing in...');
      final result = await AuthRegister(ref).register(username, email, password, confirmPass);

      if (!mounted) return;
      Navigator.pop(context);

      final statusCode = result['statusCode'];
      final data = result['body'];

      if (statusCode == 200) {
        Navigator.pushReplacementNamed(context, AppRoute.layout);
      } else if (statusCode == 422) {
        showCustomDialog(context, 'Error', 'Email already taken...');
      } else {
        showCustomDialog(context, 'Error', data['message']);
      }
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context);
      showCustomDialog(context, 'Network', '$e');
      showCustomDialog(context, 'Network', 'Internal network error...');
    }
  }

  @override
  void dispose() {
    _unameIN.dispose();
    _emailIN.dispose();
    _passIN.dispose();
    _confirmIN.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration(String label, {Widget? suffixIcon}) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      errorStyle: const TextStyle(
        color: Color.fromARGB(255, 255, 170, 170),
        fontSize: 13,
      ),
      filled: true,
      fillColor: Colors.white.withOpacity(0.05),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      suffixIcon: suffixIcon,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final formWidth = screenWidth > 600 ? 400.0 : screenWidth * 0.85;

    return Scaffold(
      body: Stack(
        children: [
          // Background
          SizedBox.expand(
            child: Image.asset('assets/loginPageBg.gif', fit: BoxFit.cover),
          ),
          Container(color: Colors.black.withOpacity(0.4)),

          // Form
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                    child: Container(
                      width: formWidth,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Create Account",
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                            ),
                            const SizedBox(height: 30),

                            // Username
                            TextFormField(
                              controller: _unameIN,
                              style: const TextStyle(color: Colors.white),
                              decoration: _inputDecoration("Username"),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter username";
                                } else if (value.length < 3) {
                                  return "Username must be at least 3 characters";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // Email
                            TextFormField(
                              controller: _emailIN,
                              keyboardType: TextInputType.emailAddress,
                              style: const TextStyle(color: Colors.white),
                              decoration: _inputDecoration("Email"),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter email";
                                } else if (!value.contains('@')) {
                                  return "Enter a valid email";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // Password
                            TextFormField(
                              controller: _passIN,
                              obscureText: _showPassword,
                              style: const TextStyle(color: Colors.white),
                              decoration: _inputDecoration(
                                "Password",
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _showPassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Colors.white70,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _showPassword = !_showPassword;
                                    });
                                  },
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter password";
                                } else if (value.length < 6) {
                                  return "Password must be at least 6 characters";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // Confirm Password
                            TextFormField(
                              controller: _confirmIN,
                              obscureText: _showPassword,
                              style: const TextStyle(color: Colors.white),
                              decoration: _inputDecoration("Confirm Password"),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please confirm password";
                                } else if (value != _passIN.text) {
                                  return "Passwords do not match";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),

                            // Already have account? Login
                            RichText(
                              text: TextSpan(
                                style: const TextStyle(color: Colors.white70),
                                children: [
                                  const TextSpan(text: "Already have an account? "),
                                  TextSpan(
                                    text: "Login!",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                      color: Colors.white,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.pushReplacementNamed(
                                          context,
                                          '/',
                                        );
                                      },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 25),

                            // Register Button
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _register,
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  backgroundColor:
                                      Colors.blueAccent.withOpacity(0.9),
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text(
                                  'Register',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:ui';
import 'package:blue_art_mad2/network/auth/login.dart';
import 'package:blue_art_mad2/components/dialog_box.dart';
import 'package:blue_art_mad2/components/loading_box.dart';
import 'package:blue_art_mad2/routes/app_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginPage extends ConsumerStatefulWidget  {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailIN = TextEditingController();
  final TextEditingController _passIN = TextEditingController();
  bool _showPassword = true;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    final email = _emailIN.text.trim();
    final password = _passIN.text.trim();

    try {
      showLoadingDialog(context, 'Signing in...');
      final result = await AuthLogin(ref).login(email, password);

      if (!mounted) return;
      Navigator.pop(context);

      final statusCode = result['statusCode'];
      final data = result['body'];

      if (statusCode == 200) {
        Navigator.pushReplacementNamed(context, AppRoute.layout); 
      } else if (statusCode == 401) {
        showCustomDialog(context, 'Error', data['message']);
      } else if (statusCode == 403) {
        showCustomDialog(context, 'Unauthorized', data['message']);
      }
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context);
      showCustomDialog(context, 'Network', 'Internal network error...');
    }
  }

  @override
  void dispose() {
    _emailIN.dispose();
    _passIN.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final loginFormWidth = screenWidth > 600 ? 400.0 : screenWidth * 0.85;

    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset('assets/loginPageBg.gif', fit: BoxFit.cover),
          ),
          Container(color: Colors.black.withOpacity(0.4)),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                    child: Container(
                      width: loginFormWidth,
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
                              "BlueArt Login",
                              style: Theme.of(context).textTheme.headlineMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                            ),
                            const SizedBox(height: 30),
                            TextFormField(
                              controller: _emailIN,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                labelText: "Email",
                                labelStyle: const TextStyle(
                                  color: Colors.white70,
                                ),
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
                              ),
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
                            TextFormField(
                              controller: _passIN,
                              obscureText: _showPassword,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                labelText: "Password",
                                labelStyle: const TextStyle(
                                  color: Colors.white70,
                                ),
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
                            const SizedBox(height: 20),
                            RichText(
                              text: TextSpan(
                                style: const TextStyle(color: Colors.white70),
                                children: [
                                  const TextSpan(text: "No account? "),
                                  TextSpan(
                                    text: "Register!",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                      color: Colors.white,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.pushReplacementNamed(
                                          context,
                                          '/register',
                                        );
                                      },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 25),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _login,
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  backgroundColor: Colors.blueAccent
                                      .withOpacity(0.9),
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text(
                                  'Login',
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

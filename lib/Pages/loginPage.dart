import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final Function(int) onItemTapped;
  const LoginPage({super.key, required this.onItemTapped});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailIN = TextEditingController();
  final TextEditingController _passIN = TextEditingController();

  // State Values
  bool _showPassword = true;

  void _login() {
    if (_formKey.currentState!.validate()) {
      // Navicating to the home page
      widget.onItemTapped(0);
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
    final loginFormWidth = screenWidth > 600 ? 400.0 : screenWidth * 0.8;

    return Stack(
      children: [
        // Adding the Background img
        SizedBox.expand(
          child: Image.asset('assets/loginPageBg.gif', fit: BoxFit.cover),
        ),

        Container(color: Colors.black.withOpacity(0.5)),

        Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Container(
                width: loginFormWidth,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  boxShadow: [BoxShadow(blurRadius: 6, offset: Offset(0, 3))],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Login",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      SizedBox(height: 30),
                  
                      // Getting the user Email and the validator
                      TextFormField(
                        controller: _emailIN,
                        decoration: InputDecoration(
                          labelText: "Email",
                          labelStyle: Theme.of(context).textTheme.labelMedium,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please Enter Email!!";
                          } else if (!value.contains('@')) {
                            return "Enter a Valid Email!!";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                  
                      // Getting the user pass and the validator
                      TextFormField(
                        controller: _passIN,
                        obscureText: _showPassword,
                        decoration: InputDecoration(
                          labelText: "Password",
                          labelStyle: Theme.of(context).textTheme.labelMedium,
                          suffixIcon: IconButton(
                            icon: Icon(_showPassword ? Icons.visibility_off : Icons.visibility, color: Theme.of(context).colorScheme.onPrimary),
                            onPressed: () {
                              setState(() {
                                _showPassword = !_showPassword;
                              });
                            }
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please Enter Password!!";
                          } else if (value.length < 6) {
                            return "Password should be atleast 6 characters!!";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                  
                      // User Register Page Nav (Link)
                      RichText(
                        text: TextSpan(
                          style: Theme.of(context).textTheme.bodySmall,
                          children: [
                            const TextSpan(text: "No Account? "),
                            TextSpan(
                              text: "Register!",
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer:
                                  TapGestureRecognizer()
                                    ..onTap = () {
                                      widget.onItemTapped(3);
                                    },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                  
                      // Login Btn
                      ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          foregroundColor: Theme.of(context).colorScheme.onPrimary,
                        ),
                        child: Text('Login'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

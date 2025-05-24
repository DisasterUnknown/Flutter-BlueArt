import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegisterPage extends StatefulWidget {
  final Function(int) onItemTapped;
  const RegisterPage({super.key, required this.onItemTapped});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _unameIN = TextEditingController();
  final TextEditingController _emailIN = TextEditingController();
  final TextEditingController _passIN = TextEditingController();

  final TextEditingController _contactIN = TextEditingController();
  final TextEditingController _addressIN = TextEditingController();
  final TextEditingController _roleSelect = TextEditingController();

  // State Values
  String _selectedRole = 'Customer';
  bool _showPassword = false;

  void _register() {
    if (_formKey.currentState!.validate()) {
      // Navicating to the home page
      widget.onItemTapped(0);
    }
  }

  // Cleaning the data from the memory
  @override
  void dispose() {
    _unameIN.dispose();
    _emailIN.dispose();
    _passIN.dispose();
    _contactIN.dispose();
    _addressIN.dispose();
    _roleSelect.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final registerFormWidth = screenWidth > 600 ? 400.0 : screenWidth * 0.8;

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
                width: registerFormWidth,
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
                    children: [
                      // Register Page Title
                      Text(
                        "Register",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      SizedBox(height: 20),
                  
                      // Username input field
                      TextFormField(
                        controller: _unameIN,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          labelStyle: Theme.of(context).textTheme.labelMedium,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Your Username!!';
                          } else if (value.length < 3) {
                            return 'Username Must be at Least 3 Characters Long!!';
                          }
                          return null;
                        },
                      ),
                  
                      // Email input field
                      TextFormField(
                        controller: _emailIN,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: Theme.of(context).textTheme.labelMedium,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Your Email!!';
                          } else if (!value.contains('@')) {
                            return 'Enter a Valid Email!!';
                          }
                          return null;
                        },
                      ),
                  
                      // Password input field
                      TextFormField(
                        controller: _passIN,
                        obscureText: !_showPassword,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: Theme.of(context).textTheme.labelMedium,
                          suffixIcon: IconButton(
                            icon: Icon(_showPassword ? Icons.visibility : Icons.visibility_off, color: Theme.of(context).colorScheme.onPrimary),
                            onPressed: () {
                              setState(() {
                                _showPassword = !_showPassword;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Your Password!!';
                          } else if (value.length < 6) {
                            return 'Password Must be at Least 6 Characters Long!!';
                          }
                          return null;
                        },
                      ),
                  
                      // Contact Number input field
                      if (_selectedRole == 'Seller') ...[
                        TextFormField(
                          controller: _contactIN,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            TextInputFormatter.withFunction((oldValue, newValue,) {
                              final disgitsOnly = newValue.text.replaceAll(
                                RegExp(r'[^0-9]'),
                                '',
                              );
                              final buffer = StringBuffer();
                  
                              for (
                                int i = 0;
                                i < disgitsOnly.length && i < 10;
                                i++
                              ) {
                                if (i == 3 || i == 6) buffer.write(' ');
                                buffer.write(disgitsOnly[i]);
                              }
                  
                              return TextEditingValue(
                                text: buffer.toString(),
                                selection: TextSelection.collapsed(
                                  offset: buffer.length,
                                ),
                              );
                            }),
                          ],
                          decoration: InputDecoration(
                            labelText: 'Contact Number',
                            labelStyle: Theme.of(context).textTheme.labelMedium,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter your Contact Number!!';
                            } else if (value.length < 12) {
                              return 'Contact Number Must be at Least 10 Digits Long!!';
                            }
                            return null;
                          },
                        ),
                      ],
                  
                      // Address input field
                      if (_selectedRole == 'Seller') ...[
                        TextFormField(
                          controller: _addressIN,
                          decoration: InputDecoration(
                            labelText: 'Address',
                            labelStyle: Theme.of(context).textTheme.labelMedium,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter Your Address!!';
                            } else if (value.length < 5) {
                              return 'Address Must be at Least 5 Characters Long!!';
                            }
                            return null;
                          },
                        ),
                      ],
                  
                      // Role Selection Dropdown
                      DropdownButtonFormField(
                        value: _selectedRole,
                        decoration: InputDecoration(
                          labelText: 'Select Role',
                          labelStyle: Theme.of(context).textTheme.labelMedium,
                        ),
                        items:
                            ['Customer', 'Seller'].map((role) {
                              return DropdownMenuItem(
                                value: role,
                                child: Text(role, style: Theme.of(context).textTheme.bodyLarge,),
                              );
                            }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedRole = value!;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Select a Role!!';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                  
                      // User Register Page Nav (Link)
                      ElevatedButton(
                        onPressed: _register,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          foregroundColor:
                              Theme.of(context).colorScheme.onPrimary,
                        ),
                        child: Text('Register'),
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

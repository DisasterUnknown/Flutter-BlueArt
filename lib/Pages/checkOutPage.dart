import 'dart:async';
import 'package:blue_art_mad2/theme/systemColorManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CheckOutPage extends StatefulWidget {
  const CheckOutPage({super.key});

  @override
  State<CheckOutPage> createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneIN = TextEditingController();
  final TextEditingController _addressIN = TextEditingController();
  final TextEditingController _cardHolderNameIN = TextEditingController();
  final TextEditingController _cardNumberIN = TextEditingController();
  final TextEditingController _cvcIN = TextEditingController();
  bool _showMsg = false;
  String _selectedShippingMethod = "Standard";

  // CheckOut Function
  void _checkOut() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _showMsg = true;
        // CartList = [];
      });
    }

    Timer(Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showMsg = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _addressIN.dispose();
    _cardHolderNameIN.dispose();
    _cardNumberIN.dispose();
    _cvcIN.dispose();
    _phoneIN.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final checkOutFormWidth = screenWidth > 600 ? 400.0 : screenWidth * 0.8;

    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Container(
            width: checkOutFormWidth,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border.all(color: CustomColors.getThemeColor(context, 'surfaceContainerHighest'), width: 1.5),
              borderRadius: BorderRadius.circular(12),
              color: CustomColors.getThemeColor(context, 'surfaceContainerHighest'),
              boxShadow: [BoxShadow(blurRadius: 6, offset: Offset(0, 3))],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Complete Purchase", style: TextStyle(color: CustomColors.getThemeColor(context, 'titleLarge'), fontWeight: FontWeight.bold, fontSize: 30)),

                  SizedBox(height: 30),

                  // Phone Number
                  TextFormField(
                    controller: _phoneIN,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      TextInputFormatter.withFunction((oldValue, newValue) {
                        final digitsOnly = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
                        final buffer = StringBuffer();

                        for (int i = 0; i < digitsOnly.length && i < 10; i++) {
                          if (i == 3 || i == 6) buffer.write(' ');
                          buffer.write(digitsOnly[i]);
                        }

                        return TextEditingValue(text: buffer.toString(), selection: TextSelection.collapsed(offset: buffer.length));
                      }),
                    ],
                    decoration: InputDecoration(labelText: "Phone Number", labelStyle: TextStyle(color: CustomColors.getThemeColor(context, 'labelMedium'), fontWeight: FontWeight.bold, fontSize: 20)),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter your Contact Number!!';
                      } else if (value.length < 12) {
                        return 'Contact Number Must be at Least 10 Digits Long!!';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 16),

                  // Address
                  TextFormField(
                    controller: _addressIN,
                    decoration: InputDecoration(labelText: "Address", labelStyle: TextStyle(color: CustomColors.getThemeColor(context, 'labelMedium'), fontWeight: FontWeight.bold, fontSize: 20)),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter Your Address!!';
                      } else if (value.length < 5) {
                        return 'Address Must be at Least 5 Characters Long!!';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 16),

                  // Selection
                  DropdownButtonFormField(
                    value: _selectedShippingMethod,
                    decoration: InputDecoration(labelText: 'Shipping Method', labelStyle: TextStyle(color: CustomColors.getThemeColor(context, 'labelMedium'), fontWeight: FontWeight.bold, fontSize: 20)),
                    items:
                        ['Standard', 'Express', 'Next-Day'].map((method) {
                          return DropdownMenuItem(value: method, child: Text(method, style: TextStyle(color: CustomColors.getThemeColor(context, 'bodyLarge'), fontWeight: FontWeight.bold, fontSize: 22)));
                        }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedShippingMethod = value!;
                      });
                    },
                  ),

                  SizedBox(height: 50),

                  // Cardholder Name
                  TextFormField(
                    controller: _cardHolderNameIN,
                    decoration: InputDecoration(labelText: 'Cardholder Name', labelStyle: TextStyle(color: CustomColors.getThemeColor(context, 'labelMedium'), fontWeight: FontWeight.bold, fontSize: 20)),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter Your Username!!';
                      } else if (value.length < 3) {
                        return 'Username Must be at Least 3 Characters Long!!';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 16),

                  // Card Number
                  TextFormField(
                    controller: _cardNumberIN,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      TextInputFormatter.withFunction((oldValue, newValue) {
                        final digitsOnly = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
                        final buffer = StringBuffer();

                        for (int i = 0; i < digitsOnly.length && i < 16; i++) {
                          if (i == 4 || i == 8 || i == 12 || i == 16) buffer.write(' ');
                          buffer.write(digitsOnly[i]);
                        }

                        return TextEditingValue(text: buffer.toString(), selection: TextSelection.collapsed(offset: buffer.length));
                      }),
                    ],
                    decoration: InputDecoration(labelText: 'Card Number', labelStyle: TextStyle(color: CustomColors.getThemeColor(context, 'labelMedium'), fontWeight: FontWeight.bold, fontSize: 20)),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter your Card Number!!';
                      } else if (value.length < 14) {
                        return 'Card Number Must be at Least 12 Digits Long!!';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 16),

                  // CVC
                  TextFormField(
                    controller: _cvcIN,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      TextInputFormatter.withFunction((oldValue, newValue) {
                        final digitsOnly = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
                        final buffer = StringBuffer();

                        for (int i = 0; i < digitsOnly.length && i < 4; i++) {
                          buffer.write(digitsOnly[i]);
                        }

                        return TextEditingValue(text: buffer.toString(), selection: TextSelection.collapsed(offset: buffer.length));
                      }),
                    ],
                    decoration: InputDecoration(labelText: 'CVC', labelStyle: TextStyle(color: CustomColors.getThemeColor(context, 'labelMedium'), fontWeight: FontWeight.bold, fontSize: 20)),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter Your CVC!!';
                      } else if (value.length != 4) {
                        return 'CVC Must be 4 Characters Long!!';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 30),

                  AnimatedOpacity(duration: Duration(milliseconds: 500), opacity: _showMsg ? 1.0 : 0.0, child: Text('Successfully Purchase Completed', style: TextStyle(color: CustomColors.getThemeColor(context, 'labelSmall'), fontWeight: FontWeight.bold, fontSize: 18))),
                  ElevatedButton(
                    onPressed: _checkOut,
                    style: ElevatedButton.styleFrom(backgroundColor: CustomColors.getThemeColor(context, 'primary'), foregroundColor: CustomColors.getThemeColor(context, 'onPrimary')),
                    child: Text('Check Out'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

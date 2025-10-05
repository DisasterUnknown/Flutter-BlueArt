// ignore_for_file: file_names

import 'dart:async';
import 'package:blue_art_mad2/language/systemLanguageManager.dart';
import 'package:blue_art_mad2/network/product/checkOut.dart';
import 'package:blue_art_mad2/theme/systemColorManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CheckOutPage extends ConsumerStatefulWidget {
  final Function(int) onPageNav;
  const CheckOutPage({
    super.key,
    required this.onPageNav,
  });

  @override
  ConsumerState<CheckOutPage> createState() => _CheckOutPageState();
}

class _CheckOutPageState extends ConsumerState<CheckOutPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneIN = TextEditingController();
  final TextEditingController _addressIN = TextEditingController();
  final TextEditingController _cardHolderNameIN = TextEditingController();
  final TextEditingController _cardNumberIN = TextEditingController();
  final TextEditingController _cvcIN = TextEditingController();
  String? dbMessage = "";
  bool _showMsg = false;
  String _selectedShippingMethod = CustomLanguages.getTextSync('shippingMethod1');

  // CheckOut Function
  void _checkOut() async {
    if (_formKey.currentState?.validate() ?? false) {
      final msg =
          await Checkout(
                ref,
                onPageNav: widget.onPageNav,
              ).userCheckOut(_phoneIN.text, _addressIN.text, _selectedShippingMethod, _cardHolderNameIN.text, _cardNumberIN.text, _cvcIN.text)
              as String?;

      setState(() {
        dbMessage = msg;
        _showMsg = true;
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
                  Text(
                    CustomLanguages.getTextSync('completePurchase'),
                    style: TextStyle(color: CustomColors.getThemeColor(context, 'textColor'), fontWeight: FontWeight.bold, fontSize: 30),
                  ),

                  SizedBox(height: 30),

                  // Phone Number
                  TextFormField(
                    controller: _phoneIN,
                    style: TextStyle(
                      color: CustomColors.getThemeColor(context, 'textColor'),
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
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

                        return TextEditingValue(
                          text: buffer.toString(),
                          selection: TextSelection.collapsed(offset: buffer.length),
                        );
                      }),
                    ],
                    decoration: InputDecoration(
                      labelText: CustomLanguages.getTextSync('phoneNumber'),
                      labelStyle: TextStyle(color: CustomColors.getThemeColor(context, 'labelMedium'), fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return CustomLanguages.getTextSync('pleaseEnterContactNumber');
                      } else if (value.length < 12) {
                        return CustomLanguages.getTextSync('contactRange');
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 16),

                  // Address
                  TextFormField(
                    controller: _addressIN,
                    style: TextStyle(
                      color: CustomColors.getThemeColor(context, 'textColor'),
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: InputDecoration(
                      labelText: CustomLanguages.getTextSync('address'),
                      labelStyle: TextStyle(color: CustomColors.getThemeColor(context, 'labelMedium'), fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return CustomLanguages.getTextSync('pleaseEnterAddress');
                      } else if (value.length < 5) {
                        return CustomLanguages.getTextSync('addressRange');
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 16),

                  // Selection
                  DropdownButtonFormField(
                    value: _selectedShippingMethod,
                    dropdownColor: CustomColors.getThemeColor(context, 'surfaceContainerHighest'),
                    decoration: InputDecoration(
                      labelText: CustomLanguages.getTextSync('shippingMethod'),
                      labelStyle: TextStyle(color: CustomColors.getThemeColor(context, 'labelMedium'), fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    items:
                        [
                          CustomLanguages.getTextSync('shippingMethod1'),
                          CustomLanguages.getTextSync('shippingMethod2'),
                          CustomLanguages.getTextSync('shippingMethod3'),
                        ].map((method) {
                          return DropdownMenuItem(
                            value: method,
                            child: Text(
                              method,
                              style: TextStyle(color: CustomColors.getThemeColor(context, 'textColor'), fontWeight: FontWeight.bold, fontSize: 22),
                            ),
                          );
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
                    style: TextStyle(
                      color: CustomColors.getThemeColor(context, 'textColor'),
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: InputDecoration(
                      labelText: CustomLanguages.getTextSync('cardholderName'),
                      labelStyle: TextStyle(color: CustomColors.getThemeColor(context, 'labelMedium'), fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return CustomLanguages.getTextSync('pleaseEnterUsername');
                      } else if (value.length < 3) {
                        return CustomLanguages.getTextSync('usernameRange');
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 16),

                  // Card Number
                  TextFormField(
                    controller: _cardNumberIN,
                    style: TextStyle(
                      color: CustomColors.getThemeColor(context, 'textColor'),
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
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

                        return TextEditingValue(
                          text: buffer.toString(),
                          selection: TextSelection.collapsed(offset: buffer.length),
                        );
                      }),
                    ],
                    decoration: InputDecoration(
                      labelText: CustomLanguages.getTextSync('cardNumber'),
                      labelStyle: TextStyle(color: CustomColors.getThemeColor(context, 'labelMedium'), fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return CustomLanguages.getTextSync('pleaseEnterCardNumber');
                      } else if (value.length < 14) {
                        return CustomLanguages.getTextSync('cardNumberRange');
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 16),

                  // CVC
                  TextFormField(
                    controller: _cvcIN,
                    style: TextStyle(
                      color: CustomColors.getThemeColor(context, 'textColor'),
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      TextInputFormatter.withFunction((oldValue, newValue) {
                        final digitsOnly = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
                        final buffer = StringBuffer();

                        for (int i = 0; i < digitsOnly.length && i < 4; i++) {
                          buffer.write(digitsOnly[i]);
                        }

                        return TextEditingValue(
                          text: buffer.toString(),
                          selection: TextSelection.collapsed(offset: buffer.length),
                        );
                      }),
                    ],
                    decoration: InputDecoration(
                      labelText: CustomLanguages.getTextSync('cvc'),
                      labelStyle: TextStyle(color: CustomColors.getThemeColor(context, 'labelMedium'), fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return CustomLanguages.getTextSync('pleaseEnterCvc');
                      } else if (value.length != 4) {
                        return CustomLanguages.getTextSync('cvcRange');
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 30),

                  AnimatedOpacity(
                    duration: Duration(milliseconds: 500),
                    opacity: _showMsg ? 1.0 : 0.0,
                    child: Text(
                      dbMessage!,
                      style: TextStyle(color: CustomColors.getThemeColor(context, 'labelSmall'), fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
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

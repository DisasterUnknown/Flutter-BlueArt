// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'dart:ui';
import 'package:blue_art_mad2/language/systemLanguageManager.dart';
import 'package:blue_art_mad2/services/sharedPrefValues.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:blue_art_mad2/services/localSharedPreferences.dart';

class ConnectionSettingsPopup extends StatefulWidget {
  const ConnectionSettingsPopup({super.key});

  @override
  State<ConnectionSettingsPopup> createState() => _ConnectionSettingsPopupState();
}

class _ConnectionSettingsPopupState extends State<ConnectionSettingsPopup> {
  String selectedConnection = 'online';
  final ipController = TextEditingController();
  final portController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  // Regex for IP validation (1-256 range each octet)
  final RegExp ipRegex = RegExp(
    r'^(25[0-5]|2[0-4]\d|1\d{2}|[1-9]?\d)\.'
    r'(25[0-5]|2[0-4]\d|1\d{2}|[1-9]?\d)\.'
    r'(25[0-5]|2[0-4]\d|1\d{2}|[1-9]?\d)\.'
    r'(25[0-5]|2[0-4]\d|1\d{2}|[1-9]?\d)$',
  );

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
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
                    CustomLanguages.getTextSync('connectionSettings'),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Radio buttons
                  RadioListTile<String>(
                    title: Text(CustomLanguages.getTextSync('onlineRailway'), style: TextStyle(color: Colors.white)),
                    value: 'online',
                    groupValue: selectedConnection,
                    activeColor: Colors.blue,
                    onChanged: (value) {
                      setState(() => selectedConnection = value!);
                    },
                  ),
                  RadioListTile<String>(
                    title: Text(CustomLanguages.getTextSync('local'), style: TextStyle(color: Colors.white)),
                    value: 'local',
                    groupValue: selectedConnection,
                    activeColor: Colors.blue,
                    onChanged: (value) {
                      setState(() => selectedConnection = value!);
                    },
                  ),

                  // Local connection fields
                  if (selectedConnection == 'local') ...[
                    TextFormField(
                      controller: ipController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: CustomLanguages.getTextSync('localIP'),
                        labelStyle: TextStyle(color: Colors.grey),
                        hintText: CustomLanguages.getTextSync('enterIP'),
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                        LengthLimitingTextInputFormatter(15),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return CustomLanguages.getTextSync('iPCannotBeEmpty');
                        }
                        if (!ipRegex.hasMatch(value.trim())) {
                          return CustomLanguages.getTextSync('enterValidIP');
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: portController,
                      style: const TextStyle(color: Colors.white),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: CustomLanguages.getTextSync('localPort'),
                        labelStyle: TextStyle(color: Colors.grey),
                        hintText: CustomLanguages.getTextSync('enterHostedPort'),
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(5),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return CustomLanguages.getTextSync('portCannotBeEmpty');
                        }
                        final portNum = int.tryParse(value);
                        if (portNum == null || portNum < 1 || portNum > 65535) {
                          return CustomLanguages.getTextSync('portRange');
                        }
                        return null;
                      },
                    ),
                  ],

                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(CustomLanguages.getTextSync('cancel'), style: TextStyle(color: Colors.white)),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () async {
                          if (selectedConnection == 'online') {
                            await LocalSharedPreferences.saveString(SharedPrefValues.connection, 'online');
                            await LocalSharedPreferences.saveString(SharedPrefValues.protocol, 'https');
                            Navigator.pop(context);
                          } else {
                            if (_formKey.currentState!.validate()) {
                              final ip = ipController.text.trim();
                              final port = portController.text.trim();

                              await LocalSharedPreferences.saveString(SharedPrefValues.connection, 'local');
                              await LocalSharedPreferences.saveString(SharedPrefValues.protocol, 'http');
                              await LocalSharedPreferences.saveString(SharedPrefValues.localIP, ip);
                              await LocalSharedPreferences.saveString(SharedPrefValues.localPort, port);

                              Navigator.pop(context);
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(CustomLanguages.getTextSync('save'), style: TextStyle(color: Colors.white)),
                      ),
                    ],
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

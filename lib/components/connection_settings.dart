// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'dart:ui';
import 'package:blue_art_mad2/services/sharedPrefValues.dart';
import 'package:flutter/material.dart';
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
                )
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Connection Settings',
                  style: TextStyle(
                    color: Colors.orangeAccent,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                RadioListTile<String>(
                  title: const Text('Online (Railway)'),
                  value: 'online',
                  groupValue: selectedConnection,
                  onChanged: (value) {
                    setState(() => selectedConnection = value!);
                  },
                ),
                RadioListTile<String>(
                  title: const Text('Local'),
                  value: 'local',
                  groupValue: selectedConnection,
                  onChanged: (value) {
                    setState(() => selectedConnection = value!);
                  },
                ),
                if (selectedConnection == 'local') ...[
                  TextField(
                    controller: ipController,
                    decoration: const InputDecoration(
                      labelText: 'Local IP',
                    ),
                  ),
                  TextField(
                    controller: portController,
                    decoration: const InputDecoration(
                      labelText: 'Local Port',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ],
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () async {
                        if (selectedConnection == 'online') {
                          await LocalSharedPreferences.saveString(SharedPrefValues.connection, 'online');
                        } else {
                          final ip = ipController.text.trim();
                          final port = portController.text.trim();
                          if (ip.isEmpty || port.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('IP and Port cannot be empty')),
                            );
                            return;
                          }
                          await LocalSharedPreferences.saveString(SharedPrefValues.connection, 'local');
                          await LocalSharedPreferences.saveString(SharedPrefValues.localIP, ip);
                          await LocalSharedPreferences.saveString(SharedPrefValues.localPort, port);
                        }
                        Navigator.pop(context);
                      },
                      child: const Text('Save'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

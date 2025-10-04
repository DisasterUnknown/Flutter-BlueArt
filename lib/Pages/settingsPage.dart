// ignore_for_file: use_build_context_synchronously, deprecated_member_use, file_names
import 'package:blue_art_mad2/services/localSharedPreferences.dart';
import 'package:blue_art_mad2/services/sharedPrefValues.dart';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../theme/systemColorManager.dart';

typedef NetworkToggleCallback = void Function(String status);

class SettingsPage extends StatefulWidget {
  final NetworkToggleCallback? onNetworkToggle;

  const SettingsPage({super.key, this.onNetworkToggle});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool shakeEnabled = false;
  bool vibrationEnabled = false;
  bool networkEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final shakeSharedPref = await LocalSharedPreferences.getString(SharedPrefValues.isShake);
    final vibrateSharedPref = await LocalSharedPreferences.getString(SharedPrefValues.isVibrate);
    final networkSharedPref = await LocalSharedPreferences.getString(SharedPrefValues.isNetwork);

    setState(() {
      shakeEnabled = (shakeSharedPref?.toLowerCase() == 'true');
      vibrationEnabled = (vibrateSharedPref?.toLowerCase() == 'true');
      networkEnabled = (networkSharedPref?.toLowerCase() == 'true');
    });

    if (networkEnabled) _triggerNetworkPopup();
  }

  Future<void> _toggleShake(bool value) async {
    await LocalSharedPreferences.saveString(SharedPrefValues.isShake, value.toString());
    setState(() => shakeEnabled = value);
  }

  Future<void> _toggleVibration(bool value) async {
    await LocalSharedPreferences.saveString(SharedPrefValues.isVibrate, value.toString());
    setState(() => vibrationEnabled = value);
  }

  Future<void> _toggleNetwork(bool value) async {
    await LocalSharedPreferences.saveString(SharedPrefValues.isNetwork, value.toString());
    setState(() => networkEnabled = value);
    await _triggerNetworkPopup();
  }

  Future<void> _triggerNetworkPopup() async {
    if (!networkEnabled) {
      widget.onNetworkToggle?.call("Offline");
      return;
    }

    final connectivityResult = await Connectivity().checkConnectivity();
    String status;
    if (connectivityResult.contains(ConnectivityResult.wifi)) {
      status = "Wi-Fi";
    } else if (connectivityResult.contains(ConnectivityResult.mobile)) {
      status = "Mobile Data";
    } else {
      status = "Offline";
    }

    widget.onNetworkToggle?.call(status);
  }

  Widget _buildToggleTile(String title, bool value, ValueChanged<bool> onChanged) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: CustomColors.getThemeColor(context, 'surfaceContainerHighest'),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(2, 2))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: CustomColors.getThemeColor(context, 'titleMedium'),
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: CustomColors.getThemeColor(context, 'tertiary'),
            inactiveThumbColor: CustomColors.getThemeColor(context, 'labelMedium'),
            inactiveTrackColor: CustomColors.getThemeColor(context, 'surfaceContainerHighest').withOpacity(0.5),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 30),
          Text(
            "Settings",
            style: TextStyle(
              color: CustomColors.getThemeColor(context, 'textColor'),
              fontWeight: FontWeight.bold,
              fontSize: 28,
            ),
          ),
          const SizedBox(height: 20),
          _buildToggleTile("Shake Sensor", shakeEnabled, _toggleShake),
          _buildToggleTile("Vibration", vibrationEnabled, _toggleVibration),
          _buildToggleTile("Network Connectivity", networkEnabled, _toggleNetwork),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}

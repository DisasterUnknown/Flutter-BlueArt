// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:io';
import 'package:blue_art_mad2/language/systemLanguageManager.dart';
import 'package:blue_art_mad2/theme/systemColorManager.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:network_info_plus/network_info_plus.dart';

class MovableNetworkPopup extends StatefulWidget {
  const MovableNetworkPopup({super.key});

  @override
  State<MovableNetworkPopup> createState() => _MovableNetworkPopupState();
}

class _MovableNetworkPopupState extends State<MovableNetworkPopup> with SingleTickerProviderStateMixin {
  Offset position = const Offset(50, 100);
  String ipAddress = "-";
  String speed = "-";
  String connectivity = "Offline";
  Timer? _timer;
  late AnimationController _controller;
  late Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();
    _checkNetwork(); // initial load

    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      _checkNetwork();
      _updatePing();
    });

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _checkNetwork() async {
    final wifiInfo = NetworkInfo();
    String newConnectivity = "Offline";
    String newIp = "-";

    try {
      final networkIP = await wifiInfo.getWifiIP();
      final connectivityResult = await Connectivity().checkConnectivity();

      if (connectivityResult.contains(ConnectivityResult.wifi)) newConnectivity = "Wi-Fi";
      if (connectivityResult.contains(ConnectivityResult.mobile)) newConnectivity = "Mobile Data";

      if (networkIP != null) {
        newIp = networkIP;
      }
    } catch (_) {}

    // Update only if changed
    if (newConnectivity != connectivity || newIp != ipAddress) {
      setState(() {
        connectivity = newConnectivity;
        ipAddress = newIp;
        if (connectivity == "Offline") speed = "-";
      });
    }
  }

  Future<void> _updatePing() async {
    if (connectivity == "Offline") return;

    final stopwatch = Stopwatch()..start();
    try {
      final socket = await Socket.connect(
        '8.8.8.8',
        53,
        timeout: const Duration(seconds: 2),
      );
      stopwatch.stop();
      socket.destroy();

      final pingMs = stopwatch.elapsedMilliseconds;
      setState(() => speed = "${pingMs}ms");
    } catch (_) {
      stopwatch.stop();
      setState(() => speed = "Offline");
    }
  }

  @override
  Widget build(BuildContext context) {
    final surface = CustomColors.getThemeColor(context, 'surface');
    final surfaceHighest = CustomColors.getThemeColor(context, 'surfaceContainerHighest');
    final textColor = CustomColors.getThemeColor(context, 'textColor');
    final titleColor = CustomColors.getThemeColor(context, 'onPrimaryContainer');
    final primary = CustomColors.getThemeColor(context, 'primary');
    final tertiary = CustomColors.getThemeColor(context, 'bottomNavigationBarSelectedGradient2');
    final errorColor = CustomColors.getThemeColor(context, 'onTertiary');

    return Positioned(
      left: position.dx,
      top: position.dy,
      child: Draggable(
        feedback: _buildPopup(surface, surfaceHighest, textColor, titleColor, primary, tertiary, errorColor, opacity: 0.85),
        childWhenDragging: Container(),
        onDragEnd: (details) => setState(() => position = details.offset),
        child: FadeTransition(
          opacity: _fadeIn,
          child: _buildPopup(surface, surfaceHighest, textColor, titleColor, primary, tertiary, errorColor),
        ),
      ),
    );
  }

  Widget _buildPopup(
    Color surface,
    Color bgColor,
    Color textColor,
    Color titleColor,
    Color primary,
    Color tertiary,
    Color errorColor, {
    double opacity = 1,
  }) {
    final isOffline = connectivity == "Offline";
    final gradient = isOffline ? [errorColor.withOpacity(0.6), errorColor.withOpacity(0.9)] : [primary.withOpacity(0.7), tertiary.withOpacity(0.9)];

    final icon = isOffline ? Icons.wifi_off_rounded : (connectivity == "Mobile Data" ? Icons.signal_cellular_alt_rounded : Icons.wifi_rounded);

    return Material(
      color: Colors.transparent,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 240,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              bgColor.withOpacity(opacity),
              surface.withOpacity(opacity - 0.1),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: isOffline ? errorColor.withOpacity(0.4) : tertiary.withOpacity(0.5),
              blurRadius: 12,
              offset: const Offset(3, 3),
            ),
          ],
          border: Border.all(
            color: isOffline ? errorColor : tertiary,
            width: 1.2,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with icon + title
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: gradient),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "${CustomLanguages.getTextSync('network')} $connectivity",
                    style: TextStyle(
                      color: titleColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _infoRow(CustomLanguages.getTextSync('iPAddress'), ipAddress, textColor),
            const SizedBox(height: 4),
            _infoRow(CustomLanguages.getTextSync('ping'), speed, textColor),
            const SizedBox(height: 4),
            if (isOffline)
              Padding(
                padding: const EdgeInsets.only(top: 6.0),
                child: Text(
                  CustomLanguages.getTextSync('connectionLost'),
                  style: TextStyle(
                    color: errorColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value, Color textColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "$label:",
          style: TextStyle(
            color: textColor.withOpacity(0.8),
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        Flexible(
          child: Text(
            value,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 14,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }
}

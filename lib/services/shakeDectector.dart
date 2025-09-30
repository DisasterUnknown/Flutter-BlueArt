import 'dart:async';
import 'dart:math';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:flutter/foundation.dart';

class ShakeDetector {
  final VoidCallback onShake;
  final double shakeThresholdGravity;
  final int shakeSlopTimeMs;

  ShakeDetector({
    required this.onShake,
    this.shakeThresholdGravity = 1.7,
    this.shakeSlopTimeMs = 500,
  }) {
    _startListening();
  }

  StreamSubscription<AccelerometerEvent>? _subscription;
  int _lastShakeTimestamp = 0;

  void _startListening() {
    _subscription = accelerometerEvents.listen((event) {
      double gX = event.x / 9.81;
      double gY = event.y / 9.81;
      double gZ = event.z / 9.81;

      double gForce = sqrt(gX * gX + gY * gY + gZ * gZ);

      if (gForce > shakeThresholdGravity) {
        final now = DateTime.now().millisecondsSinceEpoch;
        if (_lastShakeTimestamp + shakeSlopTimeMs < now) {
          _lastShakeTimestamp = now;
          onShake();
        }
      }
    });
  }

  void dispose() {
    _subscription?.cancel();
  }
}

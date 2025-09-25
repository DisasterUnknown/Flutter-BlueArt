import 'package:blue_art_mad2/states/authStateManagement.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FirebaseDBService {
  final DatabaseReference _db = FirebaseDatabase.instance.ref();
  final WidgetRef ref;
  FirebaseDBService(this.ref);

  // Getting the userid of the current user
  String get _userId {
    final user = ref.read(userProvider)!;
    return user.id!;
  }

  // Save favorites
  Future<void> addFavorite(String productId) async {
    await _db.child("favorites/$_userId/$productId").set({
      "productId": productId,
      "addedAt": DateTime.now().toIso8601String(),
    });
  }

  // Remove favorites
  Future<void> removeFavorite(String productId) async {
    await _db.child("favorites/$_userId/$productId").remove();
  }

  // Get all favorites
  Future<List<String>> getFavorites() async {
    final snapshot = await _db.child("favorites/$_userId").get();
    if (!snapshot.exists) return [];

    final value = snapshot.value;

    if (value is Map) {
      final data = Map<String, dynamic>.from(value);
      return data.values.map((e) => (e as Map)["productId"].toString()).toList();
    } else if (value is List) {
      return value.where((e) => e != null).map((e) => (e as Map)["productId"].toString()).toList();
    }

    return [];
  }

  // Realtime listener for favorites
  Stream<List<String>> listenToFavorites() {
    return _db.child("favorites/$_userId").onValue.map((event) {
      if (!event.snapshot.exists) return [];
      final data = Map<String, dynamic>.from(event.snapshot.value as Map);
      return data.values.map((e) => (e as Map)["productId"].toString()).toList();
    });
  }
}

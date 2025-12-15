import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

/// Service for Firebase operations
class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Get Firebase Auth instance
  FirebaseAuth get auth => _auth;

  /// Get Firestore instance
  FirebaseFirestore get firestore => _firestore;

  /// Get current user
  User? get currentUser => _auth.currentUser;

  /// Check if user is authenticated
  bool get isAuthenticated => _auth.currentUser != null;

  /// Get current user ID
  String? get currentUserId => _auth.currentUser?.uid;

  /// Enable offline persistence for Firestore
  Future<void> enableOfflinePersistence() async {
    try {
      // Firestore persistence is enabled by default on mobile platforms
      debugPrint('Firestore offline persistence enabled');
    } catch (e) {
      debugPrint('Error enabling offline persistence: $e');
    }
  }
}


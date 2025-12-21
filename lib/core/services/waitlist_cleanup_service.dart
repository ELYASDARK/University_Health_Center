import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

/// Service for cleaning up expired waitlist entries
class WaitlistCleanupService {
  static final WaitlistCleanupService _instance =
      WaitlistCleanupService._internal();
  factory WaitlistCleanupService() => _instance;
  WaitlistCleanupService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Timer? _cleanupTimer;

  /// Start the periodic cleanup service
  void startCleanupService() {
    debugPrint('Starting waitlist cleanup service...');

    // Run cleanup immediately on start
    _performCleanup();

    // Schedule periodic cleanup every hour
    _cleanupTimer = Timer.periodic(
      const Duration(hours: 1),
      (_) => _performCleanup(),
    );

    debugPrint('Waitlist cleanup service started successfully');
  }

  /// Stop the cleanup service
  void stopCleanupService() {
    _cleanupTimer?.cancel();
    _cleanupTimer = null;
    debugPrint('Waitlist cleanup service stopped');
  }

  /// Perform the actual cleanup of expired waitlist entries
  Future<void> _performCleanup() async {
    try {
      debugPrint('Running waitlist cleanup...');

      // Query for expired waitlist entries
      // Assuming waitlist entries have an 'expiresAt' timestamp field
      final now = Timestamp.now();

      final expiredEntries = await _firestore
          .collection('waitlist')
          .where('expiresAt', isLessThan: now)
          .get();

      if (expiredEntries.docs.isEmpty) {
        debugPrint('No expired waitlist entries found');
        return;
      }

      // Delete expired entries in batch
      final batch = _firestore.batch();
      for (var doc in expiredEntries.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
      debugPrint(
        'Cleaned up ${expiredEntries.docs.length} expired waitlist entries',
      );
    } catch (e) {
      debugPrint('Error during waitlist cleanup: $e');
    }
  }

  /// Manually trigger cleanup (useful for testing)
  Future<void> runCleanup() async {
    await _performCleanup();
  }
}




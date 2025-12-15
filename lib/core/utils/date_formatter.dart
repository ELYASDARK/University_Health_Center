import 'package:intl/intl.dart';

/// Utility class for date and time formatting
class DateFormatter {
  /// Format date as 'MMM dd, yyyy' (e.g., Jan 15, 2024)
  static String formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  /// Format time as 'hh:mm a' (e.g., 02:30 PM)
  static String formatTime(DateTime date) {
    return DateFormat('hh:mm a').format(date);
  }

  /// Format date and time as 'MMM dd, yyyy at hh:mm a'
  static String formatDateTime(DateTime date) {
    return DateFormat('MMM dd, yyyy \'at\' hh:mm a').format(date);
  }

  /// Format date as 'EEEE, MMMM dd' (e.g., Monday, January 15)
  static String formatFullDate(DateTime date) {
    return DateFormat('EEEE, MMMM dd').format(date);
  }

  /// Format date for display in calendar
  static String formatCalendarDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  /// Get relative time string (e.g., "2 hours ago", "Tomorrow", "Yesterday")
  static String getRelativeTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'Just now';
        }
        return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
      }
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return formatDate(date);
    }
  }

  /// Check if date is today
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// Check if date is tomorrow
  static bool isTomorrow(DateTime date) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day;
  }

  /// Parse Firestore timestamp
  static DateTime parseFirestoreTimestamp(dynamic timestamp) {
    if (timestamp == null) return DateTime.now();
    if (timestamp is DateTime) return timestamp;
    // Handle Firestore Timestamp
    return DateTime.fromMillisecondsSinceEpoch(timestamp.seconds * 1000);
  }
}


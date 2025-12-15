import 'package:cloud_firestore/cloud_firestore.dart';

/// Notification model representing a user notification
class NotificationModel {
  final String id;
  final String userId;
  final String type; // reminder, confirmation, cancellation, update
  final String title;
  final String body;
  final bool isRead;
  final Map<String, dynamic>? data;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.body,
    this.isRead = false,
    this.data,
    required this.createdAt,
  });

  /// Check if notification is a reminder
  bool get isReminder => type == 'reminder';

  /// Check if notification is a confirmation
  bool get isConfirmation => type == 'confirmation';

  /// Check if notification is a cancellation
  bool get isCancellation => type == 'cancellation';

  /// Check if notification is an update
  bool get isUpdate => type == 'update';

  /// Create NotificationModel from JSON
  factory NotificationModel.fromJson(Map<String, dynamic> json, String id) {
    return NotificationModel(
      id: id,
      userId: json['userId'] as String,
      type: json['type'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      isRead: json['isRead'] as bool? ?? false,
      data: json['data'] as Map<String, dynamic>?,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }

  /// Convert NotificationModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'type': type,
      'title': title,
      'body': body,
      'isRead': isRead,
      'data': data,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  /// Create a copy with updated fields
  NotificationModel copyWith({
    String? id,
    String? userId,
    String? type,
    String? title,
    String? body,
    bool? isRead,
    Map<String, dynamic>? data,
    DateTime? createdAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      title: title ?? this.title,
      body: body ?? this.body,
      isRead: isRead ?? this.isRead,
      data: data ?? this.data,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}


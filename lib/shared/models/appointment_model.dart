import 'package:cloud_firestore/cloud_firestore.dart';

/// Appointment model representing a medical appointment
class AppointmentModel {
  final String id;
  final String userId;
  final String doctorId;
  final String departmentId;
  final DateTime appointmentDate;
  final int duration; // in minutes
  final String status; // scheduled, completed, cancelled, no-show
  final String reason;
  final String? notes;
  final List<String> remindersSent;
  final DateTime createdAt;
  final DateTime updatedAt;

  AppointmentModel({
    required this.id,
    required this.userId,
    required this.doctorId,
    required this.departmentId,
    required this.appointmentDate,
    required this.duration,
    required this.status,
    required this.reason,
    this.notes,
    required this.remindersSent,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Check if appointment is upcoming
  bool get isUpcoming =>
      status == 'scheduled' && appointmentDate.isAfter(DateTime.now());

  /// Check if appointment is past
  bool get isPast => appointmentDate.isBefore(DateTime.now());

  /// Check if appointment is today
  bool get isToday {
    final now = DateTime.now();
    return appointmentDate.year == now.year &&
        appointmentDate.month == now.month &&
        appointmentDate.day == now.day;
  }

  /// Check if appointment is scheduled
  bool get isScheduled => status == 'scheduled';

  /// Check if appointment is completed
  bool get isCompleted => status == 'completed';

  /// Check if appointment is cancelled
  bool get isCancelled => status == 'cancelled';

  /// Get appointment end time
  DateTime get endTime =>
      appointmentDate.add(Duration(minutes: duration));

  /// Create AppointmentModel from JSON
  factory AppointmentModel.fromJson(Map<String, dynamic> json, String id) {
    return AppointmentModel(
      id: id,
      userId: json['userId'] as String,
      doctorId: json['doctorId'] as String,
      departmentId: json['departmentId'] as String,
      appointmentDate: (json['appointmentDate'] as Timestamp).toDate(),
      duration: json['duration'] as int,
      status: json['status'] as String,
      reason: json['reason'] as String,
      notes: json['notes'] as String?,
      remindersSent: List<String>.from(json['remindersSent'] ?? []),
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
    );
  }

  /// Convert AppointmentModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'doctorId': doctorId,
      'departmentId': departmentId,
      'appointmentDate': Timestamp.fromDate(appointmentDate),
      'duration': duration,
      'status': status,
      'reason': reason,
      'notes': notes,
      'remindersSent': remindersSent,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  /// Create a copy with updated fields
  AppointmentModel copyWith({
    String? id,
    String? userId,
    String? doctorId,
    String? departmentId,
    DateTime? appointmentDate,
    int? duration,
    String? status,
    String? reason,
    String? notes,
    List<String>? remindersSent,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AppointmentModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      doctorId: doctorId ?? this.doctorId,
      departmentId: departmentId ?? this.departmentId,
      appointmentDate: appointmentDate ?? this.appointmentDate,
      duration: duration ?? this.duration,
      status: status ?? this.status,
      reason: reason ?? this.reason,
      notes: notes ?? this.notes,
      remindersSent: remindersSent ?? this.remindersSent,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}


import 'package:cloud_firestore/cloud_firestore.dart';

/// TimeSlot model representing available appointment slots
class TimeSlotModel {
  final String id;
  final String doctorId;
  final DateTime date;
  final DateTime startTime;
  final DateTime endTime;
  final bool isAvailable;
  final String? appointmentId;

  TimeSlotModel({
    required this.id,
    required this.doctorId,
    required this.date,
    required this.startTime,
    required this.endTime,
    this.isAvailable = true,
    this.appointmentId,
  });

  /// Check if slot is in the past
  bool get isPast => startTime.isBefore(DateTime.now());

  /// Check if slot is today
  bool get isToday {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// Get duration in minutes
  int get durationInMinutes => endTime.difference(startTime).inMinutes;

  /// Create TimeSlotModel from JSON
  factory TimeSlotModel.fromJson(Map<String, dynamic> json, String id) {
    return TimeSlotModel(
      id: id,
      doctorId: json['doctorId'] as String,
      date: (json['date'] as Timestamp).toDate(),
      startTime: (json['startTime'] as Timestamp).toDate(),
      endTime: (json['endTime'] as Timestamp).toDate(),
      isAvailable: json['isAvailable'] as bool? ?? true,
      appointmentId: json['appointmentId'] as String?,
    );
  }

  /// Convert TimeSlotModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'doctorId': doctorId,
      'date': Timestamp.fromDate(date),
      'startTime': Timestamp.fromDate(startTime),
      'endTime': Timestamp.fromDate(endTime),
      'isAvailable': isAvailable,
      'appointmentId': appointmentId,
    };
  }

  /// Create a copy with updated fields
  TimeSlotModel copyWith({
    String? id,
    String? doctorId,
    DateTime? date,
    DateTime? startTime,
    DateTime? endTime,
    bool? isAvailable,
    String? appointmentId,
  }) {
    return TimeSlotModel(
      id: id ?? this.id,
      doctorId: doctorId ?? this.doctorId,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      isAvailable: isAvailable ?? this.isAvailable,
      appointmentId: appointmentId ?? this.appointmentId,
    );
  }
}


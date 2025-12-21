import 'package:cloud_firestore/cloud_firestore.dart';

/// Review model representing a patient's review of a doctor
class Review {
  final String id;
  final String doctorId;
  final String patientId;
  final String patientName; // For display purposes
  final String appointmentId;
  final int rating; // 1-5
  final String reviewText;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isApproved;
  final bool isEdited;

  Review({
    required this.id,
    required this.doctorId,
    required this.patientId,
    required this.patientName,
    required this.appointmentId,
    required this.rating,
    required this.reviewText,
    required this.createdAt,
    this.updatedAt,
    this.isApproved = true, // Auto-approve by default
    this.isEdited = false,
  });

  /// Create Review from JSON
  factory Review.fromJson(Map<String, dynamic> json, String id) {
    return Review(
      id: id,
      doctorId: json['doctorId'] as String,
      patientId: json['patientId'] as String,
      patientName: json['patientName'] as String,
      appointmentId: json['appointmentId'] as String,
      rating: json['rating'] as int,
      reviewText: json['reviewText'] as String,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: json['updatedAt'] != null
          ? (json['updatedAt'] as Timestamp).toDate()
          : null,
      isApproved: json['isApproved'] as bool? ?? true,
      isEdited: json['isEdited'] as bool? ?? false,
    );
  }

  /// Convert Review to JSON
  Map<String, dynamic> toJson() {
    return {
      'doctorId': doctorId,
      'patientId': patientId,
      'patientName': patientName,
      'appointmentId': appointmentId,
      'rating': rating,
      'reviewText': reviewText,
      'createdAt': Timestamp.fromDate(createdAt),
      if (updatedAt != null) 'updatedAt': Timestamp.fromDate(updatedAt!),
      'isApproved': isApproved,
      'isEdited': isEdited,
    };
  }

  /// Create a copy with updated fields
  Review copyWith({
    String? id,
    String? doctorId,
    String? patientId,
    String? patientName,
    String? appointmentId,
    int? rating,
    String? reviewText,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isApproved,
    bool? isEdited,
  }) {
    return Review(
      id: id ?? this.id,
      doctorId: doctorId ?? this.doctorId,
      patientId: patientId ?? this.patientId,
      patientName: patientName ?? this.patientName,
      appointmentId: appointmentId ?? this.appointmentId,
      rating: rating ?? this.rating,
      reviewText: reviewText ?? this.reviewText,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isApproved: isApproved ?? this.isApproved,
      isEdited: isEdited ?? this.isEdited,
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

/// User model representing a user in the system
class UserModel {
  final String uid;
  final String email;
  final String role; // student, staff, admin, doctor
  final String firstName;
  final String lastName;
  final String? studentId;
  final String phone;
  final DateTime dateOfBirth;
  final Map<String, dynamic>? emergencyContact;
  final String? fcmToken;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.uid,
    required this.email,
    required this.role,
    required this.firstName,
    required this.lastName,
    this.studentId,
    required this.phone,
    required this.dateOfBirth,
    this.emergencyContact,
    this.fcmToken,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Get full name
  String get fullName => '$firstName $lastName';

  /// Check if user is admin
  bool get isAdmin => role == 'admin';

  /// Check if user is doctor
  bool get isDoctor => role == 'doctor';

  /// Check if user is student
  bool get isStudent => role == 'student';

  /// Check if user is staff
  bool get isStaff => role == 'staff';

  /// Create UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      studentId: json['studentId'] as String?,
      phone: json['phone'] as String,
      dateOfBirth: (json['dateOfBirth'] as Timestamp).toDate(),
      emergencyContact: json['emergencyContact'] as Map<String, dynamic>?,
      fcmToken: json['fcmToken'] as String?,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
    );
  }

  /// Convert UserModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'role': role,
      'firstName': firstName,
      'lastName': lastName,
      'studentId': studentId,
      'phone': phone,
      'dateOfBirth': Timestamp.fromDate(dateOfBirth),
      'emergencyContact': emergencyContact,
      'fcmToken': fcmToken,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  /// Create a copy with updated fields
  UserModel copyWith({
    String? uid,
    String? email,
    String? role,
    String? firstName,
    String? lastName,
    String? studentId,
    String? phone,
    DateTime? dateOfBirth,
    Map<String, dynamic>? emergencyContact,
    String? fcmToken,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      role: role ?? this.role,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      studentId: studentId ?? this.studentId,
      phone: phone ?? this.phone,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      fcmToken: fcmToken ?? this.fcmToken,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

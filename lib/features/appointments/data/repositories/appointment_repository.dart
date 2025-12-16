import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../shared/models/appointment_model.dart';

/// Repository for managing appointments
class AppointmentRepository {
  final FirebaseFirestore _firestore;

  AppointmentRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Book a new appointment
  Future<AppointmentModel> bookAppointment(AppointmentModel appointment) async {
    try {
      // Validation: Check if date is in past
      if (appointment.appointmentDate.isBefore(DateTime.now())) {
        throw AppointmentException('Cannot book appointments in the past');
      }

      // Validation: Check if too far in future
      final maxDate = DateTime.now().add(
        Duration(days: AppConstants.maxFutureDays),
      );
      if (appointment.appointmentDate.isAfter(maxDate)) {
        throw AppointmentException(
          'Cannot book more than ${AppConstants.maxFutureDays} days in advance',
        );
      }

      // Validation: Check for conflicting appointments with same doctor
      final existingAppointments = await getDoctorAppointments(
        doctorId: appointment.doctorId,
        date: appointment.appointmentDate,
      );

      for (var existing in existingAppointments) {
        // Check for time overlap
        final existingStart = existing.appointmentDate;
        final existingEnd = existing.endTime;
        final newStart = appointment.appointmentDate;
        final newEnd = appointment.endTime;

        if ((newStart.isBefore(existingEnd) && newEnd.isAfter(existingStart))) {
          throw AppointmentException(
            'This time slot is already booked. Please choose another time.',
          );
        }
      }

      // Validation: Limit concurrent appointments per user
      final userAppointments = await getUpcomingAppointments(
        appointment.userId,
      );
      if (userAppointments.length >= AppConstants.maxConcurrentAppointments) {
        throw AppointmentException(
          'Maximum ${AppConstants.maxConcurrentAppointments} upcoming appointments allowed. '
          'Please cancel one to book another.',
        );
      }

      final docRef = await _firestore
          .collection(AppConstants.appointmentsCollection)
          .add(appointment.toJson());

      return appointment.copyWith(id: docRef.id);
    } catch (e) {
      if (e is AppointmentException) rethrow;
      throw AppointmentException('Failed to book appointment: $e');
    }
  }

  /// Get user's appointments
  Future<List<AppointmentModel>> getUserAppointments(String userId) async {
    try {
      // Query without orderBy to avoid requiring composite index
      final snapshot = await _firestore
          .collection(AppConstants.appointmentsCollection)
          .where('userId', isEqualTo: userId)
          .get()
          .timeout(
            Duration(seconds: AppConstants.requestTimeoutSeconds),
            onTimeout: () => throw TimeoutException('Request timeout'),
          );

      // Sort in app code instead of Firestore query
      final appointments = snapshot.docs
          .map((doc) => AppointmentModel.fromJson(doc.data(), doc.id))
          .toList();

      // Sort by appointment date, most recent first
      appointments.sort(
        (a, b) => b.appointmentDate.compareTo(a.appointmentDate),
      );

      return appointments;
    } on TimeoutException {
      throw NetworkException(
        'Request timed out. Please check your connection.',
      );
    } catch (e) {
      throw AppointmentException('Failed to fetch appointments: $e');
    }
  }

  /// Get upcoming appointments for a user
  Future<List<AppointmentModel>> getUpcomingAppointments(String userId) async {
    try {
      final now = DateTime.now();
      // Simplified query: Only filter by userId to avoid composite index
      // Filter by date and status in app code
      final snapshot = await _firestore
          .collection(AppConstants.appointmentsCollection)
          .where('userId', isEqualTo: userId)
          .get()
          .timeout(
            Duration(seconds: AppConstants.requestTimeoutSeconds),
            onTimeout: () => throw TimeoutException('Request timeout'),
          );

      // Filter by date and status, then sort in app code
      final appointments = snapshot.docs
          .map((doc) => AppointmentModel.fromJson(doc.data(), doc.id))
          .where((appointment) =>
              appointment.status == AppConstants.statusScheduled &&
              appointment.appointmentDate.isAfter(now))
          .toList();

      // Sort by appointment date
      appointments.sort((a, b) => a.appointmentDate.compareTo(b.appointmentDate));

      return appointments;
    } on TimeoutException {
      throw NetworkException(
        'Request timed out. Please check your connection.',
      );
    } catch (e) {
      throw AppointmentException('Failed to fetch upcoming appointments: $e');
    }
  }

  /// Get appointment by ID
  Future<AppointmentModel?> getAppointmentById(String id) async {
    try {
      final doc = await _firestore
          .collection(AppConstants.appointmentsCollection)
          .doc(id)
          .get();

      if (!doc.exists) return null;

      return AppointmentModel.fromJson(doc.data()!, doc.id);
    } catch (e) {
      throw AppointmentException('Failed to fetch appointment: $e');
    }
  }

  /// Cancel appointment
  Future<void> cancelAppointment(String appointmentId) async {
    try {
      await _firestore
          .collection(AppConstants.appointmentsCollection)
          .doc(appointmentId)
          .update({
            'status': AppConstants.statusCancelled,
            'updatedAt': FieldValue.serverTimestamp(),
          });
    } catch (e) {
      throw AppointmentException('Failed to cancel appointment: $e');
    }
  }

  /// Update appointment
  Future<void> updateAppointment(AppointmentModel appointment) async {
    try {
      await _firestore
          .collection(AppConstants.appointmentsCollection)
          .doc(appointment.id)
          .update(appointment.toJson());
    } catch (e) {
      throw AppointmentException('Failed to update appointment: $e');
    }
  }

  /// Stream of user's appointments (real-time updates)
  Stream<List<AppointmentModel>> watchUserAppointments(String userId) {
    try {
      return _firestore
          .collection(AppConstants.appointmentsCollection)
          .where('userId', isEqualTo: userId)
          .snapshots()
          .map((snapshot) {
            final appointments = snapshot.docs
                .map((doc) => AppointmentModel.fromJson(doc.data(), doc.id))
                .toList();
            // Sort in app code to avoid composite index
            appointments.sort(
              (a, b) => b.appointmentDate.compareTo(a.appointmentDate),
            );
            return appointments;
          });
    } catch (e) {
      throw AppointmentException('Failed to watch appointments: $e');
    }
  }

  /// Get doctor's appointments for a specific date
  Future<List<AppointmentModel>> getDoctorAppointments({
    required String doctorId,
    required DateTime date,
  }) async {
    try {
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

      // Simplified query: Only filter by doctorId to avoid composite index
      // Filter by date and status in app code
      final snapshot = await _firestore
          .collection(AppConstants.appointmentsCollection)
          .where('doctorId', isEqualTo: doctorId)
          .get()
          .timeout(
            Duration(seconds: AppConstants.requestTimeoutSeconds),
            onTimeout: () => throw TimeoutException('Request timeout'),
          );

      // Filter by date range and status in app code to avoid composite index
      return snapshot.docs
          .map((doc) => AppointmentModel.fromJson(doc.data(), doc.id))
          .where((appointment) {
            final appointmentDate = appointment.appointmentDate;
            return appointment.status == AppConstants.statusScheduled &&
                appointmentDate.isAfter(startOfDay) &&
                appointmentDate.isBefore(endOfDay);
          })
          .toList();
    } on TimeoutException {
      throw NetworkException(
        'Request timed out. Please check your connection.',
      );
    } catch (e) {
      throw AppointmentException('Failed to fetch doctor appointments: $e');
    }
  }
}

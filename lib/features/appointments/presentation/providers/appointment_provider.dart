import 'package:flutter/foundation.dart';
import '../../../../shared/models/appointment_model.dart';
import '../../data/repositories/appointment_repository.dart';

/// Provider for managing appointments
class AppointmentProvider extends ChangeNotifier {
  final AppointmentRepository _repository = AppointmentRepository();

  List<AppointmentModel> _appointments = [];
  List<AppointmentModel> _upcomingAppointments = [];
  AppointmentModel? _selectedAppointment;
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  List<AppointmentModel> get appointments => _appointments;
  List<AppointmentModel> get upcomingAppointments => _upcomingAppointments;
  AppointmentModel? get selectedAppointment => _selectedAppointment;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  /// Load user's appointments
  Future<void> loadUserAppointments(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _appointments = await _repository.getUserAppointments(userId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to load appointments: $e';
      notifyListeners();
    }
  }

  /// Load upcoming appointments
  Future<void> loadUpcomingAppointments(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _upcomingAppointments = await _repository.getUpcomingAppointments(userId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to load upcoming appointments: $e';
      notifyListeners();
    }
  }

  /// Book a new appointment
  Future<bool> bookAppointment(AppointmentModel appointment) async {
    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      final bookedAppointment = await _repository.bookAppointment(appointment);
      _appointments.insert(0, bookedAppointment);
      _isLoading = false;
      _successMessage = 'Appointment booked successfully';
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to book appointment: $e';
      notifyListeners();
      return false;
    }
  }

  /// Cancel appointment
  Future<bool> cancelAppointment(String appointmentId) async {
    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      await _repository.cancelAppointment(appointmentId);

      // Update local state
      final index = _appointments.indexWhere((a) => a.id == appointmentId);
      if (index != -1) {
        _appointments[index] = _appointments[index].copyWith(
          status: 'cancelled',
        );
      }

      _isLoading = false;
      _successMessage = 'Appointment cancelled successfully';
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to cancel appointment: $e';
      notifyListeners();
      return false;
    }
  }

  /// Select an appointment
  void selectAppointment(AppointmentModel appointment) {
    _selectedAppointment = appointment;
    notifyListeners();
  }

  /// Clear messages
  void clearMessages() {
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }
}

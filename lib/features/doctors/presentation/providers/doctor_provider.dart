import 'package:flutter/foundation.dart';
import '../../../../shared/models/doctor_model.dart';
import '../../data/repositories/doctor_repository.dart';

/// Provider for managing doctors
class DoctorProvider extends ChangeNotifier {
  final DoctorRepository _repository = DoctorRepository();

  List<DoctorModel> _doctors = [];
  DoctorModel? _selectedDoctor;
  bool _isLoading = false;
  String? _errorMessage;

  List<DoctorModel> get doctors => _doctors;
  DoctorModel? get selectedDoctor => _selectedDoctor;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Load all doctors
  Future<void> loadDoctors() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _doctors = await _repository.getAllDoctors();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to load doctors: $e';
      notifyListeners();
    }
  }

  /// Load doctors by department
  Future<void> loadDoctorsByDepartment(String departmentId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _doctors = await _repository.getDoctorsByDepartment(departmentId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to load doctors: $e';
      notifyListeners();
    }
  }

  /// Select a doctor
  void selectDoctor(DoctorModel doctor) {
    _selectedDoctor = doctor;
    notifyListeners();
  }

  /// Clear selection
  void clearSelection() {
    _selectedDoctor = null;
    notifyListeners();
  }
}


import 'package:flutter/foundation.dart';
import '../../../../shared/models/department_model.dart';
import '../../data/repositories/department_repository.dart';

/// Provider for managing departments
class DepartmentProvider extends ChangeNotifier {
  final DepartmentRepository _repository = DepartmentRepository();

  List<DepartmentModel> _departments = [];
  DepartmentModel? _selectedDepartment;
  bool _isLoading = false;
  String? _errorMessage;

  List<DepartmentModel> get departments => _departments;
  DepartmentModel? get selectedDepartment => _selectedDepartment;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Load all departments
  Future<void> loadDepartments() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _departments = await _repository.getAllDepartments();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to load departments: $e';
      notifyListeners();
    }
  }

  /// Select a department
  void selectDepartment(DepartmentModel department) {
    _selectedDepartment = department;
    notifyListeners();
  }

  /// Clear selection
  void clearSelection() {
    _selectedDepartment = null;
    notifyListeners();
  }
}


import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../shared/models/department_model.dart';

/// Repository for managing departments
class DepartmentRepository {
  final FirebaseFirestore _firestore;

  DepartmentRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Get all active departments
  Future<List<DepartmentModel>> getAllDepartments() async {
    try {
      final snapshot = await _firestore
          .collection(AppConstants.departmentsCollection)
          .where('isActive', isEqualTo: true)
          .get();

      return snapshot.docs
          .map((doc) => DepartmentModel.fromJson(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw ServerException('Failed to fetch departments: $e');
    }
  }

  /// Get department by ID
  Future<DepartmentModel?> getDepartmentById(String id) async {
    try {
      final doc = await _firestore
          .collection(AppConstants.departmentsCollection)
          .doc(id)
          .get();

      if (!doc.exists) return null;

      return DepartmentModel.fromJson(doc.data()!, doc.id);
    } catch (e) {
      throw ServerException('Failed to fetch department: $e');
    }
  }

  /// Stream of all departments (real-time updates)
  Stream<List<DepartmentModel>> watchDepartments() {
    try {
      return _firestore
          .collection(AppConstants.departmentsCollection)
          .where('isActive', isEqualTo: true)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => DepartmentModel.fromJson(doc.data(), doc.id))
              .toList());
    } catch (e) {
      throw ServerException('Failed to watch departments: $e');
    }
  }
}


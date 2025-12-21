import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../shared/models/doctor_model.dart';

/// Repository for managing doctors
class DoctorRepository {
  final FirebaseFirestore _firestore;

  DoctorRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Get all doctors
  Future<List<DoctorModel>> getAllDoctors() async {
    try {
      final snapshot = await _firestore
          .collection(AppConstants.doctorsCollection)
          .get();

      return snapshot.docs
          .map((doc) => DoctorModel.fromJson(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw ServerException('Failed to fetch doctors: $e');
    }
  }

  /// Get doctors by department
  Future<List<DoctorModel>> getDoctorsByDepartment(String departmentId) async {
    try {
      final snapshot = await _firestore
          .collection(AppConstants.doctorsCollection)
          .where('departmentId', isEqualTo: departmentId)
          .get();

      return snapshot.docs
          .map((doc) => DoctorModel.fromJson(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw ServerException('Failed to fetch doctors: $e');
    }
  }

  /// Get doctor by ID
  Future<DoctorModel?> getDoctorById(String id) async {
    try {
      final doc = await _firestore
          .collection(AppConstants.doctorsCollection)
          .doc(id)
          .get();

      if (!doc.exists) return null;

      return DoctorModel.fromJson(doc.data()!, doc.id);
    } catch (e) {
      throw ServerException('Failed to fetch doctor: $e');
    }
  }

  /// Stream of doctors by department (real-time updates)
  Stream<List<DoctorModel>> watchDoctorsByDepartment(String departmentId) {
    try {
      return _firestore
          .collection(AppConstants.doctorsCollection)
          .where('departmentId', isEqualTo: departmentId)
          .snapshots()
          .map(
            (snapshot) => snapshot.docs
                .map((doc) => DoctorModel.fromJson(doc.data(), doc.id))
                .toList(),
          );
    } catch (e) {
      throw ServerException('Failed to watch doctors: $e');
    }
  }
}

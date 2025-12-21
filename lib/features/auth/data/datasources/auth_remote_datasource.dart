import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../shared/models/user_model.dart';
import '../../../../core/constants/app_constants.dart';

/// Remote datasource for authentication
abstract class AuthRemoteDataSource {
  Future<UserModel> signInWithEmail(String email, String password);
  Future<UserModel> signUpWithEmail({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String role,
    required String phone,
    required DateTime dateOfBirth,
    String? studentId,
  });
  Future<void> signOut();
  Future<UserModel?> getCurrentUser();
  Future<void> sendPasswordResetEmail(String email);
  Future<void> updateUserProfile(UserModel user);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthRemoteDataSourceImpl({
    required FirebaseAuth firebaseAuth,
    required FirebaseFirestore firestore,
  }) : _firebaseAuth = firebaseAuth,
       _firestore = firestore;

  @override
  Future<UserModel> signInWithEmail(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        throw AuthenticationException('User not found');
      }

      // Get user data from Firestore
      final userDoc = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(userCredential.user!.uid)
          .get();

      if (!userDoc.exists) {
        throw AuthenticationException('User data not found');
      }

      return UserModel.fromJson(userDoc.data()!);
    } on FirebaseAuthException catch (e) {
      throw AuthenticationException(_getAuthErrorMessage(e.code));
    } catch (e) {
      throw AuthenticationException('Failed to sign in: $e');
    }
  }

  @override
  Future<UserModel> signUpWithEmail({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String role,
    required String phone,
    required DateTime dateOfBirth,
    String? studentId,
  }) async {
    try {
      // Create Firebase Auth user
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        throw AuthenticationException('Failed to create user');
      }

      // Create user document in Firestore
      final user = UserModel(
        uid: userCredential.user!.uid,
        email: email,
        role: role,
        firstName: firstName,
        lastName: lastName,
        studentId: studentId,
        phone: phone,
        dateOfBirth: dateOfBirth,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(user.uid)
          .set(user.toJson());

      return user;
    } on FirebaseAuthException catch (e) {
      throw AuthenticationException(_getAuthErrorMessage(e.code));
    } catch (e) {
      throw AuthenticationException('Failed to sign up: $e');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw AuthenticationException('Failed to sign out: $e');
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) return null;

      final userDoc = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(user.uid)
          .get();

      if (!userDoc.exists) return null;

      return UserModel.fromJson(userDoc.data()!);
    } catch (e) {
      throw AuthenticationException('Failed to get current user: $e');
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw AuthenticationException(_getAuthErrorMessage(e.code));
    } catch (e) {
      throw AuthenticationException('Failed to send password reset email: $e');
    }
  }

  @override
  Future<void> updateUserProfile(UserModel user) async {
    try {
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(user.uid)
          .update(user.toJson());
    } catch (e) {
      throw AuthenticationException('Failed to update user profile: $e');
    }
  }

  /// Get user-friendly error messages for Firebase Auth errors
  String _getAuthErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No user found with this email address';
      case 'wrong-password':
        return 'Incorrect password';
      case 'email-already-in-use':
        return 'An account already exists with this email';
      case 'invalid-email':
        return 'Invalid email address';
      case 'weak-password':
        return 'Password is too weak. Please use at least 6 characters';
      case 'user-disabled':
        return 'This account has been disabled';
      case 'too-many-requests':
        return 'Too many login attempts. Please try again later';
      default:
        return 'Authentication failed. Please try again';
    }
  }
}

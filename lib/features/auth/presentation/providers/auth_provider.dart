import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../shared/models/user_model.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';

/// Authentication state
enum AuthState { initial, authenticated, unauthenticated, loading, error }

/// Provider for managing authentication state
class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepositoryImpl(
    remoteDataSource: AuthRemoteDataSourceImpl(
      firebaseAuth: FirebaseAuth.instance,
      firestore: FirebaseFirestore.instance,
    ),
  );

  AuthState _authState = AuthState.initial;
  UserModel? _currentUser;
  String? _errorMessage;

  AuthState get authState => _authState;
  UserModel? get currentUser => _currentUser;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _authState == AuthState.authenticated;
  bool get isLoading => _authState == AuthState.loading;

  /// Initialize auth state
  Future<void> initialize() async {
    _authState = AuthState.loading;
    notifyListeners();

    final result = await _authRepository.getCurrentUser();
    result.fold(
      (failure) {
        _authState = AuthState.unauthenticated;
        _currentUser = null;
        notifyListeners();
      },
      (user) {
        if (user != null) {
          _authState = AuthState.authenticated;
          _currentUser = user;
        } else {
          _authState = AuthState.unauthenticated;
          _currentUser = null;
        }
        notifyListeners();
      },
    );
  }

  /// Sign in with email and password
  Future<bool> signIn(String email, String password) async {
    _authState = AuthState.loading;
    _errorMessage = null;
    notifyListeners();

    final result = await _authRepository.signInWithEmail(email, password);
    return result.fold(
      (failure) {
        _authState = AuthState.error;
        _errorMessage = failure.message;
        notifyListeners();
        return false;
      },
      (user) {
        _authState = AuthState.authenticated;
        _currentUser = user;
        _errorMessage = null;
        notifyListeners();
        return true;
      },
    );
  }

  /// Sign up with email and password
  Future<bool> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String role,
    required String phone,
    required DateTime dateOfBirth,
    String? studentId,
  }) async {
    _authState = AuthState.loading;
    _errorMessage = null;
    notifyListeners();

    final result = await _authRepository.signUpWithEmail(
      email: email,
      password: password,
      firstName: firstName,
      lastName: lastName,
      role: role,
      phone: phone,
      dateOfBirth: dateOfBirth,
      studentId: studentId,
    );

    return result.fold(
      (failure) {
        _authState = AuthState.error;
        _errorMessage = failure.message;
        notifyListeners();
        return false;
      },
      (user) {
        _authState = AuthState.authenticated;
        _currentUser = user;
        _errorMessage = null;
        notifyListeners();
        return true;
      },
    );
  }

  /// Sign out
  Future<void> signOut() async {
    _authState = AuthState.loading;
    notifyListeners();

    final result = await _authRepository.signOut();
    result.fold(
      (failure) {
        _authState = AuthState.error;
        _errorMessage = failure.message;
        notifyListeners();
      },
      (_) {
        _authState = AuthState.unauthenticated;
        _currentUser = null;
        _errorMessage = null;
        notifyListeners();
      },
    );
  }

  /// Send password reset email
  Future<bool> sendPasswordResetEmail(String email) async {
    _errorMessage = null;
    
    final result = await _authRepository.sendPasswordResetEmail(email);
    return result.fold(
      (failure) {
        _errorMessage = failure.message;
        notifyListeners();
        return false;
      },
      (_) {
        return true;
      },
    );
  }

  /// Update user profile
  Future<bool> updateUserProfile(UserModel user) async {
    final result = await _authRepository.updateUserProfile(user);
    return result.fold(
      (failure) {
        _errorMessage = failure.message;
        notifyListeners();
        return false;
      },
      (_) {
        _currentUser = user;
        notifyListeners();
        return true;
      },
    );
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}


import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../shared/models/user_model.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

/// Implementation of AuthRepository
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, UserModel>> signInWithEmail(
    String email,
    String password,
  ) async {
    try {
      final user = await remoteDataSource.signInWithEmail(email, password);
      return Either.right(user);
    } on AuthenticationException catch (e) {
      return Either.left(AuthFailure(e.message));
    } catch (e) {
      return Either.left(AuthFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, UserModel>> signUpWithEmail({
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
      final user = await remoteDataSource.signUpWithEmail(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        role: role,
        phone: phone,
        dateOfBirth: dateOfBirth,
        studentId: studentId,
      );
      return Either.right(user);
    } on AuthenticationException catch (e) {
      return Either.left(AuthFailure(e.message));
    } catch (e) {
      return Either.left(AuthFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await remoteDataSource.signOut();
      return Either.right(null);
    } on AuthenticationException catch (e) {
      return Either.left(AuthFailure(e.message));
    } catch (e) {
      return Either.left(AuthFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, UserModel?>> getCurrentUser() async {
    try {
      final user = await remoteDataSource.getCurrentUser();
      return Either.right(user);
    } on AuthenticationException catch (e) {
      return Either.left(AuthFailure(e.message));
    } catch (e) {
      return Either.left(AuthFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> sendPasswordResetEmail(String email) async {
    try {
      await remoteDataSource.sendPasswordResetEmail(email);
      return Either.right(null);
    } on AuthenticationException catch (e) {
      return Either.left(AuthFailure(e.message));
    } catch (e) {
      return Either.left(AuthFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> updateUserProfile(UserModel user) async {
    try {
      await remoteDataSource.updateUserProfile(user);
      return Either.right(null);
    } on AuthenticationException catch (e) {
      return Either.left(AuthFailure(e.message));
    } catch (e) {
      return Either.left(AuthFailure('Unexpected error: $e'));
    }
  }
}


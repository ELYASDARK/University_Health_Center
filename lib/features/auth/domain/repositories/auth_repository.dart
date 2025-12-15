import '../../../../shared/models/user_model.dart';
import '../../../../core/errors/failures.dart';

/// Authentication repository interface
abstract class AuthRepository {
  Future<Either<Failure, UserModel>> signInWithEmail(
    String email,
    String password,
  );

  Future<Either<Failure, UserModel>> signUpWithEmail({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String role,
    required String phone,
    required DateTime dateOfBirth,
    String? studentId,
  });

  Future<Either<Failure, void>> signOut();

  Future<Either<Failure, UserModel?>> getCurrentUser();

  Future<Either<Failure, void>> sendPasswordResetEmail(String email);

  Future<Either<Failure, void>> updateUserProfile(UserModel user);
}

/// Either type for handling errors
class Either<L, R> {
  final L? _left;
  final R? _right;

  Either.left(L left) : _left = left, _right = null;

  Either.right(R right) : _left = null, _right = right;

  bool get isLeft => _left != null;
  bool get isRight => _right != null;

  L get left => _left!;
  R get right => _right!;

  T fold<T>(T Function(L) onLeft, T Function(R) onRight) {
    if (isLeft) return onLeft(_left as L);
    return onRight(_right as R);
  }
}

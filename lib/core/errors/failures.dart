/// Base failure class for error handling
abstract class Failure {
  final String message;
  final String? code;

  const Failure(this.message, [this.code]);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Failure &&
          runtimeType == other.runtimeType &&
          message == other.message &&
          code == other.code;

  @override
  int get hashCode => message.hashCode ^ code.hashCode;
}

/// Network failure
class NetworkFailure extends Failure {
  const NetworkFailure(String message) : super(message, 'network_failure');
}

/// Server failure
class ServerFailure extends Failure {
  const ServerFailure(String message) : super(message, 'server_failure');
}

/// Cache failure
class CacheFailure extends Failure {
  const CacheFailure(String message) : super(message, 'cache_failure');
}

/// Authentication failure
class AuthFailure extends Failure {
  const AuthFailure(String message) : super(message, 'auth_failure');
}

/// Validation failure
class ValidationFailure extends Failure {
  const ValidationFailure(String message) : super(message, 'validation_failure');
}


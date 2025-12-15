/// Base exception class for the application
class AppException implements Exception {
  final String message;
  final String? code;

  AppException(this.message, [this.code]);

  @override
  String toString() => message;
}

/// Network-related exceptions
class NetworkException extends AppException {
  NetworkException(String message) : super(message, 'network_error');
}

/// Authentication-related exceptions
class AuthenticationException extends AppException {
  AuthenticationException(String message) : super(message, 'auth_error');
}

/// Appointment-related exceptions
class AppointmentException extends AppException {
  AppointmentException(String message) : super(message, 'appointment_error');
}

/// Server-related exceptions
class ServerException extends AppException {
  ServerException(String message) : super(message, 'server_error');
}

/// Cache-related exceptions
class CacheException extends AppException {
  CacheException(String message) : super(message, 'cache_error');
}

/// Validation exceptions
class ValidationException extends AppException {
  ValidationException(String message) : super(message, 'validation_error');
}


/// Application-wide constants
class AppConstants {
  // App Info
  static const String appName = 'University Health Center';
  static const String appVersion = '1.0.0';

  // Firestore Collections
  static const String usersCollection = 'users';
  static const String appointmentsCollection = 'appointments';
  static const String doctorsCollection = 'doctors';
  static const String departmentsCollection = 'departments';
  static const String timeSlotsCollection = 'timeSlots';
  static const String notificationsCollection = 'notifications';

  // User Roles
  static const String roleStudent = 'student';
  static const String roleStaff = 'staff';
  static const String roleAdmin = 'admin';
  static const String roleDoctor = 'doctor';

  // Appointment Status
  static const String statusScheduled = 'scheduled';
  static const String statusCompleted = 'completed';
  static const String statusCancelled = 'cancelled';
  static const String statusNoShow = 'no-show';

  // Notification Types
  static const String notificationReminder = 'reminder';
  static const String notificationConfirmation = 'confirmation';
  static const String notificationCancellation = 'cancellation';
  static const String notificationUpdate = 'update';

  // Appointment Duration (in minutes)
  static const int defaultAppointmentDuration = 30;

  // Notification Channels
  static const String notificationChannelId = 'appointment_reminders';
  static const String notificationChannelName = 'Appointment Reminders';
  static const String notificationChannelDescription =
      'Notifications for appointment reminders and updates';

  // SharedPreferences Keys
  static const String keyIsFirstLaunch = 'is_first_launch';
  static const String keyNotificationsEnabled = 'notifications_enabled';
  static const String keyFcmToken = 'fcm_token';
  static const String keyUserRole = 'user_role';

  // Pagination
  static const int pageSize = 20;

  // Validation
  static const int minPasswordLength = 6;
  static const int minStudentIdLength = 5;
}


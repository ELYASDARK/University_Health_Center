/// Accessibility constants for semantic labels and announcements
class AccessibilityConstants {
  AccessibilityConstants._();

  // Status semantics
  static const Map<String, String> statusSemantics = {
    'pending': 'Pending status',
    'confirmed': 'Confirmed status',
    'cancelled': 'Cancelled status',
    'completed': 'Completed status',
    'scheduled': 'Scheduled status',
    'active': 'Active status',
    'inactive': 'Inactive status',
  };

  // Announcement labels
  static const String loadingAnnouncement = 'Loading content';
  static const String errorAnnouncement = 'Error';
  static const String successAnnouncement = 'Success';
  static const String warningAnnouncement = 'Warning';

  // Button labels
  static const String submitButtonLabel = 'Submit button';
  static const String cancelButtonLabel = 'Cancel button';
  static const String closeButtonLabel = 'Close button';
  static const String backButtonLabel = 'Back button';
  static const String nextButtonLabel = 'Next button';
  static const String saveButtonLabel = 'Save button';
  static const String deleteButtonLabel = 'Delete button';
  static const String editButtonLabel = 'Edit button';

  // Form field hints
  static const String requiredFieldHint = 'Required field';
  static const String optionalFieldHint = 'Optional field';
  static const String emailFieldHint = 'Email address field';
  static const String passwordFieldHint = 'Password field';
  static const String phoneFieldHint = 'Phone number field';

  // Navigation hints
  static const String homeTabHint = 'Navigate to home';
  static const String profileTabHint = 'Navigate to profile';
  static const String appointmentsTabHint = 'Navigate to appointments';
  static const String notificationsTabHint = 'Navigate to notifications';

  // Image descriptions
  static const String profileImageLabel = 'Profile picture';
  static const String logoImageLabel = 'Application logo';
  static const String iconImageLabel = 'Icon';

  // List item hints
  static const String listItemHint = 'Tap to view details';
  static const String swipeableItemHint = 'Swipeable item';

  // Dialog hints
  static const String dialogLabel = 'Dialog';
  static const String alertDialogLabel = 'Alert dialog';
  static const String confirmDialogLabel = 'Confirmation dialog';

  // Loading states
  static const String refreshingHint = 'Refreshing content';
  static const String loadingMoreHint = 'Loading more items';

  // Empty states
  static const String noDataLabel = 'No data available';
  static const String emptyListLabel = 'Empty list';
}




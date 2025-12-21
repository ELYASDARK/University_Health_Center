# 🛠️ Notification History - Developer Guide

## Quick Integration Guide

### Adding a New Notification Type

#### 1. Add to NotificationType Enum
```dart
// lib/features/notifications/domain/models/notification_item.dart

enum NotificationType {
  appointmentReminder,
  appointmentConfirmation,
  cancellationAlert,
  waitlistUpdate,
  rescheduleConfirmation,
  general,
  yourNewType,  // Add here
}
```

#### 2. Update UI Components
```dart
// lib/features/notifications/presentation/widgets/notification_list_item.dart

IconData _getTypeIcon(NotificationType type) {
  switch (type) {
    // ... existing cases
    case NotificationType.yourNewType:
      return Icons.your_icon;
  }
}

Color _getTypeColor(NotificationType type) {
  switch (type) {
    // ... existing cases
    case NotificationType.yourNewType:
      return Colors.yourColor;
  }
}
```

#### 3. Add to Filter Widget
```dart
// lib/features/notifications/presentation/widgets/notification_filter.dart

_buildTypeChip(
  context,
  'Your Type',
  NotificationType.yourNewType,
  Icons.your_icon,
),
```

#### 4. Create Sending Method
```dart
// lib/core/services/notification_service.dart

Future<void> sendYourNewTypeNotification({
  required String userId,
  required String title,
  required String body,
  Map<String, dynamic>? data,
}) async {
  try {
    // Show local notification
    await _showLocalNotification(
      title: title,
      body: body,
      payload: data?['someId'],
    );

    // Save to Firestore
    await _saveNotificationToFirestore(
      userId: userId,
      type: NotificationType.yourNewType,
      title: title,
      body: body,
      data: data,
    );

    debugPrint('Your notification sent');
  } catch (e) {
    debugPrint('Error sending notification: $e');
  }
}
```

---

## Sending Notifications

### Example: Send Appointment Confirmation
```dart
await NotificationService().sendAppointmentConfirmation(
  userId: 'user123',
  appointmentId: 'appt456',
  doctorName: 'Dr. Smith',
  appointmentDate: DateTime.now().add(Duration(hours: 24)),
  reason: 'General Checkup',
);
```

### Example: Send Custom Notification
```dart
final notificationRepository = NotificationHistoryRepository();
final notification = NotificationItem(
  id: '',
  userId: 'user123',
  type: NotificationType.general,
  title: 'Welcome!',
  body: 'Thanks for using our app',
  isRead: false,
  createdAt: DateTime.now(),
  data: null,
);

await notificationRepository.createNotification(notification);
```

---

## Querying Notifications

### Get All Notifications
```dart
final repository = NotificationHistoryRepository();
final notifications = await repository.getNotifications(
  userId: 'user123',
  limit: 50,
);
```

### Get Unread Notifications Only
```dart
final unreadNotifications = await repository.getNotifications(
  userId: 'user123',
  isRead: false,
  limit: 50,
);
```

### Get Specific Type
```dart
final reminders = await repository.getNotifications(
  userId: 'user123',
  type: NotificationType.appointmentReminder,
  limit: 50,
);
```

### Watch Notifications (Real-time)
```dart
final stream = repository.watchNotifications('user123');

stream.listen((notifications) {
  print('Notification count: ${notifications.length}');
  // Update UI
});
```

### Get Unread Count
```dart
final count = await repository.getUnreadCount('user123');
print('Unread notifications: $count');
```

---

## Navigation from Notifications

### Setup Navigation Data
When creating a notification, include navigation data:

```dart
// For appointment-related notifications
data: {
  'appointmentId': 'appt123',
}

// For waitlist-related notifications
data: {
  'timeSlotId': 'slot456',
}

// For custom navigation
data: {
  'routeName': '/your-route',
  'routeArguments': {'key': 'value'},
}
```

### Handle Navigation in History Page
Currently implemented in `_handleNotificationTap()`:

```dart
void _handleNotificationTap(NotificationItem notification) {
  // Mark as read
  _handleMarkAsRead(notification);

  // Navigate based on data
  if (notification.data != null) {
    final data = notification.data!;
    
    if (data.containsKey('appointmentId')) {
      Navigator.pushNamed(
        context,
        '/appointment-details',
        arguments: data['appointmentId'],
      );
    } else if (data.containsKey('timeSlotId')) {
      Navigator.pushNamed(context, '/waitlist');
    }
    // Add more navigation logic here
  }
}
```

---

## Repository Methods Reference

### NotificationHistoryRepository

#### Query Methods
```dart
// Get notifications with filters
Future<List<NotificationItem>> getNotifications({
  required String userId,
  NotificationType? type,
  bool? isRead,
  int limit = 50,
})

// Watch notifications (real-time stream)
Stream<List<NotificationItem>> watchNotifications(String userId)

// Get unread count
Future<int> getUnreadCount(String userId)
```

#### Update Methods
```dart
// Mark single as read
Future<void> markAsRead(String notificationId)

// Mark all as read for user
Future<void> markAllAsRead(String userId)
```

#### Delete Methods
```dart
// Delete single notification
Future<void> deleteNotification(String notificationId)

// Delete all notifications for user
Future<void> deleteAllNotifications(String userId)
```

#### Create Methods
```dart
// Create notification
Future<void> createNotification(NotificationItem notification)
```

---

## Use Cases Reference

### GetNotifications
```dart
final getNotifications = GetNotifications(repository);

final notifications = await getNotifications(
  userId: 'user123',
  type: NotificationType.appointmentReminder,
  isRead: false,
  limit: 20,
);
```

### MarkNotificationRead
```dart
final markNotificationRead = MarkNotificationRead(repository);

// Mark single as read
await markNotificationRead('notificationId123');

// Mark all as read
await markNotificationRead.markAllAsRead('user123');
```

### DeleteNotification
```dart
final deleteNotification = DeleteNotification(repository);

// Delete single
await deleteNotification('notificationId123');

// Delete all
await deleteNotification.deleteAll('user123');
```

---

## Common Patterns

### Pattern 1: Send and Save Notification
```dart
Future<void> sendNotificationWithHistory({
  required String userId,
  required NotificationType type,
  required String title,
  required String body,
  Map<String, dynamic>? data,
}) async {
  // Send local notification
  await NotificationService()._showLocalNotification(
    title: title,
    body: body,
  );

  // Save to history
  await NotificationService()._saveNotificationToFirestore(
    userId: userId,
    type: type,
    title: title,
    body: body,
    data: data,
  );
}
```

### Pattern 2: Batch Mark as Read
```dart
Future<void> markMultipleAsRead(List<String> notificationIds) async {
  final repository = NotificationHistoryRepository();
  
  for (final id in notificationIds) {
    try {
      await repository.markAsRead(id);
    } catch (e) {
      debugPrint('Failed to mark $id as read: $e');
    }
  }
}
```

### Pattern 3: Filter and Process
```dart
Future<void> processUnreadReminders(String userId) async {
  final repository = NotificationHistoryRepository();
  
  final reminders = await repository.getNotifications(
    userId: userId,
    type: NotificationType.appointmentReminder,
    isRead: false,
  );

  for (final reminder in reminders) {
    // Process each reminder
    print('Unread reminder: ${reminder.title}');
  }
}
```

---

## Error Handling

### Repository Error Handling
All repository methods throw appropriate exceptions:

```dart
try {
  final notifications = await repository.getNotifications(userId: userId);
} on TimeoutException {
  print('Request timed out');
} on NetworkException catch (e) {
  print('Network error: ${e.message}');
} on AppException catch (e) {
  print('App error: ${e.message}');
} catch (e) {
  print('Unknown error: $e');
}
```

### Use Case Error Handling
Use cases wrap repository calls with additional validation:

```dart
try {
  await getNotifications(userId: '');  // Empty userId
} on AppException catch (e) {
  print(e.message);  // "User ID cannot be empty"
}
```

---

## Testing

### Unit Testing Repository
```dart
void main() {
  late NotificationHistoryRepository repository;
  late MockFirestore mockFirestore;

  setUp(() {
    mockFirestore = MockFirestore();
    repository = NotificationHistoryRepository(firestore: mockFirestore);
  });

  test('getNotifications should return list', () async {
    // Arrange
    when(mockFirestore.collection('notifications')...)
        .thenAnswer((_) async => mockSnapshot);

    // Act
    final result = await repository.getNotifications(userId: 'user123');

    // Assert
    expect(result, isA<List<NotificationItem>>());
  });
}
```

### Widget Testing
```dart
void main() {
  testWidgets('NotificationListItem should display correctly', (tester) async {
    final notification = NotificationItem(
      id: '1',
      userId: 'user123',
      type: NotificationType.appointmentReminder,
      title: 'Test',
      body: 'Test body',
      isRead: false,
      createdAt: DateTime.now(),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: NotificationListItem(
            notification: notification,
            onTap: () {},
            onDelete: () {},
          ),
        ),
      ),
    );

    expect(find.text('Test'), findsOneWidget);
  });
}
```

---

## Performance Tips

### 1. Use Pagination
```dart
// Limit results to reduce reads
final notifications = await repository.getNotifications(
  userId: userId,
  limit: 20,  // Start small
);
```

### 2. Cache Unread Count
```dart
// Cache badge count in shared preferences
final prefs = await SharedPreferences.getInstance();
await prefs.setInt('unread_count', count);
```

### 3. Use Streams Wisely
```dart
// Limit stream listeners
final streamSubscription = repository
    .watchNotifications(userId)
    .listen((notifications) {
      // Update UI
    });

// Don't forget to cancel
@override
void dispose() {
  streamSubscription.cancel();
  super.dispose();
}
```

### 4. Batch Operations
```dart
// Use batch writes for multiple updates
final batch = FirebaseFirestore.instance.batch();
for (final notificationId in ids) {
  batch.update(
    FirebaseFirestore.instance.collection('notifications').doc(notificationId),
    {'isRead': true},
  );
}
await batch.commit();
```

---

## Debugging

### Enable Debug Logging
```dart
// In notification_service.dart
debugPrint('Notification saved to Firestore');
```

### Check Firestore Console
1. Open Firebase Console
2. Go to Firestore Database
3. Navigate to `notifications` collection
4. Verify documents are being created

### Test Notification Flow
```dart
// Create test notification
await repository.createNotification(
  NotificationItem(
    id: '',
    userId: 'test_user',
    type: NotificationType.general,
    title: 'Test Notification',
    body: 'Testing notification history',
    isRead: false,
    createdAt: DateTime.now(),
  ),
);

// Verify in UI
// Should appear in notification history page
```

---

## Security Checklist

- [ ] Firestore rules deployed
- [ ] Users can only read their own notifications
- [ ] Users can only update/delete their own notifications
- [ ] Sensitive data not in notification body
- [ ] FCM tokens properly managed
- [ ] Timeout handling implemented
- [ ] Error handling doesn't expose internals

---

## Deployment Checklist

- [ ] All tests passing
- [ ] No linter errors
- [ ] Firestore indexes created
- [ ] Security rules deployed
- [ ] Analytics tracking added (optional)
- [ ] Error logging configured
- [ ] Performance monitoring enabled
- [ ] User documentation updated

---

## Troubleshooting

### Notifications Not Appearing
1. Check Firestore collection exists
2. Verify userId matches authenticated user
3. Check notification creation code
4. Look for errors in logs

### Badge Count Wrong
1. Clear app cache
2. Restart app
3. Check Firestore data directly
4. Verify query filters

### Navigation Not Working
1. Check notification data field
2. Verify route names match
3. Test with debugPrint statements
4. Check navigation stack

---

## Resources

- [Firebase Cloud Messaging Docs](https://firebase.google.com/docs/cloud-messaging)
- [Flutter Local Notifications](https://pub.dev/packages/flutter_local_notifications)
- [Firestore Best Practices](https://firebase.google.com/docs/firestore/best-practices)
- [Clean Architecture in Flutter](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)

---

**Last Updated**: December 19, 2025  
**Version**: 1.0.0  
**Maintainer**: Development Team


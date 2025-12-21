# 🧪 Testing Guide - University Health Center App

## Overview
This guide covers the testing strategy, test structure, and how to run tests for the University Health Center appointment booking app.

---

## 📋 Test Coverage

### Unit Tests ✅
- ✅ **Reschedule Appointment** - `test/features/appointments/reschedule_appointment_test.dart`
  - Validation tests (cancelled appointments, within 2 hours, past dates, too far future)
  - Success scenarios
  - Appointment type durations
  - Model serialization
  
- ✅ **Waitlist System** - `test/features/appointments/waitlist_test.dart`
  - Waitlist entry model
  - Join/leave waitlist
  - Expired entries cleanup
  - TimeSlot waitlist features
  
- ✅ **Notification History** - `test/features/notifications/notification_history_test.dart`
  - Notification model
  - Get notifications use case
  - Mark as read use case
  - Delete notifications use case
  - Unread count

### Widget Tests ✅
- ✅ **Notification Widgets** - `test/features/notifications/notification_widget_test.dart`
  - NotificationListItem display and interactions
  - NotificationFilter functionality
  - Icon display for different types
  - Read/unread indicators

### Integration Tests (Planned)
- ⏳ End-to-end appointment booking flow
- ⏳ Admin dashboard workflows
- ⏳ Notification delivery and interaction

---

## 🚀 Running Tests

### Run All Tests
```bash
flutter test
```

### Run Specific Test File
```bash
flutter test test/features/appointments/reschedule_appointment_test.dart
```

### Run Tests with Coverage
```bash
flutter test --coverage
```

### Generate Coverage Report
```bash
# Install lcov if not already installed
# On macOS: brew install lcov
# On Windows: choco install lcov
# On Linux: sudo apt-get install lcov

# Generate HTML report
genhtml coverage/lcov.info -o coverage/html

# Open report (macOS/Linux)
open coverage/html/index.html

# Open report (Windows)
start coverage/html/index.html
```

### Run Widget Tests Only
```bash
flutter test test/ --tags widget
```

### Run Unit Tests Only
```bash
flutter test test/ --tags unit
```

---

## 📁 Test Structure

### Folder Organization
```
test/
├── features/
│   ├── appointments/
│   │   ├── reschedule_appointment_test.dart
│   │   └── waitlist_test.dart
│   ├── notifications/
│   │   ├── notification_history_test.dart
│   │   └── notification_widget_test.dart
│   └── admin/
│       └── (future tests)
├── helpers/
│   └── test_helpers.dart
└── mocks/
    └── (generated mocks)
```

### Test File Naming Convention
- Unit tests: `feature_name_test.dart`
- Widget tests: `widget_name_widget_test.dart`
- Integration tests: `feature_name_integration_test.dart`

---

## 🔧 Test Setup

### Dependencies (in pubspec.yaml)
```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  mockito: ^5.4.0
  build_runner: ^2.4.0
```

### Generating Mocks
```bash
# Generate mocks for all test files
flutter pub run build_runner build

# Watch for changes and regenerate
flutter pub run build_runner watch
```

---

## 📝 Writing Tests

### Unit Test Template
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

// Generate mocks
@GenerateMocks([YourRepository, YourService])
import 'your_test.mocks.dart';

void main() {
  group('Feature Name Tests', () {
    late YourUseCase useCase;
    late MockYourRepository mockRepository;

    setUp(() {
      mockRepository = MockYourRepository();
      useCase = YourUseCase(mockRepository);
    });

    test('should return expected result', () async {
      // Arrange
      when(mockRepository.someMethod(any))
          .thenAnswer((_) async => expectedResult);

      // Act
      final result = await useCase.call(parameter);

      // Assert
      expect(result, equals(expectedResult));
      verify(mockRepository.someMethod(any)).called(1);
    });
  });
}
```

### Widget Test Template
```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Widget Name Tests', () {
    testWidgets('should display expected content', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: YourWidget(/* parameters */),
          ),
        ),
      );

      // Assert
      expect(find.text('Expected Text'), findsOneWidget);
      expect(find.byIcon(Icons.some_icon), findsOneWidget);
    });

    testWidgets('should handle user interaction', (tester) async {
      // Arrange
      var tapped = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: YourWidget(
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      // Act
      await tester.tap(find.byType(YourWidget));
      await tester.pumpAndSettle();

      // Assert
      expect(tapped, isTrue);
    });
  });
}
```

---

## ✅ Test Coverage Goals

### Target Coverage by Layer
- **Domain Layer (Use Cases)**: 90%+
- **Data Layer (Repositories)**: 80%+
- **Presentation Layer (Providers)**: 75%+
- **UI Layer (Widgets)**: 70%+

### Current Coverage (Phase 2)
| Feature | Unit Tests | Widget Tests | Coverage |
|---------|-----------|--------------|----------|
| Reschedule Appointments | ✅ | ⏳ | ~85% |
| Waitlist System | ✅ | ⏳ | ~80% |
| Notification History | ✅ | ✅ | ~90% |
| Admin Dashboard | ⏳ | ⏳ | ~0% |
| Doctor Management | ⏳ | ⏳ | ~0% |
| Department Management | ⏳ | ⏳ | ~0% |
| Analytics | ⏳ | ⏳ | ~0% |

---

## 🎯 Testing Best Practices

### 1. Test Naming
```dart
// Good ✓
test('should return appointments when repository call succeeds')

// Bad ✗
test('test1')
```

### 2. Arrange-Act-Assert Pattern
```dart
test('description', () {
  // Arrange - Set up test data and mocks
  final input = 'test data';
  when(mock.method(any)).thenReturn(expected);

  // Act - Execute the code under test
  final result = useCase.call(input);

  // Assert - Verify the results
  expect(result, equals(expected));
});
```

### 3. Mock External Dependencies
```dart
// Always mock:
- Firebase services (Firestore, Auth, Messaging)
- Repositories
- External services

// Never mock:
- Models
- Use cases (test them directly)
- Value objects
```

### 4. Test Edge Cases
```dart
group('Validation Tests', () {
  test('should handle null input');
  test('should handle empty string');
  test('should handle negative numbers');
  test('should handle max values');
  test('should throw exception for invalid data');
});
```

### 5. Use Descriptive Test Data
```dart
// Good ✓
final appointment = AppointmentModel(
  id: 'test_appointment_123',
  userId: 'test_user_456',
  // ... other fields
);

// Bad ✗
final appointment = AppointmentModel(
  id: 'a',
  userId: 'b',
  // ... other fields
);
```

---

## 🐛 Common Testing Issues & Solutions

### Issue 1: "MissingPluginException"
**Problem**: Firebase plugins not initialized in tests

**Solution**:
```dart
TestWidgetsFlutterBinding.ensureInitialized();
setupFirebaseAuthMocks(); // Create a helper for this
```

### Issue 2: "Null check operator used on null value"
**Problem**: Mock not properly configured

**Solution**:
```dart
// Always set up mocks in setUp()
setUp(() {
  mockRepository = MockRepository();
  when(mockRepository.someMethod(any))
      .thenAnswer((_) async => defaultValue);
});
```

### Issue 3: "A widget was disposed during pumpAndSettle"
**Problem**: Async operations not completing

**Solution**:
```dart
// Use pump() with explicit duration
await tester.pump(const Duration(seconds: 1));

// Or handle the Future properly
await tester.pumpWidget(widget);
await tester.pumpAndSettle();
```

### Issue 4: "Type 'Null' is not a subtype of type 'Future'"
**Problem**: Mock method not configured with thenAnswer

**Solution**:
```dart
// For async methods, always use thenAnswer
when(mockRepository.asyncMethod(any))
    .thenAnswer((_) async => result); // Not thenReturn!
```

---

## 📊 Test Metrics

### What to Measure
1. **Code Coverage** - % of code executed by tests
2. **Test Count** - Number of test cases
3. **Test Duration** - Time to run all tests
4. **Flakiness** - % of tests that fail intermittently

### Monitoring
```bash
# Run tests with verbosity
flutter test --reporter expanded

# Check test performance
flutter test --machine > test_results.json
```

---

## 🔄 CI/CD Integration

### GitHub Actions Example
```yaml
name: Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.16.0'
      
      - name: Install dependencies
        run: flutter pub get
      
      - name: Run tests
        run: flutter test --coverage
      
      - name: Upload coverage
        uses: codecov/codecov-action@v3
        with:
          file: ./coverage/lcov.info
```

---

## 📚 Testing Resources

### Flutter Testing Documentation
- [Flutter Testing Guide](https://docs.flutter.dev/testing)
- [Widget Testing](https://docs.flutter.dev/cookbook/testing/widget/introduction)
- [Integration Testing](https://docs.flutter.dev/cookbook/testing/integration/introduction)

### Mockito Documentation
- [Mockito Package](https://pub.dev/packages/mockito)
- [Mockito Documentation](https://pub.dev/documentation/mockito/latest/)

### Best Practices
- [Effective Dart: Testing](https://dart.dev/guides/language/effective-dart/testing)
- [Flutter Testing Best Practices](https://flutter.dev/docs/testing/best-practices)

---

## ✅ Test Checklist

Before pushing code, ensure:
- [ ] All tests pass (`flutter test`)
- [ ] New features have unit tests
- [ ] New widgets have widget tests
- [ ] Critical flows have integration tests
- [ ] Coverage meets minimum thresholds
- [ ] No flaky tests
- [ ] Mocks are properly generated
- [ ] Test names are descriptive
- [ ] Edge cases are covered

---

## 🎓 Testing Philosophy

### Why We Test
1. **Confidence** - Changes don't break existing functionality
2. **Documentation** - Tests show how code should be used
3. **Quality** - Catch bugs before users do
4. **Refactoring** - Safe to improve code structure
5. **Speed** - Fast feedback loop during development

### What to Test
- ✅ Business logic (use cases, repositories)
- ✅ Data transformations (models, mappers)
- ✅ UI behavior (user interactions, displays)
- ✅ Edge cases (nulls, errors, limits)
- ❌ Third-party code (Firebase, packages)
- ❌ Trivial code (getters, setters)

### Test Pyramid
```
       /\
      /  \      Integration Tests (Few)
     /----\     Widget Tests (Some)
    /------\    Unit Tests (Many)
   /--------\
```

---

**Last Updated**: December 19, 2025
**Version**: 1.0.0
**Maintainer**: Development Team


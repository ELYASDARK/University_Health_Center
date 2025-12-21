# University Health Center - Setup Guide

## Phase 1 Implementation Complete ✅

This guide will help you set up and run the University Health Center Appointment Booking System.

## Prerequisites

- Flutter SDK (version 3.9.2 or higher)
- Dart SDK
- Firebase account
- Android Studio / VS Code with Flutter extensions
- Android Emulator or iOS Simulator (or physical device)

## Firebase Setup

### 1. Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add project"
3. Follow the setup wizard
4. Enable Google Analytics (optional)

### 2. Add Firebase to Your App

#### For Android:
1. In Firebase Console, click "Add app" → Android
2. Enter your package name: `com.example.university_health_center`
3. Download `google-services.json`
4. Place it in `android/app/` directory

#### For iOS:
1. In Firebase Console, click "Add app" → iOS
2. Enter your bundle ID
3. Download `GoogleService-Info.plist`
4. Add it to `ios/Runner/` directory

#### For Web:
1. In Firebase Console, click "Add app" → Web
2. Copy the Firebase configuration
3. Update `firebase_options.dart` with your configuration

### 3. Enable Firebase Services

In Firebase Console, enable the following services:

#### Authentication
1. Go to Authentication → Sign-in method
2. Enable "Email/Password" provider

#### Firestore Database
1. Go to Firestore Database
2. Click "Create database"
3. Start in **test mode** (for development)
4. Choose a location close to your users

#### Cloud Messaging (FCM)
1. Go to Cloud Messaging
2. Copy your Server Key (for future use)

### 4. Set Up Firestore Security Rules

Go to Firestore Database → Rules and paste the following:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only read/write their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Appointments - users can only see their own
    match /appointments/{appointmentId} {
      allow read: if request.auth != null && 
                     (resource.data.userId == request.auth.uid ||
                      get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role in ['admin', 'doctor']);
      allow create: if request.auth != null && request.resource.data.userId == request.auth.uid;
      allow update, delete: if request.auth != null && 
                               (resource.data.userId == request.auth.uid ||
                                get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin');
    }
    
    // Departments - read only for all authenticated users
    match /departments/{departmentId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && 
                      get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
    }
    
    // Doctors - read only for all authenticated users
    match /doctors/{doctorId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && 
                      get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
    }
    
    // Notifications - users can only read their own
    match /notifications/{notificationId} {
      allow read: if request.auth != null && resource.data.userId == request.auth.uid;
      allow write: if request.auth != null;
    }
  }
}
```

## Installation Steps

### 1. Clone and Install Dependencies

```bash
cd c:\Develop\Files\university_health_center
flutter pub get
```

### 2. Update Firebase Configuration

The app uses FlutterFire CLI to generate Firebase configuration. If you need to regenerate:

```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Run configuration
flutterfire configure
```

### 3. Create Environment File (Optional)

Create a `.env` file in the root directory (already gitignored):

```
FIREBASE_API_KEY=your_api_key_here
FIREBASE_PROJECT_ID=your_project_id_here
FIREBASE_APP_ID=your_app_id_here
FIREBASE_MESSAGING_SENDER_ID=your_sender_id_here
```

## Populate Sample Data

To test the app, you need to add sample data to Firestore.

### Add Departments

Go to Firestore Database → Start collection → `departments`

```json
{
  "name": "General Practice",
  "description": "Primary care and general health consultations",
  "services": ["Check-ups", "Vaccinations", "Health Certificates"],
  "imageUrl": null,
  "isActive": true
}
```

Add more departments (Dental, Mental Health, etc.)

### Add Doctors

Go to Firestore Database → Start collection → `doctors`

First, create a user account through the app, then add a doctor document:

```json
{
  "userId": "user_id_from_auth",
  "name": "Dr. John Smith",
  "email": "doctor@example.com",
  "specialization": "General Practitioner",
  "departmentId": "department_id_here",
  "availability": {
    "monday": true,
    "tuesday": true,
    "wednesday": true,
    "thursday": true,
    "friday": true,
    "saturday": false,
    "sunday": false
  },
  "rating": 4.5,
  "bio": "Experienced general practitioner with 10 years of practice",
  "imageUrl": null
}
```

## Running the App

### Android
```bash
flutter run
```

### iOS
```bash
flutter run -d ios
```

### Web
```bash
flutter run -d chrome
```

## Testing the App

### 1. Register a New User
- Open the app
- Click "Sign Up"
- Fill in the registration form
- Choose "Student" or "Staff" role
- Complete registration

### 2. Book an Appointment
- Login with your credentials
- Tap "Book Appointment" on home screen
- Select a department
- Choose a doctor
- Pick a date and time
- Enter reason for visit
- Confirm booking

### 3. View Appointments
- Go to "My Appointments" from home screen or drawer
- See upcoming, past, and cancelled appointments
- Cancel appointments if needed

### 4. Manage Profile
- Open drawer menu
- Tap "Profile"
- View your personal information
- Sign out when done

## Features Implemented (Phase 1)

### ✅ Week 1-2: Setup & Authentication
- Project setup with Clean Architecture
- Firebase integration
- Email/password authentication
- User registration with role selection
- Login screen
- Password reset functionality
- Profile management screen

### ✅ Week 3-4: Core Booking Features
- Department listing and browsing
- Doctor profiles and selection
- Available time slots display
- Appointment booking flow
- Appointment cancellation
- Real-time data with Firestore

### ✅ Week 5-6: User Interface
- Home dashboard with quick actions
- Appointment history with tabs (Upcoming/Past/Cancelled)
- Profile screen with user details
- Department browsing with service listing
- Doctor selection with ratings
- Modern Material Design 3 UI

### ✅ Week 7-8: Notifications & Infrastructure
- Firebase Cloud Messaging (FCM) setup
- Local notifications configuration
- Notification service implementation
- App-wide state management with Provider
- Error handling and loading states
- Form validation
- Responsive UI components

## Project Structure

```
lib/
├── app/
│   ├── routes/         # App routing configuration
│   └── themes/         # App theme and styling
├── core/
│   ├── constants/      # App constants
│   ├── errors/         # Error handling (exceptions, failures)
│   ├── services/       # Core services (Firebase, notifications)
│   ├── utils/          # Utilities (validators, date formatter)
│   └── widgets/        # Reusable widgets
├── features/
│   ├── auth/           # Authentication feature
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── appointments/   # Appointments feature
│   ├── departments/    # Departments feature
│   ├── doctors/        # Doctors feature
│   ├── home/           # Home dashboard
│   └── profile/        # User profile
└── shared/
    └── models/         # Shared data models

```

## Troubleshooting

### Build Errors

1. **Gradle build fails (Android)**
   ```bash
   cd android
   ./gradlew clean
   cd ..
   flutter clean
   flutter pub get
   ```

2. **iOS build fails**
   ```bash
   cd ios
   pod install
   cd ..
   flutter clean
   flutter pub get
   ```

### Firebase Connection Issues

1. Verify `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) are in correct locations
2. Check Firebase Console for correct package name/bundle ID
3. Ensure Firebase services are enabled

### Notification Issues

1. For Android, ensure you have proper permissions in `AndroidManifest.xml`
2. For iOS, ensure you have notification capabilities enabled
3. Test on physical device (notifications don't work on iOS simulator)

## Next Steps (Phase 2 & 3)

- Advanced booking features (rescheduling, waitlist)
- Admin panel for managing doctors and departments
- Enhanced notification preferences
- University SSO integration
- Medical history and document management
- Advanced analytics dashboard
- Multi-language support

## Support

For issues or questions:
1. Check the main README.md for project documentation
2. Review .cursorrules for coding standards
3. Check Firebase Console for service status

## License

This project is for educational purposes.


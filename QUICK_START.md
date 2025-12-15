# Quick Start Guide

Get the University Health Center app running in 5 minutes!

## ⚡ Prerequisites

- Flutter SDK 3.9.2+
- Firebase account (free tier is fine)
- Android Studio or VS Code
- Git

## 🚀 Setup Steps

### 1. Firebase Setup (5 minutes)

1. **Create Firebase Project**
   - Go to https://console.firebase.google.com/
   - Click "Add project" → Enter name → Continue
   - Disable Google Analytics (optional) → Create project

2. **Enable Services**
   ```
   Authentication → Sign-in method → Email/Password → Enable
   Firestore Database → Create database → Test mode → Start
   Cloud Messaging → (Already enabled)
   ```

3. **Add Your App**
   
   **For Android:**
   - Click Android icon
   - Package name: `com.example.university_health_center`
   - Download `google-services.json` → Place in `android/app/`
   
   **For iOS:**
   - Click iOS icon  
   - Bundle ID: `com.example.universityHealthCenter`
   - Download `GoogleService-Info.plist` → Place in `ios/Runner/`

### 2. Project Setup (2 minutes)

```bash
# Navigate to project
cd c:\Develop\Files\university_health_center

# Get dependencies
flutter pub get

# Configure Firebase (if not already done)
dart pub global activate flutterfire_cli
flutterfire configure
```

### 3. Add Sample Data (2 minutes)

**Add a Department:**
1. Go to Firestore Console
2. Start collection: `departments`
3. Add document:
```json
{
  "name": "General Practice",
  "description": "Primary care and health consultations",
  "services": ["Check-ups", "Vaccinations", "Health Certificates"],
  "imageUrl": null,
  "isActive": true
}
```

**Add a Doctor:**
1. First register a user through the app
2. Copy the user UID from Authentication tab
3. Add to `doctors` collection:
```json
{
  "userId": "your-user-uid",
  "name": "Dr. John Smith",
  "email": "doctor@example.com",
  "specialization": "General Practitioner",
  "departmentId": "your-department-id",
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
  "bio": "Experienced GP with 10 years of practice",
  "imageUrl": null
}
```

### 4. Run the App

```bash
# For Android
flutter run

# For iOS
flutter run -d ios

# For Web
flutter run -d chrome
```

## ✅ Test the Features

1. **Register**: Create a student/staff account
2. **Browse**: View departments and doctors
3. **Book**: Make an appointment
4. **Manage**: View and cancel appointments
5. **Profile**: Check your profile

## 🎯 Main Screens

- **Home** → Dashboard with quick actions
- **Departments** → Browse medical departments
- **Doctors** → View available doctors
- **Book Appointment** → Schedule visits
- **My Appointments** → Manage bookings
- **Profile** → User settings

## 🔧 Troubleshooting

**Build Error?**
```bash
flutter clean
flutter pub get
flutter run
```

**Firebase Connection Issue?**
- Verify `google-services.json` / `GoogleService-Info.plist` location
- Check Firebase project matches package name

**No Data Showing?**
- Add sample departments and doctors in Firestore Console
- Ensure Firestore is in test mode during development

## 📱 Default Test Accounts

Create your own accounts - the app supports:
- **Students** (with Student ID)
- **Staff** (without Student ID)
- **Admins** (add role: "admin" in Firestore)
- **Doctors** (add to doctors collection)

## 🎓 What's Included

✅ User authentication (Email/Password)  
✅ Department browsing  
✅ Doctor listings  
✅ Appointment booking  
✅ Appointment management  
✅ User profile  
✅ Push notifications setup  
✅ Real-time updates  
✅ Material Design 3 UI  

## 📖 Need More Help?

- **Full Setup**: See `SETUP_GUIDE.md`
- **Implementation Details**: See `IMPLEMENTATION_SUMMARY.md`
- **Project Overview**: See `README.md`
- **Coding Standards**: See `.cursorrules`

## 🎉 You're Ready!

The app is now running. Happy coding!

---

**Questions?** Check the documentation files or Firebase Console logs.


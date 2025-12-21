# University SSO - Quick Start Guide

## 🚀 Getting Started

This guide will help you quickly set up and test the University SSO integration.

## ⚡ 5-Minute Setup (Mock Mode)

For immediate testing without an actual OAuth provider:

### 1. Enable Mock SSO

Edit `lib/core/config/sso_config.dart`:

```dart
static const bool useMockSSO = true;
```

### 2. Run the App

```bash
flutter run
```

### 3. Test SSO

1. Open the login screen
2. Click **"Sign in with University Account"**
3. Wait 2 seconds (simulated OAuth flow)
4. You'll be logged in with a mock university account

**Mock User Credentials:**
- Email: `student@university.edu`
- University ID: `S12345678`
- Type: Student
- Verified: ✅ Yes

---

## 🔧 Production Setup

### Step 1: Get OAuth Credentials

Contact your university IT department to:
1. Register your app as an OAuth client
2. Get `clientId` and `clientSecret`
3. Register redirect URI: `universityhealth://oauth-callback`
4. Request required scopes: `openid`, `profile`, `email`, `student_id`

### Step 2: Configure OAuth Endpoints

Edit `lib/core/config/sso_config.dart`:

```dart
// Replace with your actual university endpoints
static const String authorizationEndpoint = 
    'https://YOUR_UNIVERSITY.edu/oauth/authorize';

static const String tokenEndpoint = 
    'https://YOUR_UNIVERSITY.edu/oauth/token';

static const String userInfoEndpoint = 
    'https://YOUR_UNIVERSITY.edu/oauth/userinfo';

// Add your credentials
static const String clientId = 'YOUR_CLIENT_ID';
static const String clientSecret = 'YOUR_CLIENT_SECRET'; // Optional with PKCE

// Disable mock mode
static const bool useMockSSO = false;
```

### Step 3: Configure Deep Linking

**Android** - Edit `android/app/src/main/AndroidManifest.xml`:

Add inside `<activity android:name=".MainActivity">`:

```xml
<intent-filter>
  <action android:name="android.intent.action.VIEW" />
  <category android:name="android.intent.category.DEFAULT" />
  <category android:name="android.intent.category.BROWSABLE" />
  <data
    android:scheme="universityhealth"
    android:host="oauth-callback" />
</intent-filter>
```

**iOS** - Edit `ios/Runner/Info.plist`:

Add before `</dict>`:

```xml
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleTypeRole</key>
    <string>Editor</string>
    <key>CFBundleURLName</key>
    <string>universityhealth</string>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>universityhealth</string>
    </array>
  </dict>
</array>
```

### Step 4: Configure Email Domains

Edit `lib/core/config/sso_config.dart`:

```dart
static const List<String> allowedEmailDomains = [
  'university.edu',              // Main domain
  'students.university.edu',     // Student emails
  'staff.university.edu',        // Staff emails
];
```

### Step 5: Test Production SSO

```bash
flutter run
```

1. Click **"Sign in with University Account"**
2. Browser opens with university login page
3. Enter university credentials
4. Grant permissions
5. App automatically signs you in

---

## 🎯 Common Configurations

### Configuration 1: University with PKCE Support

```dart
// No client secret needed with PKCE
static const String clientId = 'your_client_id';
static const String clientSecret = ''; // Leave empty
static const bool usePKCE = true;
```

### Configuration 2: University without PKCE

```dart
static const String clientId = 'your_client_id';
static const String clientSecret = 'your_client_secret';
static const bool usePKCE = false;
```

### Configuration 3: Multiple User Types

```dart
static const List<String> allowedUserTypes = [
  'student',
  'staff',
  'faculty',
  'visiting_scholar',
];
```

---

## 🧪 Testing Checklist

### Mock Mode Testing

- [ ] SSO button appears on login screen
- [ ] Click SSO button triggers 2-second delay
- [ ] Successfully logs in with mock user
- [ ] Redirects to home screen
- [ ] User profile shows verified badge
- [ ] FCM token saved for notifications

### Production Mode Testing

- [ ] SSO button appears on login screen
- [ ] Click SSO button opens browser
- [ ] University login page loads
- [ ] Can enter credentials
- [ ] Redirects back to app after login
- [ ] Successfully creates/signs in user
- [ ] University ID saved in Firestore
- [ ] Email domain validated
- [ ] User type validated
- [ ] Verification status set to true

---

## 📱 User Features

### Available SSO Operations

1. **Sign in with SSO** (new users)
   - Creates Firebase Auth account
   - Creates Firestore profile
   - Sets verified status to true

2. **Sign in with SSO** (existing users)
   - Updates profile with latest SSO data
   - Maintains existing appointments and data

3. **Link SSO to existing account**
   - Go to Profile Settings
   - Click "Link University Account"
   - Complete SSO flow
   - Account linked successfully

4. **Unlink SSO from account**
   - Go to Profile Settings
   - Click "Unlink University Account"
   - SSO removed, email/password still works

---

## 🔍 Debugging

### Enable Debug Logging

Edit `lib/core/config/sso_config.dart`:

```dart
static const bool enableDebugLogging = true;
```

View logs in console:
- Authorization URL
- Callback URL
- User info response
- Validation results
- Token refresh events

### Common Issues

**Issue**: "SSO is not properly configured"

```dart
// Check these values are not default
static const String clientId = 'YOUR_CLIENT_ID'; // ❌ Change this
```

**Issue**: "Email domain not allowed"

```dart
// Add user's email domain
static const List<String> allowedEmailDomains = [
  'university.edu',
  'YOUR_USER_DOMAIN.edu', // ✅ Add this
];
```

**Issue**: "OAuth callback not received"

```bash
# Verify deep linking configuration
# Android: Check AndroidManifest.xml
# iOS: Check Info.plist
```

---

## 📊 Feature Overview

### What's Included

✅ **OAuth 2.0 Integration** - Industry standard authentication  
✅ **PKCE Support** - Enhanced security for mobile apps  
✅ **Deep Linking** - Seamless OAuth callback handling  
✅ **Domain Validation** - Ensure university affiliations  
✅ **Type Validation** - Restrict access by user type  
✅ **Mock Mode** - Test without actual OAuth provider  
✅ **Auto-Verification** - SSO users automatically verified  
✅ **Link/Unlink** - Manage SSO connections  
✅ **Token Management** - Automatic refresh and revocation  

### What You Need

📋 **From University IT:**
- OAuth Client ID
- OAuth Client Secret (if not using PKCE)
- Authorization Endpoint URL
- Token Endpoint URL
- User Info Endpoint URL
- Approved Redirect URI
- Available Scopes

📱 **Technical Requirements:**
- Flutter 3.0+
- Firebase Auth enabled
- Cloud Firestore enabled
- Deep linking configured
- University OAuth provider

---

## 🎓 Example Configurations

### Harvard University (Example)

```dart
static const String authorizationEndpoint = 
    'https://oauth.harvard.edu/authorize';
static const String tokenEndpoint = 
    'https://oauth.harvard.edu/token';
static const String userInfoEndpoint = 
    'https://oauth.harvard.edu/userinfo';
static const String clientId = 'harvard_health_app';
static const List<String> allowedEmailDomains = [
  'harvard.edu',
  'college.harvard.edu',
];
```

### MIT (Example)

```dart
static const String authorizationEndpoint = 
    'https://oidc.mit.edu/authorize';
static const String tokenEndpoint = 
    'https://oidc.mit.edu/token';
static const String userInfoEndpoint = 
    'https://oidc.mit.edu/userinfo';
static const String clientId = 'mit_health_center';
static const List<String> allowedEmailDomains = [
  'mit.edu',
  'alum.mit.edu',
];
```

---

## 📞 Support

### Resources

- **Full Documentation**: See `TASK1_SSO_IMPLEMENTATION.md`
- **Configuration**: `lib/core/config/sso_config.dart`
- **OAuth Service**: `lib/core/services/oauth_service.dart`
- **SSO Datasource**: `lib/features/auth/data/datasources/sso_auth_datasource.dart`

### Next Steps

After setting up SSO:

1. **Test thoroughly** with real university accounts
2. **Configure Firebase Security Rules** to protect SSO user data
3. **Set up backend endpoints** for custom token generation (optional)
4. **Monitor SSO usage** via Firebase Analytics
5. **Collect user feedback** on SSO experience

---

## ✨ Benefits

### For Users
- 🚀 **One-click sign in** - No passwords to remember
- ✅ **Automatic verification** - Instant university validation
- 🔒 **Secure** - OAuth 2.0 + PKCE standard
- 📱 **Seamless** - Native mobile experience

### For Administrators
- 📊 **Centralized authentication** - University manages credentials
- 🔐 **Enhanced security** - No password storage
- 📈 **Higher adoption** - Easier onboarding
- 🎯 **Student verification** - Automatic eligibility confirmation

---

**Ready to launch?** Follow the steps above and you'll have SSO running in minutes!

For detailed technical documentation, see `TASK1_SSO_IMPLEMENTATION.md`.


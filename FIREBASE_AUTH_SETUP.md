# Firebase Authentication Setup (Prepared)

This project is now prepared for Firebase auth integration.

## Already added in code

- `firebase_core` + `firebase_auth` dependencies
- Firebase initialization in app startup
- Auth service and auth cubit
- Login/Signup pages connected to auth cubit
- Splash route checks signed-in user and redirects
- Android Google Services Gradle plugin setup

## Final setup you need to do

### 1) Configure Firebase project

1. Open Firebase Console
2. Create/select project
3. Add Android app with package name:
   - `com.example.plant_health`
4. Add iOS app with bundle id:
   - `com.example.plantHealth` (or your actual bundle id from Xcode)

### 2) Use FlutterFire CLI (recommended)

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

This generates `lib/firebase_options.dart` and updates native config files.

### 3) Add native files (if not auto-added)

- Android: `android/app/google-services.json`
- iOS: `ios/Runner/GoogleService-Info.plist`

### 4) Enable auth sign-in method

In Firebase Console → Authentication → Sign-in method:
- Enable **Email/Password**

> Current implementation maps phone number to internal email format:
> `digits@smartkrishi.app`
> so your existing UI can stay as phone + password.

### 5) Run app

```bash
flutter pub get
flutter run
```

## Notes

- This is a prepared baseline for auth.
- If you want real OTP phone auth next, that can be added in the next step.

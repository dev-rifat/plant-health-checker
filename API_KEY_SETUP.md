# 🔑 API KEY SETUP - EXACT INSTRUCTIONS

## ⚠️ IMPORTANT: This is the FIRST step to make the app work!

---

## Step 1: Get Your Gemini API Key (2 minutes)

### Visit Google AI Studio
```
URL: https://aistudio.google.com
```

### Create API Key
1. Click "Create API Key"
2. Select project (or create new)
3. Copy the generated API key
4. Keep it safe!

### Example API Key Format
```
AIzaSyD1234567890abcdefghijklmnopqrstuv
```

---

## Step 2: Update the Code ⭐ CRITICAL

### File Location
```
lib/core/di/injection.dart
```

### Open the File
```dart
// This is what you'll see:

import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plant_health/features/plant_detection/data/datasources/plant_detection_remote_datasource.dart';
import 'package:plant_health/features/plant_detection/data/repositories/plant_detection_repository_impl.dart';
import 'package:plant_health/features/plant_detection/domain/repositories/plant_detection_repository.dart';
import 'package:plant_health/features/plant_detection/domain/usecases/analyze_plant_image_usecase.dart';
import 'package:plant_health/features/plant_detection/presentation/bloc/plant_detection_bloc.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  // Register ImagePicker
  getIt.registerSingleton<ImagePicker>(ImagePicker());

  // Register Remote Data Sources
  getIt.registerSingleton<PlantDetectionRemoteDataSource>(
    PlantDetectionRemoteDataSourceImpl(
      'AIzaSyC-A8v_cWVKk5vX0p5nNXNqNdOqkZ5U7-E', // ← THIS IS THE PLACEHOLDER!
    ),
  );
  
  // ... rest of code
}
```

### Find This Line
```dart
'AIzaSyC-A8v_cWVKk5vX0p5nNXNqNdOqkZ5U7-E'
```

### Replace With Your API Key
```dart
'YOUR_ACTUAL_API_KEY_HERE'
```

### Example After Update
```dart
PlantDetectionRemoteDataSourceImpl(
  'AIzaSyD1234567890abcdefghijklmnopqrstuv', // ← Your real key
),
```

---

## Visual Guide

### BEFORE (Placeholder)
```dart
PlantDetectionRemoteDataSourceImpl(
  'AIzaSyC-A8v_cWVKk5vX0p5nNXNqNdOqkZ5U7-E',  // ❌ This won't work
),
```

### AFTER (Your Key)
```dart
PlantDetectionRemoteDataSourceImpl(
  'AIzaSyD1234567890abcdefghijklmnopqrstuv',  // ✅ Now it works!
),
```

---

## Step-by-Step Update Instructions

### Using VS Code
1. **Open File**: `lib/core/di/injection.dart`
2. **Find** (Ctrl+F): `'AIzaSyC-A8v_cWVKk5vX0p5nNXNqNdOqkZ5U7-E'`
3. **Select** the entire string (API key)
4. **Replace** with your actual API key
5. **Save** (Ctrl+S)

### Using Android Studio
1. **Open File**: `lib/core/di/injection.dart`
2. **Find** (Cmd+F on Mac / Ctrl+F on Windows): Copy the placeholder key
3. **Replace All**
4. **Paste** your actual API key
5. **Save**

### Using Command Line
```bash
# Navigate to project
cd /Users/rifat/StudioProjects/plant_health

# Edit the file (use nano or vim)
nano lib/core/di/injection.dart

# OR on Mac
vim lib/core/di/injection.dart
```

---

## Line Numbers Reference

**File**: `lib/core/di/injection.dart`

| Line Range | Content |
|-----------|---------|
| 1-10 | Imports |
| 12 | `final getIt = GetIt.instance;` |
| 14-20 | `void setupServiceLocator() {` |
| 15-18 | Image picker registration |
| **19-23** | **← YOUR API KEY IS HERE!** |
| 25+ | Rest of setup |

**EXACT LINE**: Around line 21-22

---

## Common Issues & Fixes

### ❌ Error: "API key invalid"
**Solution**: 
- [ ] Copy API key again from aistudio.google.com
- [ ] Make sure no extra spaces before/after
- [ ] Check the key is complete (should be ~43 characters)
- [ ] Update and save file

### ❌ Error: "401 Unauthorized"
**Solution**:
- [ ] API key might be expired
- [ ] Create new key at aistudio.google.com
- [ ] Update in injection.dart
- [ ] Restart app

### ❌ App shows "Error analyzing plant image"
**Solution**:
- [ ] Check if API key is correct
- [ ] Check internet connection
- [ ] Check API quotas in Google Console
- [ ] Check if API is enabled

### ❌ Can't find the file
**Solution**:
- [ ] Make sure you're in project root
- [ ] Path should be: `lib/core/di/injection.dart`
- [ ] Use Ctrl+P in VS Code to open file quickly

---

## Verification Checklist

After updating the API key:

```
☐ File saved: lib/core/di/injection.dart
☐ API key updated (not the placeholder)
☐ No extra quotes or spaces
☐ File compiles without errors
☐ Run: flutter pub get
☐ Run: flutter run
☐ Test with a plant image
☐ See results displayed
```

---

## Security Reminders ⚠️

### ✅ Safe Practices
- ✅ Update locally before running
- ✅ Use environment variables for production
- ✅ Don't commit key to GitHub

### ❌ Don't Do This
- ❌ Don't hardcode in final build
- ❌ Don't share key publicly
- ❌ Don't commit to GitHub
- ❌ Don't use in open-source repos

### 🔒 For Production
Create `.env` file:
```
GEMINI_API_KEY=your_api_key_here
```

Then update code:
```dart
// Install: flutter pub add flutter_dotenv
import 'package:flutter_dotenv/flutter_dotenv.dart';

final apiKey = dotenv.env['GEMINI_API_KEY']!;
```

---

## API Key Format Verification

Your API key should:
- [ ] Start with `AIzaSy`
- [ ] Be approximately 39 characters
- [ ] Contain only alphanumeric characters and hyphens
- [ ] Be enclosed in single quotes

### Example Valid Key
```
AIzaSyD_1234567890abcdefghijklmnopqrstuv
          ↑ Starts with AIzaSy
```

### Example Invalid Key
```
❌ AIzaSyC-A8v_cWVKk5vX0p5nNXNqNdOqkZ5U7-E (placeholder - won't work)
❌ your_key_here (not real format)
❌ MyApiKey123 (wrong format)
```

---

## What Happens Next

### After Updating API Key:

1. **Save File**
   ```
   lib/core/di/injection.dart saved ✅
   ```

2. **Get Dependencies**
   ```bash
   flutter pub get
   ```

3. **Run App**
   ```bash
   flutter run
   ```

4. **Test**
   - Take/select plant image
   - Tap "Analyze"
   - Wait for AI response
   - See results!

---

## Still Have Questions?

| Issue | Solution | File |
|-------|----------|------|
| Where is API key? | Line 21-22 of injection.dart | `lib/core/di/injection.dart` |
| How to get API key? | Visit aistudio.google.com | Browser |
| How to update? | Replace placeholder with your key | `lib/core/di/injection.dart` |
| API key format? | Should start with AIzaSy | None |
| Still errors? | Check SETUP_GUIDE.md | `SETUP_GUIDE.md` |

---

## Complete Checklist

```
BEFORE YOU RUN THE APP:

☐ Get Gemini API key from aistudio.google.com
☐ Copy the API key (should start with AIzaSy)
☐ Open lib/core/di/injection.dart
☐ Find line: 'AIzaSyC-A8v_cWVKk5vX0p5nNXNqNdOqkZ5U7-E'
☐ Replace with your actual API key
☐ Save the file (Ctrl+S)
☐ Run: flutter pub get
☐ Run: flutter run
☐ Test by selecting a plant image
☐ See the analysis results!
```

---

## Visual Code Location

```dart
lib/core/di/injection.dart
                          ↓
        void setupServiceLocator() {
          // ... code ...
          
          getIt.registerSingleton<PlantDetectionRemoteDataSource>(
            PlantDetectionRemoteDataSourceImpl(
              'YOUR_API_KEY_HERE',  ← ⭐ UPDATE THIS LINE!
            ),
          );
          
          // ... rest of code ...
        }
```

---

## Example Complete Setup

### Step 1: Get Key ✅
```
Went to aistudio.google.com
Got key: AIzaSyD_my_actual_key_1234567890
```

### Step 2: Update Code ✅
```dart
// File: lib/core/di/injection.dart
PlantDetectionRemoteDataSourceImpl(
  'AIzaSyD_my_actual_key_1234567890',  // Updated!
),
```

### Step 3: Run App ✅
```bash
flutter pub get
flutter run
```

### Step 4: Test ✅
```
App loaded
Captured plant image
Tapped analyze
Received: "Plant is healthy" ✅
```

---

## 🚀 Ready? Let's Go!

1. **Get Your API Key**: https://aistudio.google.com
2. **Update**: `lib/core/di/injection.dart` (line ~21)
3. **Save**: Press Ctrl+S (or Cmd+S)
4. **Run**: `flutter run`
5. **Test**: Select plant image and analyze!

---

**⚠️ CRITICAL REMINDER**: 
Update the API key BEFORE running the app, or it won't work!

---

**Version**: 1.0  
**Status**: ✅ Clear Instructions  
**Updated**: May 12, 2026  

### 🎉 You're Ready to Start! 🌱

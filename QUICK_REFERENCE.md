# Quick Reference Guide

## 🚀 5-Minute Setup

```bash
# 1. Install dependencies
flutter pub get

# 2. Get API key from https://aistudio.google.com

# 3. Edit lib/core/di/injection.dart
# Update: 'YOUR_GEMINI_API_KEY_HERE'

# 4. Run app
flutter run
```

---

## 📁 Important Files

| File | Purpose |
|------|---------|
| `lib/main.dart` | App entry point |
| `lib/core/di/injection.dart` | **← UPDATE API KEY HERE** |
| `lib/features/plant_detection/presentation/pages/plant_detection_page.dart` | Main UI |
| `lib/features/plant_detection/presentation/bloc/plant_detection_bloc.dart` | State management |
| `pubspec.yaml` | Dependencies |

---

## 🎯 Algorithm at a Glance

```
Image Input 📸
    ↓
Base64 Encode
    ↓
Gemini API 🤖
    ↓
Parse Response
    ↓
Display Result ✅❌
```

---

## 🔑 Key API Key Locations

**Get Key**: https://aistudio.google.com

**Update In**: `lib/core/di/injection.dart` (Line ~15)

```dart
PlantDetectionRemoteDataSourceImpl(
  'YOUR_API_KEY_HERE',  // ← Replace this!
),
```

---

## 📱 Platform Permissions

### Android Manifest
File: `android/app/src/main/AndroidManifest.xml`

```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.INTERNET" />
```

### iOS Info.plist
File: `ios/Runner/Info.plist`

```xml
<key>NSCameraUsageDescription</key>
<string>We need camera access</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>We need photo library access</string>
```

---

## 🧬 BLoC States

| State | When | What Shows |
|-------|------|-----------|
| `Initial` | App start | Camera/Gallery buttons |
| `ImagePickedState` | Image selected | Image preview + Analyze |
| `Loading` | Analyzing | Spinner |
| `Success` | Complete | Results card |
| `Error` | Failed | Error message |

---

## 🎨 Color Codes

| Use | Color | Hex |
|-----|-------|-----|
| Primary | Green | #2E7D32 |
| Success | Light Green | #4CAF50 |
| Error | Red | #FF5252 |
| Warning | Orange | #FFC107 |

---

## 🔗 API Endpoint

```
https://generativelanguage.googleapis.com/v1beta/models/gemini-flash-latest:generateContent?key=YOUR_KEY
```

**Method**: POST  
**Content-Type**: application/json  
**Body**: Image as base64 + Prompt

---

## 📊 Project Size

| Metric | Value |
|--------|-------|
| Dart Files | 15+ |
| Core Files | 8 |
| Feature Files | 12+ |
| Lines of Code | ~2000 |
| Documentation | 5 files |

---

## ✅ Quick Checklist

```
☐ flutter pub get
☐ Get API key (aistudio.google.com)
☐ Update API key in injection.dart
☐ Add Android permissions
☐ Add iOS permissions
☐ flutter run
☐ Test with plant image
```

---

## 🆘 Quick Troubleshooting

| Issue | Fix |
|-------|-----|
| Dependency error | `flutter pub get` |
| Camera not working | Check Android/iOS permissions |
| API error | Verify API key is correct |
| Image not uploading | Check internet connection |
| App crashes | `flutter clean` then `flutter run` |

---

## 📚 Documentation Links

- **Setup**: [SETUP_GUIDE.md](SETUP_GUIDE.md)
- **Architecture**: [ARCHITECTURE_DIAGRAM.md](ARCHITECTURE_DIAGRAM.md)
- **Testing**: [TESTING_GUIDE.md](TESTING_GUIDE.md)
- **Summary**: [IMPLEMENTATION_SUMMARY.md](IMPLEMENTATION_SUMMARY.md)

---

## 🌍 UI Strings

| Action | Bengali | English |
|--------|---------|---------|
| Title | ফসলের স্বাস্থ্য পরীক্ষা | Plant Health Check |
| Camera | ক্যামেরা থেকে ধরুন | Take Photo |
| Gallery | গ্যালারি থেকে বেছে নিন | Choose from Gallery |
| Analyze | বিশ্লেষণ করুন | Analyze |
| Disease | রোগের নাম | Disease |
| Treatment | চিকিৎসা | Treatment |
| Healthy | স্বাস্থ্যকর | Healthy |

---

## 🔄 State Flow Diagram

```
┌─────────────┐
│   Initial   │
└──────┬──────┘
       │
   ┌───┴───┐
   │       │
Camera    Gallery
   │       │
   └───┬───┘
       ↓
┌──────────────┐
│ImagePicked   │
└──────┬───────┘
       │
    Analyze
       │
       ↓
┌──────────────┐
│   Loading    │
└──────┬───────┘
       │
   ┌───┴────┐
   ↓        ↓
Success   Error
```

---

## 🎓 Key Classes

| Class | Location | Purpose |
|-------|----------|---------|
| `PlantDetectionBloc` | `presentation/bloc/` | State management |
| `PlantDetectionPage` | `presentation/pages/` | Main screen |
| `PlantAnalysisResult` | `domain/entities/` | Result model |
| `PlantDetectionRemoteDataSource` | `data/datasources/` | API calls |
| `ResultCard` | `presentation/widgets/` | Results display |

---

## 📈 Performance Targets

| Metric | Target |
|--------|--------|
| App Launch | < 3s |
| Image Load | < 1s |
| API Response | 5-15s |
| Memory Usage | < 150MB |

---

## 🔐 Important Security Notes

⚠️ **Never commit API key to Git!**

Options:
1. Use `.env` file (add to `.gitignore`)
2. Use environment variables
3. Store in secure config
4. Use GitHub Secrets for CI/CD

---

## 📞 Quick Support

**API Key Issues?**
- Go to: https://aistudio.google.com
- Create new key
- Copy and paste in `injection.dart`

**Camera Not Working?**
- Check `AndroidManifest.xml`
- Check `Info.plist`
- Restart app
- Check device permissions

**API Errors?**
- Check internet connection
- Verify API key is correct
- Check Google Console quotas
- Review API status

---

## 🚀 Deployment Checklist

```
Pre-Deployment:
☐ Remove debug logs
☐ Update version number
☐ Test on real devices
☐ Check permissions
☐ Verify API key (or use env vars)
☐ Test error scenarios

Deployment:
☐ Build APK/AAB (Android)
☐ Build IPA (iOS)
☐ Upload to stores
☐ Monitor errors
☐ Check API usage
```

---

## 💡 Pro Tips

1. **Image Quality**: Better quality images = more accurate analysis
2. **API Key**: Create separate keys for dev/prod
3. **Error Handling**: Always show user-friendly error messages
4. **Testing**: Test with various plant images
5. **Monitoring**: Track API calls and costs

---

## 🎯 Next Steps After Setup

1. ✅ Run `flutter run`
2. ✅ Test camera function
3. ✅ Test gallery selection
4. ✅ Analyze a plant image
5. ✅ Check results display
6. ✅ Test error scenarios
7. ✅ Deploy to app store (optional)

---

## 📞 File Locations

**Need to modify?**

API Key: `lib/core/di/injection.dart`  
UI Colors: `lib/core/theme/app_colors.dart`  
UI Strings: `lib/core/resources/strings.dart`  
Main Screen: `lib/features/plant_detection/presentation/pages/plant_detection_page.dart`  
BLoC: `lib/features/plant_detection/presentation/bloc/plant_detection_bloc.dart`

---

## 🎨 Design System

**Colors**: Green theme (nature-inspired)  
**Typography**: Material 3 design  
**Icons**: Material Icons  
**Animations**: Smooth transitions  
**Responsive**: All screen sizes  

---

**Version**: 1.0  
**Status**: ✅ Ready  
**Last Updated**: May 12, 2026

---

### 🌱 Happy Plant Analysis! 🌱

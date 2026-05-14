# Plant Health Detection App - Setup Guide

## Overview
This Flutter app uses Google's Gemini AI API to analyze plant images and detect diseases. It follows Clean Architecture principles with BLoC state management.

## Algorithm Flow
1. **Start** → User launches app
2. **Upload/Take Image** → User captures or selects an image
3. **Process Image** → App converts image to base64
4. **Image Classification** → Gemini AI analyzes the image
5. **Decision** → 
   - If healthy → Show "Plant is healthy" message
   - If disease detected → Show disease name, treatment, and advice

## Setup Instructions

### 1. Get Gemini API Key
1. Visit [Google AI Studio](https://aistudio.google.com)
2. Sign in with your Google account
3. Click "Create API Key"
4. Copy the API key

### 2. Update API Key
Open `lib/core/di/injection.dart` and replace the placeholder API key:

```dart
getIt.registerSingleton<PlantDetectionRemoteDataSource>(
  PlantDetectionRemoteDataSourceImpl(
    'YOUR_GEMINI_API_KEY_HERE', // ← Replace this
  ),
);
```

### 3. Install Dependencies
```bash
flutter pub get
```

### 4. Configure Permissions (iOS)
Edit `ios/Runner/Info.plist`:

```xml
<dict>
  ...
  <key>NSCameraUsageDescription</key>
  <string>We need camera access to take plant photos</string>
  <key>NSPhotoLibraryUsageDescription</key>
  <string>We need photo library access to select plant images</string>
</dict>
```

### 5. Configure Permissions (Android)
Edit `android/app/src/main/AndroidManifest.xml`:

```xml
<manifest ...>
  <uses-permission android:name="android.permission.CAMERA" />
  <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
  <uses-permission android:name="android.permission.INTERNET" />
  ...
</manifest>
```

### 6. Run the App
```bash
flutter run
```

## Project Structure

```
lib/
├── core/
│   ├── di/                    # Dependency Injection
│   ├── navigation/            # Navigation & routing
│   ├── resources/             # Constants (strings, colors)
│   └── theme/                 # Theme configuration
├── features/
│   └── plant_detection/       # Main feature
│       ├── data/              # Data layer
│       │   ├── datasources/   # API calls
│       │   ├── models/        # Data models
│       │   └── repositories/  # Repository implementations
│       ├── domain/            # Business logic layer
│       │   ├── entities/      # Domain models
│       │   ├── repositories/  # Repository interfaces
│       │   └── usecases/      # Business logic
│       └── presentation/      # UI layer
│           ├── bloc/          # BLoC (state management)
│           ├── pages/         # Screen pages
│           └── widgets/       # Reusable widgets
└── main.dart                  # App entry point
```

## Key Features

### State Management (BLoC)
- **PlantDetectionBloc**: Manages image picking and analysis
- **Events**: `AnalyzePlantImageEvent`, `PickImageFromGalleryEvent`, `CaptureImageFromCameraEvent`
- **States**: `PlantDetectionInitial`, `PlantDetectionLoading`, `PlantDetectionSuccess`, `PlantDetectionError`

### API Integration
- Uses Google Gemini Flash API
- Sends image as base64-encoded data
- Analyzes in Bengali for better local understanding
- Automatically detects disease and provides treatment advice

### UI Components
- **PlantDetectionPage**: Main screen with image capture/selection
- **ResultCard**: Displays analysis results with disease info and treatment
- **ImageActionButtons**: Camera and gallery picker buttons

## Supported Languages
- Bengali (বাংলা) - Primary
- English - Secondary

## API Response Parsing
The app analyzes responses for:
1. **Disease Status**: Checks for health indicators
2. **Disease Name**: Fungal, bacterial, viral infections, etc.
3. **Treatment**: Fungicide, insecticide, bactericide recommendations
4. **Advice**: General care instructions

## Troubleshooting

### Camera/Gallery Not Working
- Ensure permissions are granted in device settings
- Check AndroidManifest.xml and Info.plist

### API Key Error
- Verify API key is correctly copied
- Check Google Cloud Console quotas
- Ensure API is enabled in Google Cloud

### Image Not Uploading
- Check internet connection
- Verify image size (smaller images work better)
- Check API response in logs

## Environment Variables (Optional)
Create a `.env` file in project root:

```
GEMINI_API_KEY=your_api_key_here
```

Then load in `injection.dart`:
```dart
// Install flutter_dotenv package
final apiKey = dotenv.env['GEMINI_API_KEY'];
```

## Performance Tips
1. Compress large images before sending
2. Use image quality setting in ImagePicker (100% for accuracy)
3. Cache analysis results to reduce API calls
4. Implement rate limiting for consecutive requests

## Future Enhancements
- [ ] History of analyzed plants
- [ ] Multiple language support
- [ ] Offline mode with local ML models
- [ ] Plant care reminders
- [ ] Disease severity levels
- [ ] Treatment effectiveness tracking

## License
MIT License

## Support
For issues and questions, please check the app logs and ensure:
1. API key is valid and has quotas
2. Permissions are properly configured
3. Image format is supported (JPEG, PNG, GIF, WebP)

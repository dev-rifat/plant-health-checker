# Plant Health Detection App - Architecture & Flow

## System Architecture

```
┌─────────────────────────────────────────────────────────┐
│                   PRESENTATION LAYER                     │
│  (Flutter UI - BLoC State Management)                    │
├─────────────────────────────────────────────────────────┤
│  PlantDetectionPage                                      │
│  ├─ Initial State (Image picker buttons)                 │
│  ├─ ImagePicked State (Preview + Analyze button)         │
│  ├─ Loading State (Spinner)                              │
│  ├─ Success State (ResultCard with analysis)             │
│  └─ Error State (Error message + Recovery)               │
├─────────────────────────────────────────────────────────┤
│  PlantDetectionBloc (Events → States)                    │
│  ├─ AnalyzePlantImageEvent                               │
│  ├─ PickImageFromGalleryEvent                            │
│  ├─ CaptureImageFromCameraEvent                          │
│  └─ ResetPlantDetectionEvent                             │
├─────────────────────────────────────────────────────────┤
│                   DOMAIN LAYER                           │
│  (Business Logic - Independent of Framework)             │
├─────────────────────────────────────────────────────────┤
│  PlantDetectionRepository (Interface)                    │
│  └─ analyzePlantImage(imagePath): Future<Result>         │
├─────────────────────────────────────────────────────────┤
│  AnalyzePlantImageUseCase                                │
│  └─ Orchestrates business logic                          │
├─────────────────────────────────────────────────────────┤
│  PlantAnalysisResult (Entity)                            │
│  ├─ isHealthy: bool                                      │
│  ├─ disease: String                                      │
│  ├─ treatment: String                                    │
│  └─ advice: String                                       │
├─────────────────────────────────────────────────────────┤
│                   DATA LAYER                             │
│  (API & Local Storage)                                   │
├─────────────────────────────────────────────────────────┤
│  PlantDetectionRepositoryImpl                             │
│  └─ Implements repository interface                      │
├─────────────────────────────────────────────────────────┤
│  PlantDetectionRemoteDataSource                          │
│  └─ analyzePlantImage(imagePath)                         │
│     ├─ Read image file                                   │
│     ├─ Encode to base64                                  │
│     ├─ Create API request                                │
│     ├─ Send to Gemini API                                │
│     └─ Parse response                                    │
├─────────────────────────────────────────────────────────┤
│  PlantAnalysisResultModel                                │
│  └─ Parses Gemini API response                           │
├─────────────────────────────────────────────────────────┤
│                   EXTERNAL APIs                          │
├─────────────────────────────────────────────────────────┤
│  Google Gemini AI API                                    │
│  └─ https://generativelanguage.googleapis.com/...        │
├─────────────────────────────────────────────────────────┤
│                  CORE LAYER                              │
│  (Shared Services)                                       │
├─────────────────────────────────────────────────────────┤
│  Dependency Injection (GetIt)                            │
│  Navigation Service                                      │
│  App Theme & Colors                                      │
│  Constants & Strings                                     │
└─────────────────────────────────────────────────────────┘
```

## User Flow Diagram

```
START
  │
  ├─→ [HOME PAGE]
  │   "Plant Health Check"
  │   - Logo & Welcome text
  │   - Two buttons:
  │     * "📷 Take Photo"
  │     * "🖼️ Choose from Gallery"
  │
  ├─→ [IMAGE SELECTION]
  │   User picks image via camera or gallery
  │   │
  │   └─→ PickImageFromGalleryEvent
  │   OR CaptureImageFromCameraEvent
  │
  ├─→ [IMAGE PREVIEW]
  │   - Display selected image
  │   - Two buttons:
  │     * "✓ Analyze"
  │     * "✕ Cancel"
  │
  ├─→ [ANALYSIS LOADING]
  │   - Spinner animation
  │   - "আপনার ফসল বিশ্লেষণ করা হচ্ছে..."
  │   - AnalyzePlantImageEvent triggers:
  │     * Image base64 encoding
  │     * API request preparation
  │     * Gemini AI processing
  │
  ├─→ [RESULT PROCESSING]
  │   Response parsing:
  │   ├─ Check for health keywords
  │   ├─ Extract disease name
  │   ├─ Extract treatment info
  │   └─ Extract advice
  │
  ├─→ [RESULT DISPLAY]
  │   PlantDetectionSuccess state
  │   │
  │   ├─ IF HEALTHY:
  │   │  ├─ Green card with ✓
  │   │  ├─ "ফসল স্বাস্থ্যকর 🌱"
  │   │  └─ No disease info
  │   │
  │   └─ IF DISEASED:
  │      ├─ Red/Orange card with ⚠️
  │      ├─ Disease name
  │      ├─ Treatment (fungicide/insecticide/etc)
  │      └─ Care advice
  │
  ├─→ [ACTION BUTTONS]
  │   - "🔄 Analyze Again"
  │   - "🏠 Go Back"
  │
  └─→ END (Loop or Exit)
```

## BLoC State Diagram

```
┌─────────────────────────────────────────────────────────┐
│                PlantDetectionBloc States                 │
└─────────────────────────────────────────────────────────┘

  ┌─────────────────────┐
  │ PlantDetectionInit  │ (Initial state)
  │ └─ PlantDetectionI  │
  └──────────┬──────────┘
             │
    ┌────────┴─────────┬──────────────┐
    │                  │              │
    ↓                  ↓              ↓
 CAMERA            GALLERY        RESET
    │                  │              │
    └────────┬─────────┘              │
             ↓                        │
    ┌─────────────────────┐           │
    │ ImagePickedState    │           │
    │ (path: String)      │           │
    └──────────┬──────────┘           │
               │                      │
               ↓                      │
            ANALYZE                   │
               │                      │
               ↓                      │
    ┌─────────────────────┐           │
    │ PlantDetectionLoad  │           │
    │ ing (API call)      │           │
    └──────────┬──────────┘           │
               │                      │
         ┌─────┴─────┐                │
         │           │                │
    SUCCESS      ERROR               │
         │           │                │
         ↓           ↓                ↓
    ┌─────────────────────┐  ┌──────────────────┐
    │ PlantDetectionSuc   │  │ PlantDetectionE  │
    │ cess(result)        │  │ rror(message)    │
    └─────────┬───────────┘  └────────┬─────────┘
              │ (RESET)               │ (RESET)
              └───────┬───────────────┘
                      ↓
          PlantDetectionInitial

Events:
├─ CaptureImageFromCameraEvent
├─ PickImageFromGalleryEvent
├─ AnalyzePlantImageEvent
└─ ResetPlantDetectionEvent
```

## API Request/Response Flow

```
┌─────────────────────────────────────────────────────────┐
│              GEMINI API Integration Flow                 │
└─────────────────────────────────────────────────────────┘

USER ACTION: Tap "Analyze"
        │
        ↓
[PlantDetectionBloc]
    AnalyzePlantImageEvent(path)
        │
        ↓
[ImagePicker - Read File]
    File.readAsBytes()
        │
        ↓
[Base64 Encoding]
    base64.encode(imageBytes)
        │
        ↓
[MIME Type Detection]
    .jpg → image/jpeg
    .png → image/png
    .gif → image/gif
    .webp → image/webp
        │
        ↓
[Build Request Body]
    {
      "contents": [{
        "parts": [
          {
            "text": "Bengali analysis prompt"
          },
          {
            "inline_data": {
              "mime_type": "image/jpeg",
              "data": "base64_image_data"
            }
          }
        ]
      }]
    }
        │
        ↓
[HTTP POST Request]
    URL: https://generativelanguage.googleapis.com/
         v1beta/models/gemini-flash-latest:generateContent
    ?key=YOUR_API_KEY
    Headers: Content-Type: application/json
        │
        ↓
[GOOGLE GEMINI API]
    ┌─ Image Processing
    ├─ Disease Detection
    └─ Analysis Generation
        │
        ↓
[Response Received]
    {
      "candidates": [{
        "content": {
          "parts": [{
            "text": "AI generated analysis in Bengali"
          }]
        }
      }]
    }
        │
        ↓
[Response Parsing]
    Extract text from:
    response['candidates'][0]['content']['parts'][0]['text']
        │
        ↓
[Analysis Processing]
    ├─ Check health status
    ├─ Extract disease name
    ├─ Extract treatment
    └─ Extract advice
        │
        ↓
[Create PlantAnalysisResultModel]
    PlantAnalysisResultModel.fromGeminiResponse(
      apiResponse: String,
      imageUrl: String
    )
        │
        ↓
[Emit PlantDetectionSuccess]
    PlantDetectionSuccess(result)
        │
        ↓
[BLoC Builder Rebuilds UI]
    Shows ResultCard with analysis
```

## File Structure

```
lib/
├── core/
│   ├── di/
│   │   └── injection.dart (Setup ServiceLocator)
│   ├── navigation/
│   │   ├── app_router.dart
│   │   └── navigation_service.dart
│   ├── resources/
│   │   ├── strings.dart
│   │   └── (app_colors.dart)
│   └── theme/
│       ├── app_colors.dart
│       └── app_theme.dart
│
├── features/
│   └── plant_detection/
│       ├── data/
│       │   ├── datasources/
│       │   │   └── plant_detection_remote_datasource.dart
│       │   ├── models/
│       │   │   └── plant_analysis_result_model.dart
│       │   └── repositories/
│       │       └── plant_detection_repository_impl.dart
│       ├── domain/
│       │   ├── entities/
│       │   │   └── plant_analysis_result.dart
│       │   ├── repositories/
│       │   │   └── plant_detection_repository.dart
│       │   └── usecases/
│       │       └── analyze_plant_image_usecase.dart
│       └── presentation/
│           ├── bloc/
│           │   ├── plant_detection_bloc.dart
│           │   ├── plant_detection_event.dart
│           │   └── plant_detection_state.dart
│           ├── pages/
│           │   └── plant_detection_page.dart
│           └── widgets/
│               ├── image_action_buttons.dart
│               └── result_card.dart
│
└── main.dart
```

## Response Parsing Logic

```
GEMINI API RESPONSE (Bengali):

"রোগের নাম: পাউডারি মিল্ডিউ
চিকিৎসা: Fungicide ছিটান
পরামর্শ: গাছের পাশাপাশি পরিচর্যা করুন"

          ↓
     [Parsing]
          ↓
    ├─ isHealthy = false (contains "রোগের নাম")
    ├─ disease = "Powdery Mildew"
    ├─ treatment = "Fungicide ছিটান / Apply Fungicide"
    └─ advice = "গাছের পাশাপাশি পরিচর্যা করুন..."
          ↓
   [PlantAnalysisResult Entity]
          ↓
   [ResultCard Widget]
```

---

## Summary
- **Clean Architecture**: Domain → Data → Presentation layers
- **State Management**: BLoC for reactive UI
- **API**: Gemini AI for plant disease detection
- **Multilingual**: Bengali & English UI
- **Error Handling**: Comprehensive error states and recovery

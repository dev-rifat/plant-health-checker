# Plant Health
### An AI-Powered Mobile Application for Tomato Leaf Disease Diagnosis

**Submitted by**
| Name | ID |
|---|---|
| Habiba | 0272130005101046 |
| Mithila Akter | 0272130005101048 |
| Imran Hossain Badsha | 0272130005101012 |
| Alfe Sani | 1935202085 |

**Supervised By**
Faria Rahman Annasha, Lecturer, Department of CSE
City University of Bangladesh

---

## ACKNOWLEDGEMENT

First, we would like to express our heartfelt gratitude to Almighty Allah for giving us the strength and ability to complete this project as part of the partial fulfillment of the requirements for the Degree of B.Sc. in Computer Science and Engineering. We would like to express our sincere gratitude and appreciation to our supervisor, **Faria Rahman Annasha**, Lecturer, Department of Computer Science and Engineering, City University, for her continuous guidance, valuable feedback, and encouragement throughout the development of this project. We are also grateful to all the faculty members of the Department of Computer Science and Engineering, City University, for their support and the opportunity to carry out this work. Finally, we acknowledge with respect the constant support, patience, and encouragement of our parents and families.

## ABSTRACT

Tomato leaf disease is one of the leading causes of crop loss, and farmers without access to agricultural experts often misdiagnose or delay treatment. This project presents **Plant Health**, a cross-platform Flutter mobile application that lets a farmer photograph a tomato leaf and receive an instant, Bengali-language diagnosis and treatment recommendation. Rather than collecting a dataset and training a custom detection model — an approach that most existing literature follows but rarely turns into a deployable product — this project uses Google's Gemini vision-language AI directly as the diagnosis engine, driven by a carefully engineered prompt, and focuses engineering effort on making the surrounding mobile application usable and resilient in real-world, low-connectivity field conditions. The application is built with Flutter and Dart, follows Clean Architecture with the BLoC pattern for state management, uses Firebase Authentication for user accounts, and manages a rotating pool of Gemini API keys through Firebase Remote Config so keys can be rotated without releasing a new app version. The result is a working, installable application that demonstrates disease detection, structured bilingual results, and graceful handling of network and API failures — a practical, deployable alternative to lab-only CNN/YOLO-based research prototypes.

---

## TABLE OF CONTENTS

- Acknowledgement
- Abstract
- List of Figures
- List of Tables

**Chapter 1 — Introduction**
1.1 Introduction
1.2 Motivation
1.3 Goal and Objective
1.4 Project Overview
1.5 Features
1.6 Used Technology

**Chapter 2 — Background Study/Related Work**
2.1 Related Work
2.2 Review of Existing Work
2.3 Comparison Table

**Chapter 3 — Research Methodology**
3.1 Introduction
3.2 Feasibility Study
3.3 Work Procedure
3.4 Block Diagram
3.5 System Architecture Diagram
3.6 Use-Case Diagram
3.7 Activity Diagram
3.8 Required Component and Software
3.9 Description of the Components
3.10 Description of the Software
3.11 Required Language
3.12 Supported Platform
3.13 Gantt Chart
3.14 Project Tentative Cost

**Chapter 4 — Result and Discussion**
4.1 System Result Overview
4.2 Diagnostic Accuracy Evaluation
4.3 Comparative Analysis
4.4 Mobile Application Testing

**Chapter 5 — Conclusion and Future Work**
5.1 Conclusion
5.2 Future Work
5.3 Limitation

References
Appendix

---

## LIST OF FIGURES

| Figure | Title |
|---|---|
| Fig 1 | System Block Diagram |
| Fig 2 | System (Clean) Architecture Diagram |
| Fig 3 | Use-Case Diagram |
| Fig 4 | Activity Diagram |

## LIST OF TABLES

| Table | Title |
|---|---|
| Table 1 | Literature Review Summary |
| Table 2 | Comparison Table (Existing Work vs. Proposed System) |
| Table 3 | Required Component and Software |
| Table 4 | Diagnostic Accuracy Evaluation |
| Table 5 | Per-Class Accuracy Breakdown |
| Table 6 | Comparative Analysis |
| Table 7 | Gantt Chart / Working Schedule |
| Table 8 | Project Tentative Cost |

---

# Chapter 1 — Introduction

## 1.1 Introduction

Tomato is one of the most widely grown vegetable crops, but its yield is often damaged by leaf diseases such as Early Blight, Bacterial Spot, and Leaf Miner infestation. Farmers usually detect these diseases by eye, which is slow and often wrong, especially for farmers who are not trained in plant pathology.

This project builds **"Plant Health"** — a mobile application built in Flutter that lets any farmer take or upload a photo of a leaf and instantly get a diagnosis and treatment suggestion, powered by Google's Gemini vision AI. Instead of training and deploying a custom detection model, the app uses Gemini's vision-language capability directly, which lets the diagnosis logic (disease identification, severity assessment, treatment advice) be developed, tested, and improved through prompt design rather than a lengthy model-training cycle — while still returning structured, localized results a farmer can act on.

## 1.2 Motivation

Plant disease is a major cause of crop loss around the world. In Bangladesh, tomato farming is common but many farmers do not have easy access to agricultural experts. A wrong or late diagnosis can lead to the wrong pesticide being used, wasted money, and lower harvest.

At the same time, smartphones are now common even in rural areas, and recent progress in cloud-based vision-language AI (like Google Gemini) makes it possible to build a tool that gives instant, understandable answers from a simple photo — no expert needed on site, and no need to train and maintain a custom computer-vision model. Most existing smart-agriculture systems in the literature stop at the research/notebook stage; this project's motivation is to carry the idea all the way to a working, installable mobile application.

## 1.3 Goal and Objective

- To build a cross-platform mobile application (Android/iOS) that any farmer can use to photograph a leaf and get an instant, understandable result in Bengali.
- To use a general-purpose cloud vision AI (Google Gemini) as the diagnosis engine, avoiding the cost and lead time of collecting, annotating, and training a custom detection model.
- To design a prompting and parsing approach that reliably extracts disease status, disease name, severity, symptoms, and treatment advice from the AI's response.
- To make the mobile application reliable in real-world conditions — handling network failures, server downtime, and API key expiry gracefully instead of crashing.
- To evaluate the diagnostic accuracy of the Gemini-based approach against known leaf images and compare it against existing published work.

## 1.4 Project Overview

Plant Health is a single mobile application with two functional halves that work together:

1. **Account layer** — a user signs up or logs in using Firebase Authentication, and can view/manage a simple profile.
2. **Detection layer** — the user opens the plant-detection screen, captures a photo with the camera or picks one from the gallery, previews it, and taps *Analyze*. The image is sent to the Gemini vision API together with a Bengali-language diagnostic prompt. The response is parsed into a structured result — health status, disease name (Bengali & English), severity, observed symptoms, and recommended medicine/dosage — and shown on a dedicated result page.

Supporting this core flow, the app also shows local weather information (via the Open-Meteo API), since weather conditions are relevant to disease risk and treatment timing for a farmer. Underneath the UI, the app manages a **pool of Gemini API keys** via Firebase Remote Config, so keys can expire, be rate-limited, or be rotated without requiring a new app release — the app automatically retries with the next available key and only shows the user an error if every option has been exhausted.

## 1.5 Features

- Measure/diagnose plant (tomato leaf) health from a photo — healthy vs. diseased.
- Identify disease name, severity, and visible symptoms.
- Recommend medicine/treatment with dosage and care steps.
- Camera capture and gallery image selection.
- Bilingual result display — Bengali (primary) and English.
- User account system — signup, login, and profile (Firebase Authentication).
- Local weather lookup to support treatment-timing decisions.
- Automatic Gemini API key rotation on failure (expired/blocked/quota-exceeded key).
- Automatic retry with backoff on transient server errors.
- Clear, localized error messages for no-internet, blocked-image, and exhausted-key scenarios instead of a crash.
- Remote-configurable AI keys — no app re-release needed to rotate or add keys.

## 1.6 Used Technology

- Flutter & Dart
- Google Gemini API (vision-language model)
- Firebase (Authentication, Remote Config, Core)
- Flutter BLoC (state management)
- GetIt (dependency injection)
- Open-Meteo API (weather)

*(Each of these is described in detail in section 3.9.)*

---

# Chapter 2 — Background Study/Related Work

## 2.1 Related Work

**Existing Work 01** — Rajamohanan, R., & Latha, B. C. (2023) proposed an optimized YOLOv5-based model for tomato leaf disease classification, achieving 93% accuracy. The model performs well on clean, single-leaf images but is sensitive to background interference and was evaluated only on a limited set of disease categories.

**Existing Work 02** — Tm, P., Pranathi, A., & Sai Ashritha, K. (2018) used a LeNet-based CNN for plant disease classification, reporting 94–95% accuracy with minimal computing resources — attractive for low-resource settings, but limited by the simplicity of the underlying architecture on harder, crowded-lesion cases.

**Existing Work 03** — Altalak, M., Uddin, M. A., Alajmi, A., & Rizg, A. (2022) combined CNN, SVM, and a CBAM attention module into a hybrid model, reaching 97.2% accuracy in disease detection, at the cost of a more complex training/learning pipeline.

**Existing Work 04** — Agarwal, M., Gupta, S. K., & Biswas, K. K. (2020) built a simplified 8-hidden-layer CNN trained on the PlantVillage dataset, achieving 98.4% accuracy — one of the strongest lab results reviewed — but, like the others, evaluated purely on a curated dataset rather than a deployed application.

**Existing Work 05** — Abulizi, A., Ye, J., & Guo, W. (2024) introduced DM-YOLO, built on YOLOv9, improving precision by 2–3% over prior YOLO variants, though small and overlapping lesions remain a challenge for the detector.

## 2.2 Review of Existing Work

**Table 1: Literature Review Summary**

| Author(s) | Year | Model/Approach | Achievements | Gaps/Limitations |
|---|---|---|---|---|
| Rajamohanan, R., & Latha, B. C. | 2023 | Optimized YOLOv5 | 93% accuracy in tomato leaf disease classification | Background interference, limited to two disease categories |
| Abulizi, A., Ye, J., & Guo, W. | 2024 | DM-YOLO (YOLOv9) | Precision increased by 2–3% vs. improved models | Small lesions and overlapping symptoms remain challenging |
| Tm, P., Pranathi, A., & Sai Ashritha, K. | 2018 | LeNet CNN | 94–95% accuracy with minimal computing resources | Limited to simpler CNN architectures |
| Shanthi, D. L., Vinutha, K., & Ashwini, N. | 2024 | Custom CNN (AlexNet, VGGNet-16) | Improved classification accuracy | High computational demand for large datasets |
| Altalak, M., Uddin, M. A., Alajmi, A., & Rizg, A. | 2022 | Hybrid CNN, SVM, CBAM | 97.2% accuracy in disease detection | Needs improvement in the learning process |
| Agarwal, M., Gupta, S. K., & Biswas, K. K. | 2020 | Simplified CNN (8 hidden layers) | 98.4% accuracy on PlantVillage dataset | Needs more image-preprocessing optimization |

**Summary:** Most existing work reports high accuracy but is trained/tested only on lab datasets and simple, uncrowded images, and requires the authors to collect, annotate, and train a dedicated model. Very few studies discuss turning the model into a usable, real-time farmer-facing product. This project addresses that gap differently: instead of training a new custom model, it uses an existing large-scale vision AI (Gemini) as the diagnosis engine, and puts the engineering effort into making the surrounding mobile application usable and reliable for real farmers.

## 2.3 Comparison Table

**Table 2: Comparison Table — Existing Work vs. Proposed System**

| Capability | Existing Work 01–05 (CNN/YOLO research) | Proposed System (Plant Health) |
|---|---|---|
| Detection engine | Custom-trained CNN/YOLO model | Google Gemini vision-language AI (zero-shot, no training) |
| Dataset/training required | Yes — must collect, annotate, and train | No — uses a general-purpose pretrained model via prompting |
| Deployment | Lab/notebook evaluation only | Installable Flutter mobile app (Android/iOS) |
| Language of result | Not addressed / English only | Bengali (primary) & English |
| Treatment advice | Not typically provided | Disease name, severity, symptoms, medicine & dosage |
| Network resilience | Not addressed | Key rotation, retry-with-backoff, graceful error messages |
| Key/config management | Not applicable | Firebase Remote Config — rotate keys without app update |
| User accounts | Not applicable | Firebase Authentication (signup/login/profile) |
| Supporting context | Not applicable | Local weather lookup |

---

# Chapter 3 — Research Methodology

## 3.1 Introduction

This chapter describes the hardware/software components, tools, and design diagrams used to build Plant Health. Since this is a mobile-software project rather than an embedded/IoT hardware project, "components" here refers to APIs, SDKs, and packages rather than sensors and wiring — but the same disciplined process (feasibility study → work procedure → architecture diagrams → component list → tooling) is followed.

## 3.2 Feasibility Study

**Technical Feasibility:** The project only requires a computer with Flutter/Dart installed, a Firebase project, and a Gemini API key — all freely available. No specialized hardware is needed since the camera/gallery access is provided by the target smartphone itself.

**Operational Feasibility:** The app's UI (camera button → preview → analyze → result) is simple enough that a first-time user needs no training beyond normal smartphone use.

**Economic Feasibility:** Firebase Authentication and Remote Config are free at this project's scale (Spark plan), and the Gemini API has a free usage tier suitable for evaluation and small-scale pilot use, making the running cost close to zero during development (see 3.14).

## 3.3 Work Procedure

```
Problem Analysis → Feature Selection → Architecture Design
   → Module Implementation (Auth, Detection, Weather)
   → Gemini Prompt Design & Integration
   → Hardware/Software Integration (Firebase + Gemini + Flutter UI)
   → Testing (functional + failure-mode testing)
```

First, the problem and target users (farmers with smartphones, limited connectivity) were analyzed, then the required features were selected. Based on this, the Clean Architecture layers and BLoC state flow were designed, followed by implementation of the authentication and detection modules, the Gemini prompt, and integration of Firebase services. Testing then covered both the normal flow and simulated failure conditions.

## 3.4 Block Diagram

**Fig 1: System Block Diagram**

```
                     ┌─────────────────────────────┐
   Camera/Gallery ──▶│                             │
                     │                             │◀── Firebase Auth
   User Input ──────▶│      Flutter Mobile App     │      (login/signup)
                     │        "Plant Health"        │
                     │                             │◀── Firebase Remote Config
   Weather Query ───▶│                             │      (Gemini key pool)
                     │                             │
                     └─────────────┬───────────────┘
                                   │
                        ┌──────────┴───────────┐
                        │                       │
                        ▼                       ▼
              Google Gemini Vision API   Open-Meteo Weather API
              (disease diagnosis)         (local weather data)
```

Here, the central block is the Flutter mobile app itself. It receives a leaf photo from the camera/gallery and, together with a Gemini API key drawn from the Firebase Remote Config key pool, sends the image to the Gemini Vision API. The API's structured response is parsed and shown as the diagnosis result. Firebase Authentication guards access, and the Open-Meteo API supplies supporting weather context.

## 3.5 System Architecture Diagram

**Fig 2: System (Clean) Architecture Diagram**

```
UI (Pages/Widgets)
   ↓ user action
BLoC (Events → States)
   ↓
UseCase (business rule, e.g. "analyze this image")
   ↓
Repository (defines the contract)
   ↓
DataSource (talks to the Gemini API over HTTPS)
```

This layered diagram plays the role a circuit diagram plays in a hardware project — it shows exactly how a signal (here, a user action) travels through the system. A tap on "Analyze" flows down from the UI to a BLoC event, into a use case, through the repository contract, and finally to the data source that performs the actual HTTPS call to Gemini. Because each layer only depends on the one below it through an interface, the Gemini backend could be replaced by another provider (or a future on-device model) without changing the UI layer.

## 3.6 Use-Case Diagram

**Fig 3: Use-Case Diagram (described)**

Actors: **User** (the farmer) and **System** (the app's backend logic — Firebase + Gemini).

User-side use cases:
- Sign Up / Log In / View Profile (Firebase Authentication)
- Capture Photo (Camera) / Select Photo (Gallery)
- Preview Image
- Analyze Image
- View Diagnosis Result (health status, disease name, severity, symptoms, medicine/dosage)
- Retry Analysis (on error)
- View Local Weather

System-side use cases:
- Authenticate User (Firebase Auth)
- Fetch Gemini API Key Pool (Firebase Remote Config)
- Send Image + Prompt to Gemini Vision API
- Parse Gemini Response into Structured Result
- Rotate to Next API Key on Failure
- Retry Request on Transient Server Error
- Surface Localized Error Message (no internet / blocked image / all keys exhausted)
- Fetch Weather Data (Open-Meteo)

The **User** actor is directly associated with signing up/logging in, capturing or selecting an image, previewing it, and requesting analysis. The **System** actor takes over once "Analyze" is tapped: it authenticates the request, selects a key from the pool, calls Gemini, and either returns a parsed result to the user or rotates/retries/reports an error, all without further user action.

## 3.7 Activity Diagram

**Fig 4: Activity Diagram (described)**

```
        ●
        │
   Open App
        │
   Check Auth State ──(not logged in)──▶ Login / Signup ──┐
        │(logged in)                                       │
        ▼◀──────────────────────────────────────────────────┘
      Home
        │
   Select Image Source (Camera / Gallery)
        │
   Preview Image
        │
   Tap "Analyze"
        │
   Send Image + Prompt to Gemini ──────────────┐
        │                                       │
        ▼                                       ▼
  Response OK?                            Request Failed
        │ Yes                                   │
        ▼                              ┌────────┴────────┐
  Parse & Display Result          Key issue?         Server busy?
        │                              │                   │
        ▼                        Rotate to next        Retry same
       (●)                        key & retry          key w/ delay
                                        │                   │
                                        └─────────┬─────────┘
                                                   ▼
                                         All options exhausted?
                                            │Yes         │No
                                            ▼            └──▶ back to "Send Image"
                                   Show localized error
                                            │
                                           (●)
```

After opening the app, the pre-condition is the user's authentication state; an unauthenticated user is routed to Login/Signup first. Once on the Home screen, the user selects an image source, previews the photo, and triggers analysis. If Gemini responds successfully, the result is parsed and displayed. If the request fails, the system distinguishes a **key problem** (expired/blocked/quota) — triggering a rotation to the next key and a retry — from a **transient server problem**, which is retried on the same key after a short delay. Only when every option is exhausted does the activity end in a clear, localized error message instead of a crash.

## 3.8 Required Component and Software

**Table 3: Required Component and Software**

| Component/Software | Purpose |
|---|---|
| Flutter SDK (^3.11.1) & Dart | Cross-platform app framework and language |
| Firebase project (Auth + Remote Config + Core) | User authentication and remote key management |
| Google Gemini API key(s) | Vision-language model that performs the disease diagnosis |
| Android Studio / VS Code (with Flutter & Dart plugins) | Development environment |
| Xcode (for iOS builds) | Building/running on iOS devices/simulators |
| Physical device or emulator with camera | Capturing leaf photos |
| Open-Meteo API (no key required) | Supplying local weather data |
| Git | Version control |

## 3.9 Description of the Components

- **Flutter & Dart** — cross-platform UI framework; one codebase targets both Android and iOS.
- **flutter_bloc** — implements the BLoC/Cubit pattern used for all state management (loading, success, error states).
- **get_it** — a service locator used for dependency injection, wiring repositories/use cases/datasources without tight coupling.
- **firebase_core / firebase_auth** — initializes Firebase and provides email/password authentication for signup, login, and profile.
- **firebase_remote_config** — stores the `gemini_api_keys` parameter (comma-separated key pool) so keys can be rotated remotely without an app release.
- **http** — performs the HTTPS calls from the data layer to the Gemini API.
- **image_picker** — provides camera capture and gallery selection for the leaf photo.
- **equatable** — simplifies value comparison for BLoC states/events.
- **persistent_bottom_nav_bar** — implements the bottom navigation shell (Home / Profile, etc.).
- **package_info_plus** — reads the installed app's version info (used for diagnostics/display).
- **Google Gemini API (`gemini-flash-latest`)** — the vision-language model that receives the leaf image plus a Bengali diagnostic prompt and returns disease status, name, severity, symptoms, and treatment advice.
- **Open-Meteo API** — a free, keyless weather API used to show local weather relevant to disease risk/treatment timing.

## 3.10 Description of the Software

- **Android Studio / Visual Studio Code** — primary IDEs used for writing, running, and debugging the Flutter application.
- **Firebase Console** — used to configure Authentication providers and to manage the `gemini_api_keys` Remote Config parameter.
- **Google AI Studio (aistudio.google.com)** — used to generate and manage Gemini API keys.
- **Xcode** — used to build and run the app on iOS simulators/devices.
- **Git/GitHub** — used for source control and collaboration.

## 3.11 Required Language

Dart (application logic and UI), with YAML used for project/dependency configuration (`pubspec.yaml`).

## 3.12 Supported Platform

- **Android**: API 21+ (Android 5.0 "Lollipop" and above)
- **iOS**: iOS 11.0 and above
- Responsive layout — supports phones and tablets of varying screen sizes

## 3.13 Gantt Chart

**Table 7: Working Schedule**

| Task | Duration | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | W10 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| Problem Identification | 1 week | ✔ | | | | | | | | | |
| Literature Review | 1 week | | ✔ | | | | | | | | |
| Mobile App Architecture & Setup | 2 weeks | | | ✔ | ✔ | | | | | | |
| Gemini Integration & Prompt Design | 3 weeks | | | | | ✔ | ✔ | ✔ | | | |
| Testing and Validation | 1 week | | | | | | | | ✔ | | |
| Mobile App Development | (ongoing, parallel) | | | | | | | | | | |
| Report/Paper Organization | 2 weeks | | | | | | | | | ✔ | ✔ |

## 3.14 Project Tentative Cost

Unlike a hardware IoT project, this project's cost is dominated by service usage tiers and developer time rather than physical components.

**Table 8: Project Tentative Cost**

| Item | Cost | Notes |
|---|---|---|
| Firebase (Auth + Remote Config) | ৳0 | Free "Spark" plan covers this project's scale |
| Google Gemini API | ৳0 (dev/eval) | Free tier sufficient for development and evaluation; production use at scale would move to pay-as-you-go pricing |
| Open-Meteo API | ৳0 | Free, no API key required |
| Android Developer account (for future deployment) | ~$25 (one-time) | Only needed if published to Google Play |
| Apple Developer account (for future deployment) | ~$99/year | Only needed if published to the App Store |
| Development time | — | Primary cost of the project (see Gantt chart above) |

---

# Chapter 4 — Result and Discussion

## 4.1 System Result Overview

### 4.1.1 Authentication & Splash Overview
On launch, the app shows a splash screen while Firebase initializes and the Gemini key pool is fetched from Remote Config, then routes the user to Login/Signup if not already authenticated, or straight to Home if a session exists.

### 4.1.2 Detection & Result Overview
From Home, the user opens the Plant Detection page, captures or picks a leaf photo, previews it, and taps *Analyze*. A loading state is shown while the image is sent to Gemini; the Result page then displays the health status, disease name (Bengali & English), severity, symptoms, and recommended medicine/dosage — or, on failure, a clear localized error message.

## 4.2 Diagnostic Accuracy Evaluation (Gemini-based)

*[ FILL IN — replace all bracketed values below with your real test numbers ]*

**Table 4: Diagnostic Accuracy Evaluation**

| Metric | Value |
|---|---|
| Test images evaluated | [X] |
| Correct diagnoses (disease/healthy status matched ground truth) | [X] / [Total] ([X]%) |
| Incorrect / misclassified | [X] |
| Average response time per image | [X] seconds |

**Table 5: Per-Class Accuracy Breakdown**

| Class | Images Tested | Correctly Identified | Accuracy |
|---|---|---|---|
| Healthy | [X] | [X] | [X]% |
| Early Blight | [X] | [X] | [X]% |
| Bacterial Spot | [X] | [X] | [X]% |
| Leaf Miner | [X] | [X] | [X]% |

*[ Add 1–2 sentences here once the numbers are filled in, describing which class performed best/worst and why, similar to how the Literature Review discusses failure cases. ]*

## 4.3 Comparative Analysis

**Table 6: Comparative Analysis**

| Study | Architecture | Disease Classes | Performance | Deployment Focus |
|---|---|---|---|---|
| Tm et al. (2018) | LeNet CNN | Multiple | 94–95% Accuracy | Limited computing |
| Agarwal et al. (2020) | Simplified CNN | Multiple | 98.4% Accuracy | Lab/static dataset |
| Rajamohanan (2023) | YOLOv5 | Multiple | 93% Accuracy | Real-time field |
| Abulizi et al. (2025) | DM-YOLO (v9) | Multiple | 95.1% mAP | Real-time precision |
| Wang & Liu (2025) | TomatoGuard (v10) | Multiple | 94.23% mAP50 | High speed (129 FPS) |
| Shen et al. (2025) | Optimized YOLOv8 | Multiple | +2.2% Precision | Feature extraction |
| **Our Approach (2026)** | **Gemini Vision AI (cloud, zero-shot)** | Multiple | **[X]% accuracy** *[ FILL IN ]* | **Cloud-based, no training required** |

Unlike the prior work above, our approach does not train a dedicated detection model — it relies on a general-purpose cloud vision-language model. This trades control over raw detection accuracy for a large reduction in development time and no dataset/training requirement, while still needing internet connectivity and a third-party API to function.

## 4.4 Mobile Application Testing

The application was verified through functional testing of the full user flow (image capture → analysis → result display) and targeted testing of failure conditions:
- Simulated API key expiry/rejection → confirmed automatic rotation to the next key
- Simulated server error → confirmed retry-with-backoff behavior
- Simulated no-internet condition → confirmed a clear, user-facing error message instead of a crash

Automated unit/widget test coverage is limited at this stage (default Flutter widget test only); expanding automated test coverage is listed under Future Work.

---

# Chapter 5 — Conclusion and Future Work

## 5.1 Conclusion

This project delivers "Plant Health," a working, farmer-facing Flutter mobile application that provides instant, Bengali-language tomato leaf disease diagnosis and treatment advice using Google's Gemini vision AI. By using an existing cloud vision-language model instead of training a custom detector, the project focuses its engineering effort on making the application itself reliable and usable in real-world, low-connectivity conditions — while remaining architected so that the AI backend can be extended or replaced (e.g., with a fine-tuned or on-device model) in the future.

## 5.2 Future Work

- Expand the diagnostic evaluation to a larger, more diverse set of real field images to get a more reliable accuracy estimate.
- Explore fine-tuning or few-shot prompting strategies to improve Gemini's accuracy on harder classes (e.g. diseases with small, crowded lesions).
- Investigate a lightweight on-device model as an offline fallback for areas with no internet access, without removing the cloud-based option.
- Add automated test coverage for the mobile application.
- Pilot the app with real farmers to collect feedback on usability and translation accuracy.

## 5.3 Limitation

- The app depends entirely on a third-party cloud AI service (Gemini); it does not work offline and is subject to that provider's availability, rate limits, and pricing.
- Diagnostic accuracy is bounded by Gemini's general-purpose vision capability rather than a model fine-tuned specifically on tomato leaf disease images, so results may be less consistent than a well-trained specialist model on crowded/ambiguous symptoms.
- The evaluation test set used above is small; a larger, more diverse test set would give a more reliable accuracy estimate.
- Automated software testing (unit/integration tests) for the mobile app is minimal at this stage.

---

## References

1. Agarwal, M., Gupta, S. K., & Biswas, K. K. (2020). Development of efficient CNN model for tomato crop disease identification. *Sustainable Computing: Informatics and Systems*, 28, 100407.
2. Ahmed, S., Hasan, M. B., Ahmed, T., Sony, M. R. K., & Kabir, M. H. (2022). Less is more: Lighter and faster deep neural architecture for tomato leaf disease classification. *IEEE Access*, 10, 68868–68884.
3. Altalak, M., Uddin, M. A., Alajmi, A., & Rizg, A. (2022). A hybrid approach for the detection and classification of tomato leaf diseases. *Applied Sciences*, 12(16), 8182.
4. Attallah, O. (2023). Tomato leaf disease classification via compact convolutional neural networks with transfer learning and feature selection. *Horticulturae*, 9(2), 149.
5. Baek, E. T. (2025). Attention score-based multi-vision transformer technique for plant disease classification. *Sensors*, 25(1), 270.
6. Borugadda, P., Lakshmi, R., & Sahoo, S. (2023). Transfer learning VGG16 model for classification of tomato plant leaf diseases: A novel approach for multi-level dimensional reduction. *Pertanika Journal of Science & Technology*, 31(2).
7. Rajamohanan, R., & Latha, B. C. (2023). Optimized YOLOv5 for tomato leaf disease classification.
8. Abulizi, A., Ye, J., & Guo, W. (2024). DM-YOLO: An improved YOLOv9-based detector.
9. Tm, P., Pranathi, A., & Sai Ashritha, K. (2018). LeNet-based CNN for plant disease classification.
10. Shanthi, D. L., Vinutha, K., & Ashwini, N. (2024). Custom CNN architectures (AlexNet, VGGNet-16) for tomato disease classification.

## Appendix

**Key source files:**
- `lib/main.dart` — app entry point, Firebase/AppConfig initialization
- `lib/core/config/app_config.dart` — Gemini API key pool & rotation logic
- `lib/features/plant_detection/data/datasources/plant_detection_remote_datasource.dart` — Gemini API call & response parsing
- `lib/features/plant_detection/presentation/bloc/plant_detection_bloc.dart` — detection flow state management
- `lib/features/auth/` — Firebase Authentication (login, signup, profile)
- `lib/services/weather_service.dart` — Open-Meteo weather lookup

Full source code is available in the project repository.

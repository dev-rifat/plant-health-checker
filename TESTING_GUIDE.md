# Plant Health Detection - Testing Guide

## Test Scenarios

### 1. App Launch & Initial State

**Scenario**: User launches app for first time

**Expected Flow**:
```
✓ App loads without errors
✓ PlantDetectionPage displayed
✓ "ফসলের স্বাস্থ্য পরীক্ষা" title visible
✓ Plant icon (🌱) displayed
✓ "আপনার ফসলের ছবি তুলুন" text visible
✓ Two buttons visible:
  - "📷 ক্যামেরা থেকে ধরুন / Take Photo"
  - "🖼️ গ্যালারি থেকে বেছে নিন / Choose from Gallery"
✓ Theme applied correctly
```

**Test Steps**:
1. Run `flutter run`
2. Verify UI elements load
3. Check theme colors

---

### 2. Camera Image Capture

**Scenario**: User captures image using device camera

**Test Steps**:
1. Tap "Take Photo" button
2. System camera opens
3. Capture a test image
4. Return to app
5. Image should display in preview

**Expected Behavior**:
```
✓ Camera permission requested (first time)
✓ Camera app opens
✓ Image captured
✓ App returns to ImagePickedState
✓ Image preview shows correctly
✓ "Analyze" button visible
✓ "Cancel" button visible
```

**Test Cases**:
- Healthy plant image
- Diseased plant image
- Blurry image
- Dark/low light image

---

### 3. Gallery Image Selection

**Scenario**: User selects image from device gallery

**Test Steps**:
1. Tap "Choose from Gallery" button
2. Gallery app opens
3. Select a plant image
4. Return to app

**Expected Behavior**:
```
✓ Gallery permission requested (first time)
✓ Gallery opens
✓ Image selection works
✓ App returns to ImagePickedState
✓ Selected image displays
✓ "Analyze" button enabled
```

**Test Images**:
- JPEG format (common)
- PNG format
- Large resolution image
- Small resolution image

---

### 4. Image Analysis - Healthy Plant

**Scenario**: User analyzes a healthy plant image

**Test Steps**:
1. Select healthy plant image
2. Tap "Analyze"
3. Wait for API response

**Expected Result**:
```
State: PlantDetectionLoading
  ├─ Spinner visible
  ├─ "আপনার ফসল বিশ্লেষণ করা হচ্ছে..." message
  └─ "অনুগ্রহ করে অপেক্ষা করুন" text

State: PlantDetectionSuccess
  ├─ Green result card (isHealthy=true)
  ├─ Green checkmark icon ✓
  ├─ "ফসল স্বাস্থ্যকর 🌱" text
  └─ "🔄 নতুন বিশ্লেষণ করুন" button
```

**Example Test Cases**:
- Healthy mango plant
- Healthy rice crop
- Healthy vegetable plant

---

### 5. Image Analysis - Diseased Plant

**Scenario**: User analyzes plant with disease

**Test Steps**:
1. Select diseased plant image
2. Tap "Analyze"
3. Wait for API response

**Expected Result**:
```
State: PlantDetectionLoading
  (Same as above)

State: PlantDetectionSuccess
  ├─ Red/Orange result card (isHealthy=false)
  ├─ Warning icon ⚠️
  ├─ Card 1: Disease Information
  │   ├─ "রোগের নাম / Disease:" label
  │   └─ Disease name (e.g., "Powdery Mildew")
  │
  ├─ Card 2: Treatment
  │   ├─ "চিকিৎসা / Treatment:" label
  │   └─ Treatment (e.g., "Fungicide ছিটান")
  │
  ├─ Card 3: Advice
  │   ├─ "পরামর্শ / Advice:" label
  │   └─ Care instructions
  │
  └─ "🔄 নতুন বিশ্লেষণ করুন" button
```

**Example Test Cases**:
- Powdery mildew
- Leaf spot disease
- Rust infection
- Blight
- Pest infestation

---

### 6. Error Handling - Network Error

**Scenario**: API call fails due to network issue

**Test Steps**:
1. Enable Airplane Mode
2. Select image and tap "Analyze"
3. Wait for error

**Expected Result**:
```
State: PlantDetectionError
  ├─ Error icon (⚠️)
  ├─ "সমস্যা হয়েছে" heading
  ├─ Error message:
  │   "Error analyzing plant image: SocketException..."
  └─ "🏠 হোম পেজে ফিরুন" button
```

---

### 7. Error Handling - Invalid API Key

**Scenario**: API key is invalid or expired

**Test Steps**:
1. Use invalid API key in injection.dart
2. Run app and try to analyze

**Expected Result**:
```
State: PlantDetectionError
  ├─ Error message displayed
  ├─ Message indicates API error
  └─ "Go Back" button to retry
```

**Error Message Example**:
```
Failed to analyze image: 401 - 
{"error": {"code": 401, "message": "API key invalid"}}
```

---

### 8. Error Handling - No Image Selected

**Scenario**: User taps analyze without selecting image

**Expected Behavior**:
```
✓ "Cancel" button clears state
✓ Returns to PlantDetectionInitial
✓ Can select new image
```

---

### 9. UI State Transitions

**Scenario**: Verify smooth state transitions

**Test Flow**:
```
Initial
  ↓
[Tap Camera] → ImagePickedState → [Tap Analyze]
  ↓
Loading
  ↓
Success (or Error)
  ↓
[Tap Analyze Again] → ImagePickedState
  ↓
(Loop)
```

**Expected**:
```
✓ No crashes during transitions
✓ UI updates correctly
✓ No duplicate states
✓ Loading indicator appears/disappears correctly
✓ Buttons enable/disable appropriately
```

---

### 10. Multilingual Support

**Scenario**: Verify Bengali and English text

**Test Cases**:
```
✓ Title: "ফসলের স্বাস্থ্য পরীক্ষা / Plant Health Check"
✓ Camera: "ক্যামেরা থেকে ধরুন / Take Photo"
✓ Gallery: "গ্যালারি থেকে বেছে নিন / Choose from Gallery"
✓ Analyze: "বিশ্লেষণ করুন / Analyze"
✓ Disease: "রোগের নাম / Disease"
✓ Treatment: "চিকিৎসা / Treatment"
✓ Advice: "পরামর্শ / Advice"
✓ Error: "সমস্যা হয়েছে" + English explanation
```

---

### 11. Image Format Support

**Scenario**: Test different image formats

**Test Cases**:
```
✓ JPEG (.jpg, .jpeg)
✓ PNG (.png)
✓ GIF (.gif)
✓ WebP (.webp)
```

**Expected**: All formats should work correctly

---

### 12. Response Parsing

**Scenario**: Verify API response parsing

**Sample API Response** (Bengali):
```
"এই গাছে পাউডারি মিল্ডিউ রোগ দেখা যাচ্ছে। 
এটি একটি ফাঙ্গাল সংক্রমণ। 
চিকিৎসা: Sulfur ছিটান বা Fungicide প্রয়োগ করুন।
এক সপ্তাহ পর পুনরায় প্রয়োগ করুন।
গাছের আশেপাশ পরিষ্কার রাখুন।"
```

**Parsing Validation**:
```
✓ isHealthy = false
✓ disease contains "Powdery Mildew" or similar
✓ treatment extracted correctly
✓ advice displayed
```

---

### 13. Performance Testing

**Test Cases**:
```
✓ App launches in < 3 seconds
✓ Image preview shows < 1 second
✓ API response in 5-15 seconds (network dependent)
✓ UI remains responsive
✓ No ANR (Application Not Responding) errors
✓ Memory usage stable
✓ No memory leaks after multiple analyses
```

---

### 14. Permissions Testing

**Android**:
```
✓ First camera access → permission dialog
✓ Grant permission → camera works
✓ Deny permission → graceful error
✓ Gallery access → permission dialog
```

**iOS**:
```
✓ Camera permission request appears
✓ Photo library permission request appears
✓ User can grant/deny both
```

---

### 15. Edge Cases

**Test Scenarios**:
```
1. Very large image (5MB+)
   ✓ Should still work or show appropriate error

2. Very small image (< 100px)
   ✓ May not analyze but should handle gracefully

3. Image without plant
   ✓ AI response about no plant/irrelevant image

4. Multiple rapid analyses
   ✓ Should queue or show "already analyzing" message

5. App backgrounded during analysis
   ✓ Should handle gracefully when returned

6. Network timeout
   ✓ Should show timeout error

7. API rate limit exceeded
   ✓ Should show rate limit error
```

---

## Device Testing

### Recommended Test Devices
- [ ] Android phone (API 21+)
- [ ] Android tablet
- [ ] iPhone (iOS 11+)
- [ ] iPad

### OS Versions to Test
- [ ] Android 5.0+
- [ ] iOS 11.0+

### Screen Sizes to Test
- [ ] Small phone (4.5")
- [ ] Medium phone (5.5")
- [ ] Large phone (6.5"+)
- [ ] Tablet (7"+)

---

## Performance Benchmarks

```
Launch Time:        < 3 seconds
Image Load:         < 1 second
API Response:       5-15 seconds (normal)
Memory Usage:       < 150MB
CPU Usage:          < 50% during analysis
```

---

## Regression Testing Checklist

After each update, verify:

```
✓ App launches without crash
✓ Image capture works
✓ Image gallery selection works
✓ Image analysis completes
✓ Results display correctly
✓ Error handling works
✓ State transitions smooth
✓ No memory leaks
✓ Permissions work correctly
✓ Both languages display properly
```

---

## Test Data Sample Images

Create or obtain these for testing:

1. **Healthy Plants**
   - Healthy rice crop
   - Healthy mango plant
   - Healthy vegetable plant

2. **Diseased Plants**
   - Powdery mildew
   - Leaf spots
   - Rust infection
   - Blight
   - Pest damage

3. **Edge Cases**
   - Blurry image
   - Low light image
   - Wrong subject (non-plant)
   - Text/document
   - Animal/person

---

## Success Criteria ✅

**All tests pass when**:
```
✓ App launches without errors
✓ All buttons work correctly
✓ Images load and display properly
✓ API integration functions smoothly
✓ Results display accurately
✓ Error handling is graceful
✓ State management is correct
✓ Permissions are managed properly
✓ Both languages work correctly
✓ Performance is acceptable
✓ No crashes or ANRs
✓ UI looks good on multiple devices
```

---

## Known Test Issues (If Any)

Document any issues found during testing:
- Issue: [Description]
- Device: [Device info]
- Steps: [Reproduction steps]
- Workaround: [If available]

---

**Test Plan Version**: 1.0
**Last Updated**: May 12, 2026
**Status**: Ready for Testing

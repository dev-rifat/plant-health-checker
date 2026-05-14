import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:plant_health/features/plant_detection/data/models/plant_analysis_result_model.dart';

/// Remote data source for plant detection using Gemini API
abstract class PlantDetectionRemoteDataSource {
  Future<PlantAnalysisResultModel> analyzePlantImage(String imagePath);
}

class PlantDetectionRemoteDataSourceImpl
    implements PlantDetectionRemoteDataSource {
  final String geminiApiKey;
  final String baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-flash-latest:generateContent';

  PlantDetectionRemoteDataSourceImpl(this.geminiApiKey);

  @override
  Future<PlantAnalysisResultModel> analyzePlantImage(String imagePath) async {
    try {
      if (geminiApiKey.trim().isEmpty) {
        throw Exception(
          'Gemini API key is missing. Please add a new key with --dart-define.',
        );
      }

      final imageFile = File(imagePath);
      if (!imageFile.existsSync()) {
        throw Exception('Image file not found');
      }

      // Read image as base64
      final imageBytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(imageBytes);

      // Detect image mime type
      final mimeType = _getMimeType(imagePath);

      // Prepare request body with detailed prompt
      final requestBody = {
        'contents': [
          {
            'parts': [
              {
                'text': '''বিস্তারিত বিশ্লেষণ করুন এবং নিম্নলিখিত তথ্য দিন:

1. ফসল স্বাস্থ্যকর নাকি রোগাক্রান্ত (হ্যাঁ/না)
2. যদি রোগাক্রান্ত হয়:
   রোগের নাম (বাংলা): 
   Disease Name (English):
   গুরুত্ব (হালকা/মধ্যম/গুরুতর):
   লক্ষণ:
   
3. সুপারিশকৃত ওষুধ:
   ওষুধ ১: [নাম (বাংলা/English)], মাত্রা
   ওষুধ ২: [নাম (বাংলা/English)], মাত্রা
   
4. প্রয়োজনীয় যত্ন এবং পদক্ষেপ

বিস্তারিত এবং সুনির্দিষ্ট উত্তর দিন। প্রতিটি রোগের জন্য নির্দিষ্ট ওষুধ এবং মাত্রা উল্লেখ করুন।'''
              },
              {
                'inline_data': {
                  'mime_type': mimeType,
                  'data': base64Image,
                }
              }
            ]
          }
        ]
      };

      // Make API request
      final response = await http.post(
        Uri.parse('$baseUrl?key=$geminiApiKey'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final responseText =
            jsonResponse['candidates'][0]['content']['parts'][0]['text'] ?? '';

        // DEBUG: Print the actual API response
        print('═══════════════════════════════════════════════════════════');
        print('🔍 ACTUAL GEMINI API RESPONSE:');
        print('═══════════════════════════════════════════════════════════');
        print(responseText);
        print('═══════════════════════════════════════════════════════════');

        // Create model from response
        return PlantAnalysisResultModel.fromGeminiResponse(
          apiResponse: responseText,
          imageUrl: imagePath,
        );
      } else {
        final jsonResponse = jsonDecode(response.body);
        final errorStatus = jsonResponse['error']?['status']?.toString() ?? '';
        final errorMessage = jsonResponse['error']?['message']?.toString() ?? '';

        if (response.statusCode == 403 ||
            errorStatus == 'PERMISSION_DENIED' ||
            errorMessage.toLowerCase().contains('api key')) {
          throw Exception(
            'Gemini API key is blocked, leaked, or restricted. Create a new key and run the app again.',
          );
        }

        throw Exception(
          'Failed to analyze image: ${response.statusCode} - $errorMessage',
        );
      }
    } catch (e) {
      throw Exception('Error analyzing plant image: $e');
    }
  }

  /// Get MIME type based on file extension
  String _getMimeType(String imagePath) {
    final extension = imagePath.toLowerCase().split('.').last;
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      default:
        return 'image/jpeg';
    }
  }
}

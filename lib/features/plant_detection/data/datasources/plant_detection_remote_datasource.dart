import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:plant_health/core/config/app_config.dart';
import 'package:plant_health/features/plant_detection/data/models/plant_analysis_result_model.dart';

/// Remote data source for plant detection using Gemini API
abstract class PlantDetectionRemoteDataSource {
  Future<PlantAnalysisResultModel> analyzePlantImage(String imagePath);
}

/// Thrown when a Gemini key is expired, blocked, or over quota so callers
/// can distinguish "try the next key" from a genuine request failure.
class _GeminiKeyRejectedException implements Exception {
  final String message;
  _GeminiKeyRejectedException(this.message);
}

/// Thrown on a 5xx from Gemini. Rotating keys wouldn't help here — the
/// backend itself is down for every key — so this is retried on the same
/// key with backoff instead of being treated like [_GeminiKeyRejectedException].
class _GeminiServerBusyException implements Exception {}

class PlantDetectionRemoteDataSourceImpl
    implements PlantDetectionRemoteDataSource {
  final String baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-flash-latest:generateContent';

  static const _requestTimeout = Duration(seconds: 30);
  static const _serverErrorRetries = 2;

  @override
  Future<PlantAnalysisResultModel> analyzePlantImage(String imagePath) async {
    if (!AppConfig.hasGeminiApiKey) {
      throw Exception(
        'Gemini API key is missing. Configure gemini_api_keys in Remote Config '
        'or run with --dart-define=GEMINI_API_KEYS=key1,key2.',
      );
    }

    final imageFile = File(imagePath);
    if (!imageFile.existsSync()) {
      throw Exception('Image file not found');
    }

    final imageBytes = await imageFile.readAsBytes();
    final base64Image = base64Encode(imageBytes);
    final mimeType = _getMimeType(imagePath);

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

    // Try every key in the pool; rotate on expired/blocked/quota errors.
    for (var attempt = 0; attempt < AppConfig.geminiApiKeyCount; attempt++) {
      try {
        return await _sendWithServerRetry(requestBody, imagePath);
      } on _GeminiKeyRejectedException catch (e) {
        final hasNextKey = AppConfig.rotateGeminiApiKey(attempt: attempt);
        if (!hasNextKey) {
          throw Exception(
            'সব API key ব্যবহার করা হয়েছে কিন্তু কোনোটিই কাজ করেনি: ${e.message}',
          );
        }
        // loop continues with the rotated key
      }
    }

    throw Exception('Gemini API key is missing.');
  }

  /// Retries a transient 5xx on the *same* key with backoff before giving up
  /// — a server outage affects every key equally, so rotating wastes keys.
  Future<PlantAnalysisResultModel> _sendWithServerRetry(
    Map<String, dynamic> requestBody,
    String imagePath,
  ) async {
    for (var serverAttempt = 0; ; serverAttempt++) {
      try {
        return await _sendRequest(requestBody, imagePath);
      } on _GeminiServerBusyException {
        if (serverAttempt >= _serverErrorRetries) {
          throw Exception(
            'Gemini সার্ভার এই মুহূর্তে ব্যস্ত। কিছুক্ষণ পর আবার চেষ্টা করুন।',
          );
        }
        await Future.delayed(Duration(seconds: 1 << serverAttempt)); // 1s, 2s
      }
    }
  }

  Future<PlantAnalysisResultModel> _sendRequest(
    Map<String, dynamic> requestBody,
    String imagePath,
  ) async {
    final apiKey = AppConfig.geminiApiKey;

    http.Response response;
    try {
      response = await http
          .post(
            Uri.parse('$baseUrl?key=$apiKey'),
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode(requestBody),
          )
          .timeout(_requestTimeout);
    } on TimeoutException {
      throw Exception(
        'ইন্টারনেট সংযোগ ধীর — অনুরোধের সময়সীমা শেষ হয়ে গেছে। আবার চেষ্টা করুন।',
      );
    } on SocketException {
      throw Exception(
        'ইন্টারনেট সংযোগ পাওয়া যায়নি। সংযোগ পরীক্ষা করে আবার চেষ্টা করুন।',
      );
    }

    Map<String, dynamic> jsonResponse;
    try {
      jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
    } on FormatException {
      throw Exception(
        'সার্ভার থেকে অপ্রত্যাশিত উত্তর এসেছে (HTTP ${response.statusCode})। আবার চেষ্টা করুন।',
      );
    }

    if (response.statusCode == 200) {
      final blockReason = jsonResponse['promptFeedback']?['blockReason'];
      final candidates = jsonResponse['candidates'] as List?;
      if (blockReason != null || candidates == null || candidates.isEmpty) {
        throw Exception(
          'ছবিটি বিশ্লেষণ করা যায়নি — নিরাপত্তা নীতির কারণে ব্লক করা হয়েছে। অন্য একটি ছবি চেষ্টা করুন।',
        );
      }

      final responseText =
          (candidates[0]['content']?['parts']?[0]?['text'] as String?) ?? '';
      if (responseText.trim().isEmpty) {
        throw Exception('Gemini থেকে কোনো উত্তর পাওয়া যায়নি। আবার চেষ্টা করুন।');
      }

      return PlantAnalysisResultModel.fromGeminiResponse(
        apiResponse: responseText,
        imageUrl: imagePath,
      );
    }

    final errorStatus = jsonResponse['error']?['status']?.toString() ?? '';
    final errorMessage = jsonResponse['error']?['message']?.toString() ?? '';

    final isKeyRejected = response.statusCode == 403 ||
        response.statusCode == 429 ||
        errorStatus == 'PERMISSION_DENIED' ||
        errorStatus == 'RESOURCE_EXHAUSTED' ||
        errorMessage.toLowerCase().contains('api key');

    if (isKeyRejected) {
      throw _GeminiKeyRejectedException(errorMessage.isNotEmpty
          ? errorMessage
          : 'HTTP ${response.statusCode}');
    }

    if (response.statusCode >= 500) {
      throw _GeminiServerBusyException();
    }

    throw Exception(
      'ছবি বিশ্লেষণ ব্যর্থ হয়েছে: HTTP ${response.statusCode} - $errorMessage',
    );
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

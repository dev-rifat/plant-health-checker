import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

class AppConfig {
  // Fallback key used only when Remote Config is unavailable
  static const String _fallbackKey = String.fromEnvironment(
    'GEMINI_API_KEY',
    defaultValue: 'AIzaSyCmPRhYlU-JF5ZD8BSvMop2CO6Qx9xS0uo',
  );

  static String _runtimeKey = _fallbackKey;

  /// Call this once at app startup (after Firebase.initializeApp)
  static Future<void> initialize() async {
    try {
      final remoteConfig = FirebaseRemoteConfig.instance;

      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: const Duration(hours: 1),
      ));

      // Set default so the app works even before first fetch
      await remoteConfig.setDefaults({'gemini_api_key': _fallbackKey});

      await remoteConfig.fetchAndActivate();

      final fetchedKey = remoteConfig.getString('gemini_api_key').trim();
      if (fetchedKey.isNotEmpty) {
        _runtimeKey = fetchedKey;
        debugPrint('✅ Gemini key loaded from Remote Config');
      }
    } catch (e) {
      debugPrint('⚠️ Remote Config fetch failed, using fallback key: $e');
    }
  }

  static String get geminiApiKey => _runtimeKey;
  static bool get hasGeminiApiKey => _runtimeKey.trim().isNotEmpty;
}
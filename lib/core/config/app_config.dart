class AppConfig {
  static const String geminiApiKey = String.fromEnvironment(
    'GEMINI_API_KEY',
    defaultValue: 'AIzaSyCmPRhYlU-JF5ZD8BSvMop2CO6Qx9xS0uo',
  );

  static bool get hasGeminiApiKey => geminiApiKey.trim().isNotEmpty;
}
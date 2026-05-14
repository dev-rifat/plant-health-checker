class AppConfig {
  static const String geminiApiKey = String.fromEnvironment(
    'GEMINI_API_KEY',
    defaultValue: 'AIzaSyAKUk79Q7N1YugqwGLR2KsCC0Ig9LBC5C4',
  );

  static bool get hasGeminiApiKey => geminiApiKey.trim().isNotEmpty;
}
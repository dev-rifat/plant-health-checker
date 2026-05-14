import 'package:plant_health/features/plant_detection/domain/entities/plant_analysis_result.dart';

/// Repository interface for plant detection
abstract class PlantDetectionRepository {
  /// Analyze plant image from file path
  Future<PlantAnalysisResult> analyzePlantImage(String imagePath);
}

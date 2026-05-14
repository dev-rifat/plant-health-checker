import 'package:plant_health/features/plant_detection/domain/entities/plant_analysis_result.dart';
import 'package:plant_health/features/plant_detection/domain/repositories/plant_detection_repository.dart';

/// Use case to analyze plant image
class AnalyzePlantImageUseCase {
  final PlantDetectionRepository repository;

  AnalyzePlantImageUseCase(this.repository);

  Future<PlantAnalysisResult> call(String imagePath) {
    return repository.analyzePlantImage(imagePath);
  }
}

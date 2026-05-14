import 'package:plant_health/features/plant_detection/data/datasources/plant_detection_remote_datasource.dart';
import 'package:plant_health/features/plant_detection/domain/entities/plant_analysis_result.dart';
import 'package:plant_health/features/plant_detection/domain/repositories/plant_detection_repository.dart';

/// Repository implementation for plant detection
class PlantDetectionRepositoryImpl implements PlantDetectionRepository {
  final PlantDetectionRemoteDataSource remoteDataSource;

  PlantDetectionRepositoryImpl(this.remoteDataSource);

  @override
  Future<PlantAnalysisResult> analyzePlantImage(String imagePath) async {
    final model = await remoteDataSource.analyzePlantImage(imagePath);
    return model.toEntity();
  }
}

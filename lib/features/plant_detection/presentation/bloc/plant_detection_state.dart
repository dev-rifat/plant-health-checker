import 'package:equatable/equatable.dart';
import 'package:plant_health/features/plant_detection/domain/entities/plant_analysis_result.dart';

/// States for plant detection BLoC
abstract class PlantDetectionState extends Equatable {
  const PlantDetectionState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class PlantDetectionInitial extends PlantDetectionState {
  const PlantDetectionInitial();
}

/// Loading state while analyzing image
class PlantDetectionLoading extends PlantDetectionState {
  const PlantDetectionLoading();
}

/// Success state with analysis result
class PlantDetectionSuccess extends PlantDetectionState {
  final PlantAnalysisResult result;

  const PlantDetectionSuccess(this.result);

  @override
  List<Object?> get props => [result];
}

/// Error state
class PlantDetectionError extends PlantDetectionState {
  final String message;

  const PlantDetectionError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Image picked state
class ImagePickedState extends PlantDetectionState {
  final String imagePath;

  const ImagePickedState(this.imagePath);

  @override
  List<Object?> get props => [imagePath];
}

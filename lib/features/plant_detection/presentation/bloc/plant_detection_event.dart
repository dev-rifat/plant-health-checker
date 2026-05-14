import 'package:equatable/equatable.dart';

/// Events for plant detection BLoC
abstract class PlantDetectionEvent extends Equatable {
  const PlantDetectionEvent();

  @override
  List<Object?> get props => [];
}

/// Event to analyze plant image
class AnalyzePlantImageEvent extends PlantDetectionEvent {
  final String imagePath;

  const AnalyzePlantImageEvent(this.imagePath);

  @override
  List<Object?> get props => [imagePath];
}

/// Event to pick image from gallery
class PickImageFromGalleryEvent extends PlantDetectionEvent {
  const PickImageFromGalleryEvent();
}

/// Event to capture image from camera
class CaptureImageFromCameraEvent extends PlantDetectionEvent {
  const CaptureImageFromCameraEvent();
}

/// Event to reset state
class ResetPlantDetectionEvent extends PlantDetectionEvent {
  const ResetPlantDetectionEvent();
}

class ReturnToImagePreviewEvent extends PlantDetectionEvent {
  final String imagePath;

  const ReturnToImagePreviewEvent(this.imagePath);

  @override
  List<Object?> get props => [imagePath];
}

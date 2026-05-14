/// Dependency Injection setup
/// This file contains all the dependency injection configuration using GetIt
/// Place all service registrations here

import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:plant_health/features/auth/data/services/firebase_auth_service.dart';
import 'package:plant_health/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:plant_health/features/plant_detection/data/datasources/plant_detection_remote_datasource.dart';
import 'package:plant_health/features/plant_detection/data/repositories/plant_detection_repository_impl.dart';
import 'package:plant_health/features/plant_detection/domain/repositories/plant_detection_repository.dart';
import 'package:plant_health/features/plant_detection/domain/usecases/analyze_plant_image_usecase.dart';
import 'package:plant_health/features/plant_detection/presentation/bloc/plant_detection_bloc.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  if (!getIt.isRegistered<FirebaseAuthService>()) {
    getIt.registerLazySingleton<FirebaseAuthService>(
      () => FirebaseAuthService(FirebaseAuth.instance),
    );
  }

  if (!getIt.isRegistered<AuthCubit>()) {
    getIt.registerFactory<AuthCubit>(
      () => AuthCubit(authService: getIt<FirebaseAuthService>()),
    );
  }

  // Register ImagePicker
  getIt.registerSingleton<ImagePicker>(ImagePicker());

  // Register Remote Data Sources
  getIt.registerSingleton<PlantDetectionRemoteDataSource>(
    PlantDetectionRemoteDataSourceImpl(
      'AIzaSyAClHeMSF5Nntknb0rgJr4fOPKS3EG4MQY', // Gemini API key
    ),
  );

  // Register Repositories
  getIt.registerSingleton<PlantDetectionRepository>(
    PlantDetectionRepositoryImpl(getIt<PlantDetectionRemoteDataSource>()),
  );

  // Register Use Cases
  getIt.registerSingleton<AnalyzePlantImageUseCase>(
    AnalyzePlantImageUseCase(getIt<PlantDetectionRepository>()),
  );

  // Register BLoCs
  getIt.registerSingleton<PlantDetectionBloc>(
    PlantDetectionBloc(
      analyzePlantImageUseCase: getIt<AnalyzePlantImageUseCase>(),
      imagePicker: getIt<ImagePicker>(),
    ),
  );
}

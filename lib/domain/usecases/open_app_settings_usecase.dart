import '../repositories/app_repository.dart';

/// Use case for opening app settings
class OpenAppSettingsUseCase {
  final AppRepository repository;

  OpenAppSettingsUseCase(this.repository);

  Future<void> call(String packageName) async {
    await repository.openAppSettings(packageName);
  }
}

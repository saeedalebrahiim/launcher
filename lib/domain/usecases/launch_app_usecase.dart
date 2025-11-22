import '../repositories/app_repository.dart';

/// Use case for launching an app
class LaunchAppUseCase {
  final AppRepository repository;

  LaunchAppUseCase(this.repository);

  Future<void> call(String packageName) async {
    await repository.launchApp(packageName);
  }
}

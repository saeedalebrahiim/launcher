import '../repositories/app_usage_repository.dart';

/// Use case for monitoring app usage
class MonitorAppUsageUseCase {
  final AppUsageRepository repository;

  MonitorAppUsageUseCase(this.repository);

  void startMonitoring() {
    repository.startMonitoring();
  }

  void stopMonitoring() {
    repository.stopMonitoring();
  }
}

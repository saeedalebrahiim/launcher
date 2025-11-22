import '../entities/app_entity.dart';

/// Repository interface for app operations
abstract class AppRepository {
  /// Get all installed applications
  Future<List<AppEntity>> getInstalledApps({
    required bool includeSystemApps,
    required bool withIcon,
  });

  /// Launch an application by package name
  Future<void> launchApp(String packageName);

  /// Open app settings
  Future<void> openAppSettings(String packageName);
}

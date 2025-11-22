import '../entities/app_entity.dart';

/// Repository interface for app operations
abstract class AppRepository {
  /// Get all installed applications
  Future<List<AppEntity>> getInstalledApps({
    required bool includeSystemApps,
    required bool withIcon,
    bool forceRefresh = false,
  });

  /// Get cached apps if available
  List<AppEntity>? getCachedApps();

  /// Check if cache is valid
  bool isCacheValid();

  /// Clear the cache
  void clearCache();

  /// Launch an application by package name
  Future<void> launchApp(String packageName);

  /// Open app settings
  Future<void> openAppSettings(String packageName);
}

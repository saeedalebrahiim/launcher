/// Repository interface for app usage monitoring
abstract class AppUsageRepository {
  /// Start monitoring app usage
  void startMonitoring();

  /// Stop monitoring app usage
  void stopMonitoring();

  /// Close app by package name
  Future<void> closeApp(String packageName);

  /// Get currently running app
  Future<String?> getCurrentApp();
}

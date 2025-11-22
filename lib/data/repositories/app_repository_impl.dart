import 'package:installed_apps/installed_apps.dart';
import '../../domain/entities/app_entity.dart';
import '../../domain/repositories/app_repository.dart';

/// Implementation of AppRepository using installed_apps package
class AppRepositoryImpl implements AppRepository {
  List<AppEntity>? _cachedApps;
  DateTime? _cacheTimestamp;
  static const _cacheDuration = Duration(minutes: 5);

  @override
  Future<List<AppEntity>> getInstalledApps({
    required bool includeSystemApps,
    required bool withIcon,
    bool forceRefresh = false,
  }) async {
    // Return cached apps if available and valid
    if (!forceRefresh && isCacheValid() && _cachedApps != null) {
      return _cachedApps!;
    }

    // Fetch fresh data
    final apps = await InstalledApps.getInstalledApps(
      includeSystemApps,
      withIcon,
    );

    _cachedApps = apps.map((app) => AppEntity.fromAppInfo(app)).toList();
    _cacheTimestamp = DateTime.now();

    return _cachedApps!;
  }

  @override
  List<AppEntity>? getCachedApps() {
    return _cachedApps;
  }

  @override
  bool isCacheValid() {
    if (_cacheTimestamp == null) return false;
    return DateTime.now().difference(_cacheTimestamp!) < _cacheDuration;
  }

  @override
  void clearCache() {
    _cachedApps = null;
    _cacheTimestamp = null;
  }

  @override
  Future<void> launchApp(String packageName) async {
    await InstalledApps.startApp(packageName);
  }

  @override
  Future<void> openAppSettings(String packageName) async {
    await InstalledApps.openSettings(packageName);
  }
}

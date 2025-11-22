import '../entities/app_entity.dart';
import '../repositories/app_repository.dart';

/// Use case for getting installed apps
class GetInstalledAppsUseCase {
  final AppRepository repository;

  GetInstalledAppsUseCase(this.repository);

  Future<List<AppEntity>> call({
    bool includeSystemApps = true,
    bool withIcon = true,
    bool forceRefresh = false,
  }) async {
    final apps = await repository.getInstalledApps(
      includeSystemApps: includeSystemApps,
      withIcon: withIcon,
      forceRefresh: forceRefresh,
    );

    // Sort apps alphabetically
    apps.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    return apps;
  }

  /// Get cached apps if available
  List<AppEntity>? getCachedApps() {
    final cachedApps = repository.getCachedApps();
    if (cachedApps != null) {
      final sorted = List<AppEntity>.from(cachedApps);
      sorted
          .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      return sorted;
    }
    return null;
  }

  /// Check if cache is valid
  bool isCacheValid() {
    return repository.isCacheValid();
  }

  /// Clear the cache
  void clearCache() {
    repository.clearCache();
  }
}

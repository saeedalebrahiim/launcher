import '../entities/app_entity.dart';
import '../repositories/app_repository.dart';

/// Use case for getting installed apps
class GetInstalledAppsUseCase {
  final AppRepository repository;

  GetInstalledAppsUseCase(this.repository);

  Future<List<AppEntity>> call({
    bool includeSystemApps = true,
    bool withIcon = true,
  }) async {
    final apps = await repository.getInstalledApps(
      includeSystemApps: includeSystemApps,
      withIcon: withIcon,
    );

    // Sort apps alphabetically
    apps.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    return apps;
  }
}

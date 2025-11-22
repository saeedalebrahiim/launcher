import 'package:installed_apps/installed_apps.dart';
import '../../domain/entities/app_entity.dart';
import '../../domain/repositories/app_repository.dart';

/// Implementation of AppRepository using installed_apps package
class AppRepositoryImpl implements AppRepository {
  @override
  Future<List<AppEntity>> getInstalledApps({
    required bool includeSystemApps,
    required bool withIcon,
  }) async {
    final apps = await InstalledApps.getInstalledApps(
      includeSystemApps,
      withIcon,
    );

    return apps.map((app) => AppEntity.fromAppInfo(app)).toList();
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

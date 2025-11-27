import '../../data/repositories/app_repository_impl.dart';
import '../../data/repositories/app_usage_repository_impl.dart';
import '../../domain/usecases/get_installed_apps_usecase.dart';
import '../../domain/usecases/launch_app_usecase.dart';
import '../../domain/usecases/open_app_settings_usecase.dart';
import '../../domain/usecases/monitor_app_usage_usecase.dart';
import '../cubit/launcher_cubit.dart';

/// Dependency injection container
class DependencyInjection {
  static LauncherCubit provideLauncherCubit() {
    // Repositories
    final appRepository = AppRepositoryImpl();
    final appUsageRepository = AppUsageRepositoryImpl();

    // Use cases
    final getInstalledAppsUseCase = GetInstalledAppsUseCase(appRepository);
    final launchAppUseCase = LaunchAppUseCase(appRepository);
    final openAppSettingsUseCase = OpenAppSettingsUseCase(appRepository);
    final monitorAppUsageUseCase = MonitorAppUsageUseCase(appUsageRepository);

    // Cubit
    return LauncherCubit(
      getInstalledAppsUseCase: getInstalledAppsUseCase,
      launchAppUseCase: launchAppUseCase,
      openAppSettingsUseCase: openAppSettingsUseCase,
      monitorAppUsageUseCase: monitorAppUsageUseCase,
    );
  }
}

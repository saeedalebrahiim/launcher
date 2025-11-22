import '../../data/repositories/app_repository_impl.dart';
import '../../domain/usecases/get_installed_apps_usecase.dart';
import '../../domain/usecases/launch_app_usecase.dart';
import '../../domain/usecases/open_app_settings_usecase.dart';
import '../cubit/launcher_cubit.dart';

/// Dependency injection container
class DependencyInjection {
  static LauncherCubit provideLauncherCubit() {
    // Repository
    final appRepository = AppRepositoryImpl();

    // Use cases
    final getInstalledAppsUseCase = GetInstalledAppsUseCase(appRepository);
    final launchAppUseCase = LaunchAppUseCase(appRepository);
    final openAppSettingsUseCase = OpenAppSettingsUseCase(appRepository);

    // Cubit
    return LauncherCubit(
      getInstalledAppsUseCase: getInstalledAppsUseCase,
      launchAppUseCase: launchAppUseCase,
      openAppSettingsUseCase: openAppSettingsUseCase,
    );
  }
}

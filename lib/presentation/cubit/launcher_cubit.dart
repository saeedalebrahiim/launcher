import 'package:flutter/material.dart';
import '../../domain/entities/app_entity.dart';
import '../../domain/usecases/get_installed_apps_usecase.dart';
import '../../domain/usecases/launch_app_usecase.dart';
import '../../domain/usecases/open_app_settings_usecase.dart';

/// Cubit for managing launcher state
class LauncherCubit extends ChangeNotifier {
  final GetInstalledAppsUseCase getInstalledAppsUseCase;
  final LaunchAppUseCase launchAppUseCase;
  final OpenAppSettingsUseCase openAppSettingsUseCase;

  LauncherCubit({
    required this.getInstalledAppsUseCase,
    required this.launchAppUseCase,
    required this.openAppSettingsUseCase,
  }) {
    _loadFromCache();
  }

  List<AppEntity> _apps = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _searchQuery = '';

  List<AppEntity> get apps => _apps;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;
  bool get isCacheValid => getInstalledAppsUseCase.isCacheValid();

  void _loadFromCache() {
    final cachedApps = getInstalledAppsUseCase.getCachedApps();
    if (cachedApps != null) {
      _apps = cachedApps;
    }
  }

  List<AppEntity> get filteredApps {
    if (_searchQuery.isEmpty) {
      return _apps;
    }
    return _apps.where((app) {
      return app.name.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> loadApps({bool forceRefresh = false}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _apps = await getInstalledAppsUseCase(forceRefresh: forceRefresh);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Error loading apps: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearCache() {
    getInstalledAppsUseCase.clearCache();
    _apps = [];
    notifyListeners();
  }

  Future<void> launchApp(AppEntity app) async {
    try {
      await launchAppUseCase(app.packageName);
    } catch (e) {
      _errorMessage = 'Error launching app: $e';
      notifyListeners();
    }
  }

  Future<void> openAppSettings(AppEntity app) async {
    try {
      await openAppSettingsUseCase(app.packageName);
    } catch (e) {
      _errorMessage = 'Error opening app settings: $e';
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}

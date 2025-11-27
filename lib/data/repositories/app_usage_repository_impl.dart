import 'dart:async';
import 'package:flutter/services.dart';
import '../../domain/repositories/app_usage_repository.dart';

/// Implementation of AppUsageRepository using platform channels
class AppUsageRepositoryImpl implements AppUsageRepository {
  static const MethodChannel _channel =
      MethodChannel('com.example.launcher/app_monitor');
  Timer? _monitoringTimer;
  DateTime? _appStartTime;
  String? _currentAppPackage;
  static const _appTimeLimit = Duration(seconds: 30);

  @override
  void startMonitoring() {
    _monitoringTimer?.cancel();
    _monitoringTimer = Timer.periodic(const Duration(seconds: 1), (_) async {
      await _checkAndCloseApp();
    });
  }

  @override
  void stopMonitoring() {
    _monitoringTimer?.cancel();
    _monitoringTimer = null;
    _appStartTime = null;
    _currentAppPackage = null;
  }

  Future<void> _checkAndCloseApp() async {
    try {
      final currentApp = await getCurrentApp();

      // Skip if no app detected
      if (currentApp == null) {
        _appStartTime = null;
        _currentAppPackage = null;
        return;
      }

      // Skip if it's the launcher itself
      if (currentApp == 'com.example.launcher' ||
          currentApp.contains('launcher')) {
        _appStartTime = null;
        _currentAppPackage = null;
        return;
      }

      // Check if app changed
      if (currentApp != _currentAppPackage) {
        _currentAppPackage = currentApp;
        _appStartTime = DateTime.now();
        print('App started: $currentApp');
        return;
      }

      // Check if time limit exceeded
      if (_appStartTime != null && currentApp == _currentAppPackage) {
        final elapsed = DateTime.now().difference(_appStartTime!);
        print(
            'App: $currentApp, Time: ${elapsed.inSeconds}s / ${_appTimeLimit.inSeconds}s');

        if (elapsed >= _appTimeLimit) {
          print('Closing app: $currentApp');
          await closeApp(currentApp);
          _appStartTime = null;
          _currentAppPackage = null;
        }
      }
    } catch (e) {
      print('Error in _checkAndCloseApp: $e');
    }
  }

  @override
  Future<void> closeApp(String packageName) async {
    try {
      await _channel.invokeMethod('closeApp', {'packageName': packageName});
      print('Successfully called closeApp for: $packageName');
    } on PlatformException catch (e) {
      print('PlatformException in closeApp: ${e.code} - ${e.message}');
      throw Exception('Failed to close app: ${e.message}');
    } on MissingPluginException catch (e) {
      print('MissingPluginException in closeApp: $e');
      print('Native code not properly connected. App needs full rebuild.');
      rethrow;
    }
  }

  @override
  Future<String?> getCurrentApp() async {
    try {
      final result = await _channel.invokeMethod<String>('getCurrentApp');
      return result;
    } on PlatformException catch (e) {
      print('PlatformException in getCurrentApp: ${e.code} - ${e.message}');
      return null;
    } on MissingPluginException catch (e) {
      print('MissingPluginException in getCurrentApp: $e');
      print('SOLUTION: Stop the app and run: flutter clean && flutter run');
      rethrow;
    }
  }
}

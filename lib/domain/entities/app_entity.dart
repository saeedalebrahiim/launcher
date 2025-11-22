import 'package:installed_apps/app_info.dart';

/// Entity representing an installed application
class AppEntity {
  final String name;
  final String packageName;
  final List<int>? icon;
  final String versionName;
  final int versionCode;

  AppEntity({
    required this.name,
    required this.packageName,
    this.icon,
    required this.versionName,
    required this.versionCode,
  });

  /// Factory constructor to create AppEntity from AppInfo
  factory AppEntity.fromAppInfo(AppInfo appInfo) {
    return AppEntity(
      name: appInfo.name,
      packageName: appInfo.packageName,
      icon: appInfo.icon,
      versionName: appInfo.versionName,
      versionCode: appInfo.versionCode,
    );
  }
}

class AppSettings {
  static const int defaultAppTimeLimit = 30; // seconds

  bool autoCloseAppsEnabled;
  int appTimeLimitSeconds;

  AppSettings({
    this.autoCloseAppsEnabled = true,
    this.appTimeLimitSeconds = defaultAppTimeLimit,
  });
}

# Auto-Close Apps Feature

This launcher includes an automatic app-closing feature that helps manage screen time by automatically closing apps after a specified duration.

## How It Works

1. **Monitoring**: The launcher continuously monitors which app is currently in the foreground
2. **Time Tracking**: When you switch to an app, a timer starts tracking how long the app has been in use
3. **Auto-Close**: After 30 seconds (configurable), the app is automatically closed and you're returned to the launcher

## Technical Implementation

### Architecture

```
Presentation Layer (Cubit)
    ↓
Domain Layer (Use Case)
    ↓
Data Layer (Repository)
    ↓
Platform Channel (Android Native Code)
```

### Components

#### Flutter Side
- **AppUsageRepository**: Interface for app monitoring operations
- **AppUsageRepositoryImpl**: Implementation using Flutter Method Channels
- **MonitorAppUsageUseCase**: Business logic for monitoring
- **LauncherCubit**: Manages monitoring lifecycle

#### Android Side (MainActivity.kt)
- **Method Channel**: `com.example.launcher/app_monitor`
- **getCurrentApp**: Gets the currently running foreground app
- **closeApp**: Closes the specified app and returns to launcher

### Required Permissions

```xml
<uses-permission android:name="android.permission.GET_TASKS"/>
<uses-permission android:name="android.permission.KILL_BACKGROUND_PROCESSES"/>
<uses-permission android:name="android.permission.PACKAGE_USAGE_STATS"/>
```

## Usage Stats Permission

For Android 5.1+ (API 22+), the app uses `UsageStatsManager` which requires the `PACKAGE_USAGE_STATS` permission. Users need to grant this permission manually:

1. Open **Settings**
2. Go to **Apps & notifications** → **Special app access**
3. Select **Usage access**
4. Enable permission for this launcher

## Configuration

The default time limit is **30 seconds**. This can be adjusted in the constants:

```dart
// lib/core/constants/app_constants.dart
static const int defaultAppTimeLimitSeconds = 30;
```

## Monitoring Lifecycle

- **Start**: Monitoring begins when the launcher cubit is initialized
- **Stop**: Monitoring stops when the cubit is disposed
- **Check Interval**: Apps are checked every 1 second

## Limitations

- Apps won't be closed if they have unsaved data (Android system protection)
- System apps may not be closeable due to Android restrictions
- The launcher itself is excluded from auto-closing

## Future Enhancements

- [ ] Configurable time limits per app
- [ ] Whitelist apps that shouldn't be auto-closed
- [ ] Usage statistics and reports
- [ ] Notification before closing
- [ ] Settings UI for customization

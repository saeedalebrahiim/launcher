import 'package:flutter/material.dart';
import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'presentation/di/dependency_injection.dart';
import 'presentation/pages/launcher_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appTitle,
      theme: AppTheme.darkTheme(),
      home: LauncherPage(
        cubit: DependencyInjection.provideLauncherCubit(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

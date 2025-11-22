import 'package:flutter/material.dart';
import '../../../domain/entities/app_entity.dart';

class AppOptionsBottomSheet extends StatelessWidget {
  final AppEntity app;
  final VoidCallback onOpen;
  final VoidCallback onAppInfo;

  const AppOptionsBottomSheet({
    super.key,
    required this.app,
    required this.onOpen,
    required this.onAppInfo,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.launch),
            title: const Text('Open app'),
            onTap: onOpen,
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('App info'),
            onTap: onAppInfo,
          ),
          ListTile(
            leading: const Icon(Icons.cancel),
            title: const Text('Cancel'),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}

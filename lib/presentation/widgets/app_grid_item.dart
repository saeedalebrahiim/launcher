import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../../domain/entities/app_entity.dart';
import '../../../core/constants/app_constants.dart';

class AppGridItem extends StatelessWidget {
  final AppEntity app;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const AppGridItem({
    super.key,
    required this.app,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      borderRadius: BorderRadius.circular(AppConstants.appIconBorderRadius),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // App icon
          if (app.icon != null)
            ClipRRect(
              borderRadius:
                  BorderRadius.circular(AppConstants.appIconBorderRadius),
              child: Image.memory(
                Uint8List.fromList(app.icon!),
                width: AppConstants.appIconSize,
                height: AppConstants.appIconSize,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildDefaultIcon(context);
                },
              ),
            )
          else
            _buildDefaultIcon(context),
          const SizedBox(height: 8),

          // App name
          Expanded(
            child: Text(
              app.name,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultIcon(BuildContext context) {
    return Container(
      width: AppConstants.appIconSize,
      height: AppConstants.appIconSize,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(AppConstants.appIconBorderRadius),
      ),
      child: Icon(
        Icons.android,
        size: 32,
        color: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
    );
  }
}

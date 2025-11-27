import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../domain/entities/app_entity.dart';
import '../cubit/launcher_cubit.dart';
import '../widgets/app_grid_item.dart';
import '../widgets/app_options_bottom_sheet.dart';
import '../widgets/search_bar.dart' as custom;
import '../widgets/auto_close_indicator.dart';

class LauncherPage extends StatefulWidget {
  final LauncherCubit cubit;

  const LauncherPage({
    super.key,
    required this.cubit,
  });

  @override
  State<LauncherPage> createState() => _LauncherPageState();
}

class _LauncherPageState extends State<LauncherPage> {
  @override
  void initState() {
    super.initState();
    widget.cubit.loadApps();
    widget.cubit.addListener(_onStateChanged);
  }

  @override
  void dispose() {
    widget.cubit.removeListener(_onStateChanged);
    super.dispose();
  }

  void _onStateChanged() {
    setState(() {});

    // Show error message if any
    if (widget.cubit.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(widget.cubit.errorMessage!)),
      );
      widget.cubit.clearError();
    }
  }

  void _showAppOptions(AppEntity app) {
    showModalBottomSheet(
      context: context,
      builder: (context) => AppOptionsBottomSheet(
        app: app,
        onOpen: () {
          Navigator.pop(context);
          widget.cubit.launchApp(app);
        },
        onAppInfo: () {
          Navigator.pop(context);
          widget.cubit.openAppSettings(app);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredApps = widget.cubit.filteredApps;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Search bar
            custom.SearchBar(
              searchQuery: widget.cubit.searchQuery,
              onChanged: (value) => widget.cubit.setSearchQuery(value),
              onClear: () => widget.cubit.setSearchQuery(''),
            ),

            // Apps grid
            Expanded(
              child: widget.cubit.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filteredApps.isEmpty
                      ? _buildEmptyState()
                      : RefreshIndicator(
                          onRefresh: () =>
                              widget.cubit.loadApps(forceRefresh: true),
                          child: GridView.builder(
                            padding: const EdgeInsets.all(16),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: AppConstants.gridCrossAxisCount,
                              crossAxisSpacing:
                                  AppConstants.gridCrossAxisSpacing,
                              mainAxisSpacing: AppConstants.gridMainAxisSpacing,
                              childAspectRatio:
                                  AppConstants.gridChildAspectRatio,
                            ),
                            itemCount: filteredApps.length,
                            itemBuilder: (context, index) {
                              final app = filteredApps[index];
                              return AppGridItem(
                                app: app,
                                onTap: () => widget.cubit.launchApp(app),
                                onLongPress: () => _showAppOptions(app),
                              );
                            },
                          ),
                        ),
            ),

            // Bottom info bar
            _buildBottomBar(filteredApps.length),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.apps,
            size: 64,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            widget.cubit.searchQuery.isEmpty
                ? 'No apps found'
                : 'No apps match your search',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          if (widget.cubit.searchQuery.isNotEmpty) ...[
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => widget.cubit.setSearchQuery(''),
              child: const Text('Clear search'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBottomBar(int appCount) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$appCount apps',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          Row(
            children: [
              // Auto-close indicator
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: AutoCloseIndicator(
                  isEnabled: widget.cubit.autoCloseEnabled,
                  onTap: () {
                    widget.cubit.toggleAutoClose();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          widget.cubit.autoCloseEnabled
                              ? 'Auto-close enabled (30s limit)'
                              : 'Auto-close disabled',
                        ),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ),
              // Cache indicator
              if (widget.cubit.isCacheValid)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Icon(
                    Icons.cloud_done,
                    size: 16,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () => widget.cubit.loadApps(forceRefresh: true),
                tooltip: 'Refresh apps',
              ),
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Auto-close: ${widget.cubit.autoCloseEnabled ? "ON" : "OFF"}\n'
                        'Time limit: 30 seconds\n'
                        'Tap timer icon to toggle',
                      ),
                      duration: const Duration(seconds: 3),
                    ),
                  );
                },
                tooltip: 'Settings',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

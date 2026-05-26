import 'package:dhyan/core/ads/admob_service.dart';
import 'package:dhyan/core/theme/app_theme.dart';
import 'package:dhyan/core/widgets/admob_banner_bar.dart';
import 'package:dhyan/core/widgets/exit_focus_dialog.dart';
import 'package:dhyan/features/activities/activities_screen.dart';
import 'package:dhyan/features/home/home_screen.dart';
import 'package:dhyan/features/progress/progress_screen.dart';
import 'package:dhyan/providers/app_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Bottom tabs so Activities are always visible — not buried in home.
class MainShellScreen extends ConsumerStatefulWidget {
  const MainShellScreen({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  ConsumerState<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends ConsumerState<MainShellScreen> {
  late int _index;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(stringsProvider);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final leave = await showExitFocusDialog(context, ref);
        if (leave && context.mounted) {
          await SystemNavigator.pop();
        }
      },
      child: Scaffold(
      backgroundColor: AppTheme.homeCanvas,
      body: IndexedStack(
        index: _index,
        children: const [
          HomeScreen(),
          ActivitiesScreen(),
          ProgressScreen(),
        ],
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (AdMobService.isSupported) const AdMobBannerBar(),
          NavigationBar(
            selectedIndex: _index,
            onDestinationSelected: (i) => setState(() => _index = i),
            height: 64,
            backgroundColor: AppTheme.deepNavy,
            surfaceTintColor: Colors.transparent,
            indicatorColor: AppTheme.surfaceElevated,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            destinations: [
              NavigationDestination(
                icon: const Icon(Icons.home_outlined),
                selectedIcon: const Icon(Icons.home),
                label: s.navHome,
              ),
              NavigationDestination(
                icon: const Icon(Icons.apps_outlined),
                selectedIcon: const Icon(Icons.apps),
                label: s.allActivities,
              ),
              NavigationDestination(
                icon: const Icon(Icons.insights_outlined),
                selectedIcon: const Icon(Icons.insights),
                label: s.progress,
              ),
            ],
          ),
        ],
      ),
    ),
    );
  }
}

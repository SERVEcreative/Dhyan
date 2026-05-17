import 'package:dhyan/data/models/skill_track.dart';
import 'package:dhyan/features/games/boredom_bench_screen.dart';
import 'package:dhyan/features/games/breath_anchor_screen.dart';
import 'package:dhyan/features/games/color_focus_screen.dart';
import 'package:dhyan/features/games/one_path_screen.dart';
import 'package:dhyan/features/games/delay_tap_screen.dart';
import 'package:dhyan/features/games/intent_lock_screen.dart';
import 'package:dhyan/features/games/still_point_screen.dart';
import 'package:dhyan/features/games/swipe_resist_screen.dart';
import 'package:dhyan/features/games/urge_surf_screen.dart';
import 'package:dhyan/features/activities/activities_screen.dart';
import 'package:dhyan/features/shell/main_shell_screen.dart';
import 'package:dhyan/features/onboarding/onboarding_screen.dart';
import 'package:dhyan/features/onboarding/profile_setup_screen.dart';
import 'package:dhyan/features/progress/progress_screen.dart';
import 'package:dhyan/domain/session_type_meta.dart';
import 'package:dhyan/features/session/session_summary_screen.dart';
import 'package:dhyan/features/session/session_support_screen.dart';
import 'package:dhyan/features/legal/privacy_policy_screen.dart';
import 'package:dhyan/features/settings/about_screen.dart';
import 'package:dhyan/features/session/warmup_screen.dart';
import 'package:dhyan/providers/app_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final _rootKey = GlobalKey<NavigatorState>();

SessionType? _sessionTypeFromExtra(Map<String, dynamic> extra) {
  final value = extra['sessionType'];
  return value is SessionType ? value : null;
}

final appRouterProvider = Provider<GoRouter>((ref) {
  final refresh = ValueNotifier<int>(0);
  ref.listen(userProgressProvider, (_, __) => refresh.value++);
  ref.onDispose(refresh.dispose);

  return GoRouter(
    navigatorKey: _rootKey,
    initialLocation: '/',
    refreshListenable: refresh,
    redirect: (context, state) {
      final path = state.uri.path;
      final progress = ref.read(userProgressProvider);

      return progress.when(
        loading: () => null,
        error: (_, __) => null,
        data: (p) {
          if (!p.onboardingComplete && path != '/onboarding') {
            return '/onboarding';
          }
          if (p.onboardingComplete &&
              !p.profileComplete &&
              path != '/profile-setup') {
            return '/profile-setup';
          }
          if (p.profileComplete &&
              (path == '/onboarding' || path == '/profile-setup')) {
            return '/';
          }
          return null;
        },
      );
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const MainShellScreen(),
      ),
      GoRoute(
        path: '/activities-tab',
        builder: (context, state) => const MainShellScreen(initialIndex: 1),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/profile-setup',
        builder: (context, state) => const ProfileSetupScreen(),
      ),
      GoRoute(
        path: '/activities',
        builder: (context, state) => const ActivitiesScreen(),
      ),
      GoRoute(
        path: '/progress',
        builder: (context, state) => const ProgressScreen(),
      ),
      GoRoute(
        path: '/privacy',
        builder: (context, state) => const PrivacyPolicyScreen(),
      ),
      GoRoute(
        path: '/about',
        builder: (context, state) => const AboutScreen(),
      ),
      GoRoute(
        path: '/urge',
        builder: (context, state) => const UrgeSurfScreen(),
      ),
      GoRoute(
        path: '/tool/swipe',
        builder: (context, state) => const SwipeResistScreen(standalone: true),
      ),
      GoRoute(
        path: '/tool/delay',
        builder: (context, state) => const DelayTapScreen(standalone: true),
      ),
      GoRoute(
        path: '/tool/intent',
        builder: (context, state) => const IntentLockScreen(standalone: true),
      ),
      GoRoute(
        path: '/tool/breath',
        builder: (context, state) => const BreathAnchorScreen(standalone: true),
      ),
      GoRoute(
        path: '/tool/still',
        builder: (context, state) => const StillPointScreen(standalone: true),
      ),
      GoRoute(
        path: '/tool/color',
        builder: (context, state) => const ColorFocusScreen(standalone: true),
      ),
      GoRoute(
        path: '/tool/boredom',
        builder: (context, state) => const BoredomBenchScreen(standalone: true),
      ),
      GoRoute(
        path: '/tool/path',
        builder: (context, state) => const OnePathScreen(standalone: true),
      ),
      GoRoute(
        path: '/session/summary',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          return SessionSummaryScreen(
            sessionType:
                extra['sessionType'] as SessionType? ?? SessionType.micro,
            stillnessSeconds: extra['stillnessSeconds'] as int? ?? 0,
            inhibitoryDelta: (extra['inhibitory'] as num?)?.toDouble() ?? 5,
            selectiveDelta: (extra['selective'] as num?)?.toDouble() ?? 0,
            sessionMinutes: extra['sessionMinutes'] as int? ?? 3,
            indexBefore: (extra['indexBefore'] as num?)?.toDouble() ?? 0,
          );
        },
      ),
      GoRoute(
        path: '/session/support',
        builder: (context, state) => const SessionSupportScreen(),
      ),
      GoRoute(
        path: '/session/:type',
        builder: (context, state) {
          final type = SessionTypeMeta.fromRoute(state.pathParameters['type']);
          if (type == null) {
            return const MainShellScreen();
          }
          return WarmupScreen(sessionType: type);
        },
      ),
      GoRoute(
        path: '/drill/breath',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          final sessionType = _sessionTypeFromExtra(extra);
          if (sessionType == null) return const MainShellScreen();
          return BreathAnchorScreen(
            sessionType: sessionType,
            drillIndex: extra['drillIndex'] as int? ?? 0,
            drills: extra['drills'] as List<DrillType>? ?? [],
          );
        },
      ),
      GoRoute(
        path: '/drill/still',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          final sessionType = _sessionTypeFromExtra(extra);
          if (sessionType == null) return const MainShellScreen();
          return StillPointScreen(
            sessionType: sessionType,
            drillIndex: extra['drillIndex'] as int? ?? 0,
            drills: extra['drills'] as List<DrillType>? ?? [],
          );
        },
      ),
      GoRoute(
        path: '/drill/color',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          final sessionType = _sessionTypeFromExtra(extra);
          if (sessionType == null) return const MainShellScreen();
          return ColorFocusScreen(
            sessionType: sessionType,
            drillIndex: extra['drillIndex'] as int? ?? 0,
            drills: extra['drills'] as List<DrillType>? ?? [],
          );
        },
      ),
      GoRoute(
        path: '/drill/boredom',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          final sessionType = _sessionTypeFromExtra(extra);
          if (sessionType == null) return const MainShellScreen();
          return BoredomBenchScreen(
            sessionType: sessionType,
            drillIndex: extra['drillIndex'] as int? ?? 0,
            drills: extra['drills'] as List<DrillType>? ?? [],
          );
        },
      ),
      GoRoute(
        path: '/drill/swipe',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          final sessionType = _sessionTypeFromExtra(extra);
          if (sessionType == null) return const MainShellScreen();
          return SwipeResistScreen(
            sessionType: sessionType,
            drillIndex: extra['drillIndex'] as int? ?? 0,
            drills: extra['drills'] as List<DrillType>? ?? [],
          );
        },
      ),
      GoRoute(
        path: '/drill/delay',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          final sessionType = _sessionTypeFromExtra(extra);
          if (sessionType == null) return const MainShellScreen();
          return DelayTapScreen(
            sessionType: sessionType,
            drillIndex: extra['drillIndex'] as int? ?? 0,
            drills: extra['drills'] as List<DrillType>? ?? [],
          );
        },
      ),
      GoRoute(
        path: '/drill/intent',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          final sessionType = _sessionTypeFromExtra(extra);
          if (sessionType == null) return const MainShellScreen();
          return IntentLockScreen(
            sessionType: sessionType,
            drillIndex: extra['drillIndex'] as int? ?? 0,
            drills: extra['drills'] as List<DrillType>? ?? [],
          );
        },
      ),
      GoRoute(
        path: '/drill/path',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          final sessionType = _sessionTypeFromExtra(extra);
          if (sessionType == null) return const MainShellScreen();
          return OnePathScreen(
            sessionType: sessionType,
            drillIndex: extra['drillIndex'] as int? ?? 0,
            drills: extra['drills'] as List<DrillType>? ?? [],
          );
        },
      ),
    ],
  );
});

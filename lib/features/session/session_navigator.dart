import 'package:dhyan/data/models/skill_track.dart';
import 'package:dhyan/providers/session_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SessionNavigator {
  static void startDrill(
    BuildContext context,
    WidgetRef ref, {
    required SessionType sessionType,
    required List<DrillType> drills,
    required int drillIndex,
  }) {
    if (drillIndex >= drills.length) {
      _goToSummary(context, ref, sessionType: sessionType);
      return;
    }

    final drill = drills[drillIndex];
    final extra = {
      'sessionType': sessionType,
      'drillIndex': drillIndex,
      'drills': drills,
    };

    switch (drill) {
      case DrillType.breathAnchor:
        context.push('/drill/breath', extra: extra);
      case DrillType.stillPoint:
        context.push('/drill/still', extra: extra);
      case DrillType.onePath:
        context.push('/drill/path', extra: extra);
      case DrillType.colorFocus:
        context.push('/drill/color', extra: extra);
      case DrillType.boredomBench:
        context.push('/drill/boredom', extra: extra);
      case DrillType.swipeResist:
        context.push('/drill/swipe', extra: extra);
      case DrillType.delayTap:
        context.push('/drill/delay', extra: extra);
      case DrillType.intentLock:
        context.push('/drill/intent', extra: extra);
      case DrillType.urgeSurf:
        context.push('/urge');
    }
  }

  static void nextDrill(
    BuildContext context,
    WidgetRef ref, {
    required SessionType sessionType,
    required List<DrillType> drills,
    required int currentIndex,
    int? stillnessSeconds,
    double inhibitoryDelta = 0,
    double selectiveDelta = 0,
  }) {
    if (stillnessSeconds != null) {
      final current = ref.read(sessionStillnessProvider);
      if (stillnessSeconds > current) {
        ref.read(sessionStillnessProvider.notifier).state = stillnessSeconds;
      }
    }
    if (inhibitoryDelta > 0) {
      ref.read(sessionInhibitoryProvider.notifier).state +=
          inhibitoryDelta;
    }
    if (selectiveDelta > 0) {
      ref.read(sessionSelectiveProvider.notifier).state += selectiveDelta;
    }
    startDrill(
      context,
      ref,
      sessionType: sessionType,
      drills: drills,
      drillIndex: currentIndex + 1,
    );
  }

  /// Must use exact path — `/session/summary` is NOT `/session/:type`.
  static void _goToSummary(
    BuildContext context,
    WidgetRef ref, {
    required SessionType sessionType,
  }) {
    context.pushReplacement(
      '/session/summary',
      extra: {
        'sessionType': sessionType,
        'stillnessSeconds': ref.read(sessionStillnessProvider),
        'inhibitory': ref.read(sessionInhibitoryProvider),
        'selective': ref.read(sessionSelectiveProvider),
        'sessionMinutes': ref.read(sessionMinutesProvider),
        'indexBefore': ref.read(sessionIndexBeforeProvider),
      },
    );
  }
}

import 'package:dhyan/core/l10n/app_strings.dart';
import 'package:dhyan/data/models/skill_track.dart';
import 'package:dhyan/domain/session_type_meta.dart';
import 'package:flutter/material.dart';

enum ActivityCategory { antiReel, focus, session }

class ActivityDef {
  const ActivityDef({
    required this.id,
    required this.category,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.route,
    this.durationLabel,
  });

  final String id;
  final ActivityCategory category;
  final String Function(AppStrings s) title;
  final String Function(AppStrings s) subtitle;
  final IconData icon;
  final String route;
  final String Function(AppStrings s)? durationLabel;
}

abstract final class ActivityCatalog {
  static List<ActivityDef> all() => [
        ActivityDef(
          id: 'swipe',
          category: ActivityCategory.antiReel,
          title: (s) => s.swipeResist,
          subtitle: (s) => s.swipeResistHint,
          icon: Icons.swipe_vertical,
          route: '/tool/swipe',
          durationLabel: (s) => s.activityDuration60,
        ),
        ActivityDef(
          id: 'delay',
          category: ActivityCategory.antiReel,
          title: (s) => s.delayTap,
          subtitle: (s) => s.delayTapWait,
          icon: Icons.touch_app_outlined,
          route: '/tool/delay',
          durationLabel: (s) => s.activityDuration10,
        ),
        ActivityDef(
          id: 'urge',
          category: ActivityCategory.antiReel,
          title: (s) => s.urgeSurf,
          subtitle: (s) => s.urgeSurfHint,
          icon: Icons.waves,
          route: '/urge',
          durationLabel: (s) => s.activityDuration90,
        ),
        ActivityDef(
          id: 'intent',
          category: ActivityCategory.antiReel,
          title: (s) => s.intentLock,
          subtitle: (s) => s.intentLockHint,
          icon: Icons.lock_outline,
          route: '/tool/intent',
          durationLabel: (s) => s.activityDurationRead3,
        ),
        ActivityDef(
          id: 'breath',
          category: ActivityCategory.focus,
          title: (s) => s.breathAnchor,
          subtitle: (s) => s.activityBreathDesc,
          icon: Icons.air,
          route: '/tool/breath',
          durationLabel: (s) => s.activityDuration45,
        ),
        ActivityDef(
          id: 'color',
          category: ActivityCategory.focus,
          title: (s) => s.colorFocus,
          subtitle: (s) => s.colorFocusHint,
          icon: Icons.lens_blur,
          route: '/tool/color',
          durationLabel: (s) => s.activityDuration50,
        ),
        ActivityDef(
          id: 'still',
          category: ActivityCategory.focus,
          title: (s) => s.stillPoint,
          subtitle: (s) => s.holdStill,
          icon: Icons.circle_outlined,
          route: '/tool/still',
          durationLabel: (s) => s.activityDurationVaries,
        ),
        ActivityDef(
          id: 'boredom',
          category: ActivityCategory.focus,
          title: (s) => s.boredomBench,
          subtitle: (s) => s.boredomHint,
          icon: Icons.hourglass_empty,
          route: '/tool/boredom',
          durationLabel: (s) => s.activityDuration45to90,
        ),
        ActivityDef(
          id: 'path',
          category: ActivityCategory.focus,
          title: (s) => s.onePath,
          subtitle: (s) => s.wrongTurnWait,
          icon: Icons.route,
          route: '/tool/path',
          durationLabel: (s) => s.activityDuration3min,
        ),
        ...sessionDisplayOrder.map(
          (type) => ActivityDef(
            id: type.name,
            category: ActivityCategory.session,
            title: (s) => s.sessionTitle(type),
            subtitle: (s) => s.sessionSubtitle(type),
            icon: type == SessionType.focus7
                ? Icons.bolt_outlined
                : type == SessionType.deep || type == SessionType.extended
                    ? Icons.self_improvement
                    : Icons.play_circle_outline,
            route: type.routePath,
            durationLabel: (s) => s.minutesUnit(type.durationMinutes),
          ),
        ),
      ];

  static String categoryLabel(ActivityCategory c, AppStrings s) =>
      switch (c) {
        ActivityCategory.antiReel => s.categoryAntiReel,
        ActivityCategory.focus => s.categoryFocus,
        ActivityCategory.session => s.categorySessions,
      };
}

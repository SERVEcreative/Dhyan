import 'package:dhyan/core/l10n/app_strings.dart';
import 'package:dhyan/data/models/skill_track.dart';
import 'package:dhyan/data/models/user_progress.dart';
import 'package:dhyan/domain/session_type_meta.dart';

/// Session limits and drill chains per type.
class SessionPolicy {
  static const maxFocus7PerDay = 8;

  static bool canStart(UserProgress p, SessionType type) =>
      blockReason(p, type) == null;

  static bool canStartMicro(UserProgress p) => canStart(p, SessionType.micro);

  static bool canStartDeep(UserProgress p) => canStart(p, SessionType.deep);

  static String? blockReason(UserProgress p, SessionType type) {
    if (type.usesMicroDailyLimit &&
        p.microSessionsToday >= p.track.maxMicroPerDay) {
      return 'micro_limit';
    }
    if (type.usesDeepDailyLimit) {
      if (p.track.maxDeepPerDay == 0) return 'deep_locked_track';
      if (p.deepSessionsToday >= p.track.maxDeepPerDay) {
        return 'deep_limit';
      }
    }
    if (type == SessionType.focus7 &&
        p.focus7SessionsToday >= maxFocus7PerDay) {
      return 'focus7_limit';
    }
    return null;
  }

  static String blockMessage(AppStrings s, String? code) {
    return switch (code) {
      'micro_limit' => s.sessionMicroLimitReached,
      'deep_locked_track' => s.sessionDeepLockedTrack,
      'deep_limit' => s.sessionDeepLimitReached,
      'focus7_limit' => s.sessionFocus7LimitReached,
      _ => s.sessionLimitReached,
    };
  }

  static List<DrillType> drillsForSession(
    SessionType type,
    SkillTrack track,
  ) {
    if (type == SessionType.focus7) {
      return const [
        DrillType.breathAnchor,
        DrillType.colorFocus,
        DrillType.stillPoint,
      ];
    }
    if (type == SessionType.quick) {
      return switch (track) {
        SkillTrack.recovery => [
            DrillType.breathAnchor,
            DrillType.swipeResist,
          ],
        SkillTrack.builder => [
            DrillType.delayTap,
            DrillType.stillPoint,
          ],
        SkillTrack.master => [
            DrillType.colorFocus,
            DrillType.intentLock,
          ],
      };
    }
    if (type == SessionType.calm) {
      return switch (track) {
        SkillTrack.recovery => [
            DrillType.breathAnchor,
            DrillType.boredomBench,
            DrillType.stillPoint,
          ],
        SkillTrack.builder => [
            DrillType.colorFocus,
            DrillType.delayTap,
            DrillType.stillPoint,
          ],
        SkillTrack.master => [
            DrillType.intentLock,
            DrillType.colorFocus,
            DrillType.boredomBench,
          ],
      };
    }
    if (type == SessionType.extended) {
      return switch (track) {
        SkillTrack.recovery => [
            DrillType.swipeResist,
            DrillType.delayTap,
            DrillType.breathAnchor,
            DrillType.stillPoint,
          ],
        SkillTrack.builder => [
            DrillType.intentLock,
            DrillType.swipeResist,
            DrillType.boredomBench,
            DrillType.stillPoint,
            DrillType.colorFocus,
          ],
        SkillTrack.master => [
            DrillType.intentLock,
            DrillType.delayTap,
            DrillType.swipeResist,
            DrillType.boredomBench,
            DrillType.onePath,
          ],
      };
    }
    if (type == SessionType.micro) {
      return switch (track) {
        SkillTrack.recovery => [
            DrillType.swipeResist,
            DrillType.breathAnchor,
            DrillType.stillPoint,
          ],
        SkillTrack.builder => [
            DrillType.delayTap,
            DrillType.swipeResist,
            DrillType.boredomBench,
          ],
        SkillTrack.master => [
            DrillType.intentLock,
            DrillType.delayTap,
            DrillType.stillPoint,
          ],
      };
    }
    return switch (track) {
      SkillTrack.recovery => [
          DrillType.swipeResist,
          DrillType.delayTap,
          DrillType.stillPoint,
        ],
      SkillTrack.builder => [
          DrillType.intentLock,
          DrillType.swipeResist,
          DrillType.boredomBench,
          DrillType.stillPoint,
        ],
      SkillTrack.master => [
          DrillType.intentLock,
          DrillType.delayTap,
          DrillType.swipeResist,
          DrillType.boredomBench,
        ],
    };
  }
}

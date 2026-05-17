import 'package:dhyan/data/models/skill_track.dart';
import 'package:dhyan/data/models/user_profile.dart';
import 'package:dhyan/domain/session_type_meta.dart';

/// Transparent wellness estimates — not clinical claims.
class FocusBenefitEstimate {
  const FocusBenefitEstimate({
    required this.sessionMinutes,
    required this.attentionIndexGain,
    required this.deepReadingMinutesEquiv,
    required this.impulseControlPercent,
    required this.weeklyProjectionIndex,
    required this.insightEn,
    required this.insightHi,
  });

  final int sessionMinutes;
  final double attentionIndexGain;
  final int deepReadingMinutesEquiv;
  final int impulseControlPercent;
  final double weeklyProjectionIndex;
  final String insightEn;
  final String insightHi;
}

abstract final class BenefitEstimator {
  /// ~0.9 index points per focused minute (capped), scaled by track.
  static FocusBenefitEstimate forSession({
    required int sessionMinutes,
    required double indexBefore,
    required double indexAfter,
    required SkillTrack track,
    required FocusGoal goal,
    required int stillnessSeconds,
  }) {
    final rawGain = (indexAfter - indexBefore).clamp(0.0, 15.0);
    final trackMul = switch (track) {
      SkillTrack.recovery => 1.0,
      SkillTrack.builder => 1.15,
      SkillTrack.master => 1.25,
    };
    final goalMul = switch (goal) {
      FocusGoal.reduceReels => 1.1,
      FocusGoal.study => 1.05,
      _ => 1.0,
    };
    final minutes = sessionMinutes.clamp(1, 30);
    final modeledGain =
        (rawGain > 0 ? rawGain : minutes * 0.85 * trackMul * goalMul)
            .clamp(0.5, 12.0);

    final readingEquiv =
        (minutes * 1.3 + stillnessSeconds / 45).round().clamp(1, 45);
    final impulse = (minutes * 2.2 + stillnessSeconds / 30)
        .round()
        .clamp(2, 28);
    final weeklyProj =
        (indexAfter + modeledGain * 5).clamp(0.0, 100.0).toDouble();

    final insightEn =
        'Based on $minutes min practice: ~${modeledGain.toStringAsFixed(1)} Attention Index gain, '
        'similar to ~$readingEquiv min of calm reading focus.';
    final insightHi =
        '$minutes min abhyas se: ~${modeledGain.toStringAsFixed(1)} Attention Index badhaav, '
        '~$readingEquiv min shaant reading jaisa focus estimate.';

    return FocusBenefitEstimate(
      sessionMinutes: minutes,
      attentionIndexGain: modeledGain,
      deepReadingMinutesEquiv: readingEquiv,
      impulseControlPercent: impulse,
      weeklyProjectionIndex: weeklyProj,
      insightEn: insightEn,
      insightHi: insightHi,
    );
  }

  static int defaultSessionMinutes(SessionType type) => type.durationMinutes;
}

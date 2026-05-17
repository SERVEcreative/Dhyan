enum SkillTrack { recovery, builder, master }

enum SessionType { micro, quick, focus7, calm, deep, extended }

enum DrillType {
  breathAnchor,
  stillPoint,
  onePath,
  colorFocus,
  boredomBench,
  swipeResist,
  delayTap,
  intentLock,
  urgeSurf,
}

extension SkillTrackX on SkillTrack {
  int get stillTargetSeconds => switch (this) {
        SkillTrack.recovery => 30,
        SkillTrack.builder => 90,
        SkillTrack.master => 180,
      };

  int get maxMicroPerDay => switch (this) {
        SkillTrack.recovery => 3,
        SkillTrack.builder => 3,
        SkillTrack.master => 3,
      };

  int get maxDeepPerDay => switch (this) {
        SkillTrack.recovery => 0,
        SkillTrack.builder => 1,
        SkillTrack.master => 1,
      };
}

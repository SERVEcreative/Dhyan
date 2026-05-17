/// User context for credible, personalized estimates.
enum AgeRange { under18, age18to24, age25to34, age35plus }

enum FocusGoal { study, work, reduceReels, generalFocus }

enum PracticeSlot { morning, afternoon, evening }

extension AgeRangeX on AgeRange {
  String labelEn() => switch (this) {
        AgeRange.under18 => 'Under 18',
        AgeRange.age18to24 => '18–24',
        AgeRange.age25to34 => '25–34',
        AgeRange.age35plus => '35+',
      };

  String labelHi() => switch (this) {
        AgeRange.under18 => '18 se kam',
        AgeRange.age18to24 => '18–24',
        AgeRange.age25to34 => '25–34',
        AgeRange.age35plus => '35+',
      };
}

extension FocusGoalX on FocusGoal {
  String labelEn() => switch (this) {
        FocusGoal.study => 'Studies / exams',
        FocusGoal.work => 'Work productivity',
        FocusGoal.reduceReels => 'Reduce Reels/Shorts',
        FocusGoal.generalFocus => 'General focus',
      };

  String labelHi() => switch (this) {
        FocusGoal.study => 'Padhai / exams',
        FocusGoal.work => 'Kaam / productivity',
        FocusGoal.reduceReels => 'Reels/Shorts kam',
        FocusGoal.generalFocus => 'General focus',
      };
}

extension PracticeSlotX on PracticeSlot {
  String labelEn() => switch (this) {
        PracticeSlot.morning => 'Morning',
        PracticeSlot.afternoon => 'Afternoon',
        PracticeSlot.evening => 'Evening',
      };

  String labelHi() => switch (this) {
        PracticeSlot.morning => 'Subah',
        PracticeSlot.afternoon => 'Dopahar',
        PracticeSlot.evening => 'Shaam',
      };
}

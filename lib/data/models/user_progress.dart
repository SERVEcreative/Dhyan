import 'package:dhyan/data/models/skill_track.dart';
import 'package:dhyan/data/models/user_profile.dart';

class UserProgress {
  const UserProgress({
    this.onboardingComplete = false,
    this.profileComplete = false,
    this.track = SkillTrack.recovery,
    this.localeCode = 'en',
    this.displayName = '',
    this.ageRange = AgeRange.age18to24,
    this.focusGoal = FocusGoal.reduceReels,
    this.practiceSlot = PracticeSlot.evening,
    this.attentionIndex = 0,
    this.baselineAttentionIndex = 0,
    this.maxStillnessSeconds = 0,
    this.distractionResistRate = 0,
    this.inhibitoryScore = 0,
    this.cognitiveScore = 0,
    this.urgeResistCount = 0,
    this.streakDays = 0,
    this.streakPaused = false,
    this.lastSessionDate,
    this.microSessionsToday = 0,
    this.deepSessionsToday = 0,
    this.focus7SessionsToday = 0,
    this.totalFocusMinutes = 0,
    this.history = const [],
    this.scrollHoursPerDay = 2,
    this.switchAppsOften = true,
    this.phoneDiscomfort = 4,
    this.reelsLoggedMinutes = 0,
    this.reelsLoggedDate,
    this.swipeResistCount = 0,
  });

  final bool onboardingComplete;
  final bool profileComplete;
  final SkillTrack track;
  final String localeCode;
  final String displayName;
  final AgeRange ageRange;
  final FocusGoal focusGoal;
  final PracticeSlot practiceSlot;
  final double attentionIndex;
  final double baselineAttentionIndex;
  final int maxStillnessSeconds;
  final double distractionResistRate;
  final double inhibitoryScore;
  final double cognitiveScore;
  final int urgeResistCount;
  final int streakDays;
  final bool streakPaused;
  final String? lastSessionDate;
  final int microSessionsToday;
  final int deepSessionsToday;
  final int focus7SessionsToday;
  final int totalFocusMinutes;
  final List<SessionRecord> history;
  final int scrollHoursPerDay;
  final bool switchAppsOften;
  final int phoneDiscomfort;
  final int reelsLoggedMinutes;
  final String? reelsLoggedDate;
  final int swipeResistCount;

  String get greetingName =>
      displayName.trim().isEmpty ? 'Friend' : displayName.trim();

  UserProgress copyWith({
    bool? onboardingComplete,
    bool? profileComplete,
    SkillTrack? track,
    String? localeCode,
    String? displayName,
    AgeRange? ageRange,
    FocusGoal? focusGoal,
    PracticeSlot? practiceSlot,
    double? attentionIndex,
    double? baselineAttentionIndex,
    int? maxStillnessSeconds,
    double? distractionResistRate,
    double? inhibitoryScore,
    double? cognitiveScore,
    int? urgeResistCount,
    int? streakDays,
    bool? streakPaused,
    String? lastSessionDate,
    int? microSessionsToday,
    int? deepSessionsToday,
    int? focus7SessionsToday,
    int? totalFocusMinutes,
    List<SessionRecord>? history,
    int? scrollHoursPerDay,
    bool? switchAppsOften,
    int? phoneDiscomfort,
    int? reelsLoggedMinutes,
    String? reelsLoggedDate,
    int? swipeResistCount,
  }) {
    return UserProgress(
      onboardingComplete: onboardingComplete ?? this.onboardingComplete,
      profileComplete: profileComplete ?? this.profileComplete,
      track: track ?? this.track,
      localeCode: localeCode ?? this.localeCode,
      displayName: displayName ?? this.displayName,
      ageRange: ageRange ?? this.ageRange,
      focusGoal: focusGoal ?? this.focusGoal,
      practiceSlot: practiceSlot ?? this.practiceSlot,
      attentionIndex: attentionIndex ?? this.attentionIndex,
      baselineAttentionIndex:
          baselineAttentionIndex ?? this.baselineAttentionIndex,
      maxStillnessSeconds: maxStillnessSeconds ?? this.maxStillnessSeconds,
      distractionResistRate:
          distractionResistRate ?? this.distractionResistRate,
      inhibitoryScore: inhibitoryScore ?? this.inhibitoryScore,
      cognitiveScore: cognitiveScore ?? this.cognitiveScore,
      urgeResistCount: urgeResistCount ?? this.urgeResistCount,
      streakDays: streakDays ?? this.streakDays,
      streakPaused: streakPaused ?? this.streakPaused,
      lastSessionDate: lastSessionDate ?? this.lastSessionDate,
      microSessionsToday: microSessionsToday ?? this.microSessionsToday,
      deepSessionsToday: deepSessionsToday ?? this.deepSessionsToday,
      focus7SessionsToday: focus7SessionsToday ?? this.focus7SessionsToday,
      totalFocusMinutes: totalFocusMinutes ?? this.totalFocusMinutes,
      history: history ?? this.history,
      scrollHoursPerDay: scrollHoursPerDay ?? this.scrollHoursPerDay,
      switchAppsOften: switchAppsOften ?? this.switchAppsOften,
      phoneDiscomfort: phoneDiscomfort ?? this.phoneDiscomfort,
      reelsLoggedMinutes: reelsLoggedMinutes ?? this.reelsLoggedMinutes,
      reelsLoggedDate: reelsLoggedDate ?? this.reelsLoggedDate,
      swipeResistCount: swipeResistCount ?? this.swipeResistCount,
    );
  }

  Map<String, dynamic> toMap() => {
        'onboardingComplete': onboardingComplete,
        'profileComplete': profileComplete,
        'track': track.index,
        'localeCode': localeCode,
        'displayName': displayName,
        'ageRange': ageRange.index,
        'focusGoal': focusGoal.index,
        'practiceSlot': practiceSlot.index,
        'attentionIndex': attentionIndex,
        'baselineAttentionIndex': baselineAttentionIndex,
        'maxStillnessSeconds': maxStillnessSeconds,
        'distractionResistRate': distractionResistRate,
        'inhibitoryScore': inhibitoryScore,
        'cognitiveScore': cognitiveScore,
        'urgeResistCount': urgeResistCount,
        'streakDays': streakDays,
        'streakPaused': streakPaused,
        'lastSessionDate': lastSessionDate,
        'microSessionsToday': microSessionsToday,
        'deepSessionsToday': deepSessionsToday,
        'focus7SessionsToday': focus7SessionsToday,
        'totalFocusMinutes': totalFocusMinutes,
        'history': history.map((e) => e.toMap()).toList(),
        'scrollHoursPerDay': scrollHoursPerDay,
        'switchAppsOften': switchAppsOften,
        'phoneDiscomfort': phoneDiscomfort,
        'reelsLoggedMinutes': reelsLoggedMinutes,
        'reelsLoggedDate': reelsLoggedDate,
        'swipeResistCount': swipeResistCount,
      };

  factory UserProgress.fromMap(Map<dynamic, dynamic> map) {
    final rawHistory = map['history'] as List<dynamic>? ?? [];
    return UserProgress(
      onboardingComplete: _readBool(map['onboardingComplete']),
      profileComplete: _readBool(map['profileComplete']),
      track: SkillTrack.values[(map['track'] as num?)?.toInt() ?? 0],
      localeCode: map['localeCode'] as String? ?? 'en',
      displayName: map['displayName'] as String? ?? '',
      ageRange: AgeRange.values[(map['ageRange'] as num?)?.toInt() ?? 1],
      focusGoal: FocusGoal.values[(map['focusGoal'] as num?)?.toInt() ?? 2],
      practiceSlot:
          PracticeSlot.values[(map['practiceSlot'] as num?)?.toInt() ?? 2],
      attentionIndex: (map['attentionIndex'] as num?)?.toDouble() ?? 0,
      baselineAttentionIndex:
          (map['baselineAttentionIndex'] as num?)?.toDouble() ?? 0,
      maxStillnessSeconds: (map['maxStillnessSeconds'] as num?)?.toInt() ?? 0,
      distractionResistRate:
          (map['distractionResistRate'] as num?)?.toDouble() ?? 0,
      inhibitoryScore: (map['inhibitoryScore'] as num?)?.toDouble() ?? 0,
      cognitiveScore: (map['cognitiveScore'] as num?)?.toDouble() ?? 0,
      urgeResistCount: (map['urgeResistCount'] as num?)?.toInt() ?? 0,
      streakDays: (map['streakDays'] as num?)?.toInt() ?? 0,
      streakPaused: _readBool(map['streakPaused']),
      lastSessionDate: map['lastSessionDate'] as String?,
      microSessionsToday: (map['microSessionsToday'] as num?)?.toInt() ?? 0,
      deepSessionsToday: (map['deepSessionsToday'] as num?)?.toInt() ?? 0,
      focus7SessionsToday: (map['focus7SessionsToday'] as num?)?.toInt() ?? 0,
      totalFocusMinutes: (map['totalFocusMinutes'] as num?)?.toInt() ?? 0,
      history: rawHistory
          .map((e) => SessionRecord.fromMap(e as Map<dynamic, dynamic>))
          .toList(),
      scrollHoursPerDay: (map['scrollHoursPerDay'] as num?)?.toInt() ?? 2,
      switchAppsOften: _readBool(map['switchAppsOften'], defaultValue: true),
      phoneDiscomfort: (map['phoneDiscomfort'] as num?)?.toInt() ?? 4,
      reelsLoggedMinutes: (map['reelsLoggedMinutes'] as num?)?.toInt() ?? 0,
      reelsLoggedDate: map['reelsLoggedDate'] as String?,
      swipeResistCount: (map['swipeResistCount'] as num?)?.toInt() ?? 0,
    );
  }
}

bool _readBool(dynamic value, {bool defaultValue = false}) {
  if (value is bool) return value;
  if (value is num) return value != 0;
  if (value is String) return value.toLowerCase() == 'true';
  return defaultValue;
}

class SessionRecord {
  const SessionRecord({
    required this.date,
    required this.type,
    required this.attentionIndex,
    required this.stillnessSeconds,
    this.durationMinutes = 3,
  });

  final String date;
  final String type;
  final double attentionIndex;
  final int stillnessSeconds;
  final int durationMinutes;

  Map<String, dynamic> toMap() => {
        'date': date,
        'type': type,
        'attentionIndex': attentionIndex,
        'stillnessSeconds': stillnessSeconds,
        'durationMinutes': durationMinutes,
      };

  factory SessionRecord.fromMap(Map<dynamic, dynamic> map) => SessionRecord(
        date: map['date'] as String? ?? '',
        type: map['type'] as String? ?? 'micro',
        attentionIndex: (map['attentionIndex'] as num?)?.toDouble() ?? 0,
        stillnessSeconds: (map['stillnessSeconds'] as num?)?.toInt() ?? 0,
        durationMinutes: (map['durationMinutes'] as num?)?.toInt() ?? 3,
      );
}

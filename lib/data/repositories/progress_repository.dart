import 'package:dhyan/data/models/skill_track.dart';
import 'package:dhyan/data/models/user_profile.dart';
import 'package:dhyan/data/models/user_progress.dart';
import 'package:dhyan/domain/benefit_estimator.dart';
import 'package:dhyan/domain/session_type_meta.dart';
import 'package:dhyan/domain/attention_index.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ProgressRepository {
  static const _boxName = 'dhyan_progress';
  static const _key = 'user';

  Box<dynamic>? _box;

  Future<void> ensureInitialized() async {
    if (_box != null && _box!.isOpen) return;
    await Hive.initFlutter();
    _box = await Hive.openBox<dynamic>(_boxName);
  }

  Future<void> init() => ensureInitialized();

  Future<UserProgress> load() async {
    await ensureInitialized();
    final raw = _box?.get(_key);
    if (raw is Map) {
      var p = UserProgress.fromMap(Map<dynamic, dynamic>.from(raw));
      // Old installs: onboarding done before profile screen existed.
      if (p.onboardingComplete && !p.profileComplete) {
        p = p.copyWith(profileComplete: true);
        await save(p);
      }
      return p;
    }
    return const UserProgress();
  }

  Future<void> save(UserProgress progress) async {
    await ensureInitialized();
    final map = Map<String, dynamic>.from(progress.toMap());
    await _box?.put(_key, map);
    await _box?.flush();
  }

  Future<UserProgress> resetDailyIfNewDay() async {
    var p = await load();
    final today = _todayKey();
    if (p.lastSessionDate != null && p.lastSessionDate != today) {
      p = p.copyWith(
        microSessionsToday: 0,
        deepSessionsToday: 0,
        focus7SessionsToday: 0,
      );
      await save(p);
    }
    return p;
  }

  Future<UserProgress> completeOnboarding({
    required int scrollHours,
    required bool switchOften,
    required int discomfort,
    required String localeCode,
  }) async {
    await ensureInitialized();

    SkillTrack track;
    if (scrollHours >= 3 || (switchOften && discomfort >= 4)) {
      track = SkillTrack.recovery;
    } else if (scrollHours >= 1 || switchOften) {
      track = SkillTrack.builder;
    } else {
      track = SkillTrack.master;
    }

    final p = (await load()).copyWith(
      onboardingComplete: true,
      track: track,
      scrollHoursPerDay: scrollHours,
      switchAppsOften: switchOften,
      phoneDiscomfort: discomfort,
      localeCode: localeCode,
    );
    await save(p);
    return p;
  }

  Future<UserProgress> saveProfile({
    required String displayName,
    required AgeRange ageRange,
    required FocusGoal focusGoal,
    required PracticeSlot practiceSlot,
  }) async {
    await ensureInitialized();
    final current = await load();
    final p = current.copyWith(
      profileComplete: true,
      displayName: displayName.trim(),
      ageRange: ageRange,
      focusGoal: focusGoal,
      practiceSlot: practiceSlot,
      baselineAttentionIndex: current.attentionIndex,
    );
    await save(p);
    return p;
  }

  Future<UserProgress> recordSession({
    required SessionType type,
    required int stillnessSeconds,
    required double inhibitoryDelta,
    required double selectiveDelta,
    int? durationMinutes,
    bool urgeCompleted = false,
  }) async {
    var p = await resetDailyIfNewDay();
    final today = _todayKey();
    final minutes =
        durationMinutes ?? BenefitEstimator.defaultSessionMinutes(type);

    final newStill = stillnessSeconds > p.maxStillnessSeconds
        ? stillnessSeconds
        : p.maxStillnessSeconds;
    final inhibitory = (p.inhibitoryScore + inhibitoryDelta).clamp(0.0, 100.0);
    final selective =
        (p.distractionResistRate + selectiveDelta).clamp(0.0, 100.0);

    final index = AttentionIndexCalculator.compute(
      maxStillnessSeconds: newStill,
      distractionResistRate: selective,
      inhibitoryScore: inhibitory,
      cognitiveScore: p.cognitiveScore,
    );

    var streak = p.streakDays;
    var paused = p.streakPaused;
    if (p.lastSessionDate != today) {
      if (p.lastSessionDate == _yesterdayKey()) {
        streak += 1;
        paused = false;
      } else if (p.lastSessionDate != null) {
        paused = true;
      } else {
        streak = 1;
      }
    }

    final record = SessionRecord(
      date: today,
      type: type.name,
      attentionIndex: index,
      stillnessSeconds: stillnessSeconds,
      durationMinutes: minutes,
    );
    final history = [...p.history, record].take(30).toList();

    p = p.copyWith(
      maxStillnessSeconds: newStill,
      inhibitoryScore: inhibitory,
      distractionResistRate: selective,
      attentionIndex: index,
      urgeResistCount: urgeCompleted ? p.urgeResistCount + 1 : p.urgeResistCount,
      streakDays: streak,
      streakPaused: paused,
      lastSessionDate: today,
      microSessionsToday: type.usesMicroDailyLimit
          ? p.microSessionsToday + 1
          : p.microSessionsToday,
      deepSessionsToday: type.usesDeepDailyLimit
          ? p.deepSessionsToday + 1
          : p.deepSessionsToday,
      focus7SessionsToday: type == SessionType.focus7
          ? p.focus7SessionsToday + 1
          : p.focus7SessionsToday,
      totalFocusMinutes: p.totalFocusMinutes + minutes,
      history: history,
    );
    await save(p);
    return p;
  }

  Future<UserProgress> logReelsMinutes(int minutes) async {
    await ensureInitialized();
    final p = (await load()).copyWith(
      reelsLoggedMinutes: minutes,
      reelsLoggedDate: _todayKey(),
    );
    await save(p);
    return p;
  }

  Future<UserProgress> recordQuickTool({
    required String tool,
    required double inhibitoryDelta,
    required double selectiveDelta,
  }) async {
    var p = await load();
    final inhibitory = (p.inhibitoryScore + inhibitoryDelta).clamp(0.0, 100.0);
    final selective =
        (p.distractionResistRate + selectiveDelta).clamp(0.0, 100.0);
    final index = AttentionIndexCalculator.compute(
      maxStillnessSeconds: p.maxStillnessSeconds,
      distractionResistRate: selective,
      inhibitoryScore: inhibitory,
      cognitiveScore: p.cognitiveScore,
    );
    var swipeCount = p.swipeResistCount;
    if (tool == 'swipeResist') swipeCount += 1;

    p = p.copyWith(
      inhibitoryScore: inhibitory,
      distractionResistRate: selective,
      attentionIndex: index,
      swipeResistCount: swipeCount,
      totalFocusMinutes: p.totalFocusMinutes + 1,
    );
    await save(p);
    return p;
  }

  Future<UserProgress> setLocale(String code) async {
    final p = (await load()).copyWith(localeCode: code);
    await save(p);
    return p;
  }

  String _todayKey() {
    final n = DateTime.now();
    return '${n.year}-${n.month.toString().padLeft(2, '0')}-${n.day.toString().padLeft(2, '0')}';
  }

  String _yesterdayKey() {
    final n = DateTime.now().subtract(const Duration(days: 1));
    return '${n.year}-${n.month.toString().padLeft(2, '0')}-${n.day.toString().padLeft(2, '0')}';
  }
}

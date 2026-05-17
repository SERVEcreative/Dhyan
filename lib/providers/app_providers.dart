import 'package:dhyan/core/l10n/app_strings.dart';
import 'package:dhyan/data/models/skill_track.dart';
import 'package:dhyan/data/models/user_profile.dart';
import 'package:dhyan/data/models/user_progress.dart';
import 'package:dhyan/data/repositories/progress_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final progressRepositoryProvider = Provider<ProgressRepository>((ref) {
  return ProgressRepository();
});

/// Independent from [userProgressProvider] to avoid circular reads.
final localeProvider = StateProvider<AppLocale>((ref) => AppLocale.en);

final userProgressProvider =
    AsyncNotifierProvider<UserProgressNotifier, UserProgress>(
  UserProgressNotifier.new,
);

class UserProgressNotifier extends AsyncNotifier<UserProgress> {
  @override
  Future<UserProgress> build() async {
    final repo = ref.read(progressRepositoryProvider);
    await repo.init();
    final p = await repo.resetDailyIfNewDay();
    ref.read(localeProvider.notifier).state =
        p.localeCode == 'hi' ? AppLocale.hi : AppLocale.en;
    return p;
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    final p =
        await ref.read(progressRepositoryProvider).resetDailyIfNewDay();
    ref.read(localeProvider.notifier).state =
        p.localeCode == 'hi' ? AppLocale.hi : AppLocale.en;
    state = AsyncData(p);
  }

  Future<void> completeOnboarding({
    required int scrollHours,
    required bool switchOften,
    required int discomfort,
  }) async {
    final repo = ref.read(progressRepositoryProvider);
    await repo.ensureInitialized();
    final locale = ref.read(localeProvider);
    final p = await repo.completeOnboarding(
      scrollHours: scrollHours,
      switchOften: switchOften,
      discomfort: discomfort,
      localeCode: locale == AppLocale.hi ? 'hi' : 'en',
    );
    state = AsyncData(p);
  }

  Future<void> saveProfile({
    required String displayName,
    required AgeRange ageRange,
    required FocusGoal focusGoal,
    required PracticeSlot practiceSlot,
  }) async {
    final repo = ref.read(progressRepositoryProvider);
    final p = await repo.saveProfile(
      displayName: displayName,
      ageRange: ageRange,
      focusGoal: focusGoal,
      practiceSlot: practiceSlot,
    );
    state = AsyncData(p);
  }

  Future<void> recordSession({
    required SessionType type,
    required int stillnessSeconds,
    required double inhibitoryDelta,
    required double selectiveDelta,
    bool urgeCompleted = false,
    int? durationMinutes,
  }) async {
    final repo = ref.read(progressRepositoryProvider);
    final p = await repo.recordSession(
      type: type,
      stillnessSeconds: stillnessSeconds,
      inhibitoryDelta: inhibitoryDelta,
      selectiveDelta: selectiveDelta,
      urgeCompleted: urgeCompleted,
      durationMinutes: durationMinutes,
    );
    state = AsyncData(p);
  }

  Future<void> logReelsMinutes(int minutes) async {
    final repo = ref.read(progressRepositoryProvider);
    final p = await repo.logReelsMinutes(minutes);
    state = AsyncData(p);
  }

  Future<void> recordQuickTool({
    required String tool,
    required double inhibitoryDelta,
    required double selectiveDelta,
  }) async {
    final repo = ref.read(progressRepositoryProvider);
    final p = await repo.recordQuickTool(
      tool: tool,
      inhibitoryDelta: inhibitoryDelta,
      selectiveDelta: selectiveDelta,
    );
    state = AsyncData(p);
  }

  Future<void> setLocale(AppLocale locale) async {
    ref.read(localeProvider.notifier).state = locale;
    final repo = ref.read(progressRepositoryProvider);
    final p = await repo.setLocale(locale == AppLocale.hi ? 'hi' : 'en');
    state = AsyncData(p);
  }
}

final stringsProvider = Provider<AppStrings>((ref) {
  final locale = ref.watch(localeProvider);
  return AppStrings(locale);
});

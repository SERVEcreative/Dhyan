import 'package:dhyan/core/theme/app_theme.dart';
import 'package:dhyan/core/widgets/benefit_estimate_card.dart';
import 'package:dhyan/core/widgets/session_support_actions.dart';
import 'package:dhyan/data/models/skill_track.dart';
import 'package:dhyan/domain/benefit_estimator.dart';
import 'package:dhyan/providers/app_providers.dart';
import 'package:dhyan/providers/session_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SessionSummaryScreen extends ConsumerStatefulWidget {
  const SessionSummaryScreen({
    super.key,
    required this.sessionType,
    required this.stillnessSeconds,
    this.inhibitoryDelta = 5,
    this.selectiveDelta = 0,
    this.sessionMinutes = 3,
    this.indexBefore = 0,
  });

  final SessionType sessionType;
  final int stillnessSeconds;
  final double inhibitoryDelta;
  final double selectiveDelta;
  final int sessionMinutes;
  final double indexBefore;

  @override
  ConsumerState<SessionSummaryScreen> createState() =>
      _SessionSummaryScreenState();
}

class _SessionSummaryScreenState extends ConsumerState<SessionSummaryScreen> {
  bool _saved = false;
  bool _celebrationShown = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _saveAndCelebrate());
  }

  Future<void> _saveAndCelebrate() async {
    if (_saved) return;
    _saved = true;
    await ref.read(userProgressProvider.notifier).recordSession(
          type: widget.sessionType,
          stillnessSeconds: widget.stillnessSeconds,
          inhibitoryDelta: widget.inhibitoryDelta,
          selectiveDelta: widget.selectiveDelta,
          durationMinutes: widget.sessionMinutes,
        );
    resetSessionState(ref);

    if (!mounted || _celebrationShown) return;
    _celebrationShown = true;

    final progress = ref.read(userProgressProvider).valueOrNull;
    await showSessionCompleteCelebrationDialog(
      context,
      ref,
      sessionMinutes: widget.sessionMinutes,
      attentionIndex: progress?.attentionIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(stringsProvider);
    final progress = ref.watch(userProgressProvider).valueOrNull;
    final target = (widget.stillnessSeconds + 5).clamp(20, 300);

    final estimate = progress == null
        ? null
        : BenefitEstimator.forSession(
            sessionMinutes: widget.sessionMinutes,
            indexBefore: widget.indexBefore,
            indexAfter: progress.attentionIndex,
            track: progress.track,
            goal: progress.focusGoal,
            stillnessSeconds: widget.stillnessSeconds,
          );

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppTheme.homeCanvas,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.check_circle_outline,
                    size: 64, color: AppTheme.textPrimary),
                const SizedBox(height: 16),
                Text(
                  s.sessionComplete,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                if (progress != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    '${s.attentionIndex}: ${progress.attentionIndex.toStringAsFixed(0)}',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
                const SizedBox(height: 16),
                if (estimate != null)
                  BenefitEstimateCard(estimate: estimate, strings: s),
                const SizedBox(height: 12),
                Text(
                  s.tomorrowTarget(target),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const Spacer(),
                Text(
                  s.noMoreRounds,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.go('/'),
                  child: Text(s.closeMindfully),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

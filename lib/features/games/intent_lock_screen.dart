import 'package:dhyan/core/widgets/leave_session_dialog.dart';
import 'package:dhyan/core/theme/app_theme.dart';
import 'package:dhyan/data/models/skill_track.dart';
import 'package:dhyan/data/models/user_profile.dart';
import 'package:dhyan/features/games/drill_completion.dart';
import 'package:dhyan/features/session/session_navigator.dart';
import 'package:dhyan/providers/app_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Read personal anti-reels intention 3x — cognitive anchor before scrolling.
class IntentLockScreen extends ConsumerStatefulWidget {
  const IntentLockScreen({
    super.key,
    this.sessionType,
    this.drillIndex = 0,
    this.drills = const [],
    this.standalone = false,
  });

  final SessionType? sessionType;
  final int drillIndex;
  final List<DrillType> drills;
  final bool standalone;

  @override
  ConsumerState<IntentLockScreen> createState() => _IntentLockScreenState();
}

class _IntentLockScreenState extends ConsumerState<IntentLockScreen> {
  int _reads = 0;

  String _phrase(FocusGoal goal, bool isHi) => switch (goal) {
        FocusGoal.reduceReels => isHi
            ? 'Main Reels nahi, apna focus choose karta hoon.'
            : 'I choose my focus, not Reels.',
        FocusGoal.study => isHi
            ? 'Padhai ke liye mera dimaag clear rakhta hoon.'
            : 'I keep my mind clear for study.',
        FocusGoal.work => isHi
            ? 'Kaam ke waqt phone meri priority nahi.'
            : 'My phone is not my priority during work.',
        FocusGoal.generalFocus => isHi
            ? 'Ek cheez par poora dhyaan.'
            : 'Full attention on one thing.',
      };

  Future<void> _read() async {
    setState(() => _reads++);
    if (_reads < 3) return;

    if (widget.standalone) {
      await completeStandaloneTool(ref, tool: 'intentLock', selectiveDelta: 6);
      if (mounted) context.pop();
      return;
    }
    SessionNavigator.nextDrill(
      context,
      ref,
      sessionType: widget.sessionType!,
      drills: widget.drills,
      currentIndex: widget.drillIndex,
      selectiveDelta: 8,
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(stringsProvider);
    final goal =
        ref.watch(userProgressProvider).valueOrNull?.focusGoal ??
            FocusGoal.reduceReels;
    final phrase = _phrase(goal, s.isHindi);

    return SessionLeaveGuard(
      enabled: !widget.standalone,
      child: Scaffold(
      appBar: AppBar(
        title: Text(s.intentLock),
        leading: sessionCloseLeading(context, ref, standalone: widget.standalone),
      ),
      body: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(s.intentLockHint,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 32),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: AppTheme.calmCardGradient,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.restoreGreen.withValues(alpha: 0.5)),
              ),
              child: Text(
                phrase,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: 32),
            Text('$_reads / 3', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _read,
              child: Text(s.intentLockTap),
            ),
          ],
        ),
      ),
    ),
    );
  }
}

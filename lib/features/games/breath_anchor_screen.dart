import 'dart:async';

import 'package:dhyan/core/l10n/app_strings.dart';
import 'package:dhyan/core/theme/app_theme.dart';
import 'package:dhyan/core/widgets/leave_session_dialog.dart';
import 'package:dhyan/data/models/skill_track.dart';
import 'package:dhyan/features/games/drill_completion.dart';
import 'package:dhyan/features/session/session_navigator.dart';
import 'package:dhyan/providers/app_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class BreathAnchorScreen extends ConsumerStatefulWidget {
  const BreathAnchorScreen({
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
  ConsumerState<BreathAnchorScreen> createState() => _BreathAnchorScreenState();
}

class _BreathAnchorScreenState extends ConsumerState<BreathAnchorScreen> {
  static const _duration = 45;
  static const _inhale = 4;
  static const _hold = 7;
  static const _exhale = 8;
  static const _cycle = _inhale + _hold + _exhale;

  int _remaining = _duration;
  Timer? _timer;

  int get _elapsed => _duration - _remaining;
  int get _phaseIndex => _elapsed % _cycle;

  String _phaseLabel(AppStrings s) {
    if (_phaseIndex < _inhale) return s.breathInhale;
    if (_phaseIndex < _inhale + _hold) return s.breathHold;
    return s.breathExhale;
  }

  int get _phaseSecondsLeft {
    if (_phaseIndex < _inhale) return _inhale - _phaseIndex;
    if (_phaseIndex < _inhale + _hold) {
      return _inhale + _hold - _phaseIndex;
    }
    return _cycle - _phaseIndex;
  }

  double get _breathScale {
    if (_phaseIndex < _inhale) {
      return 0.45 + (_phaseIndex / _inhale) * 0.55;
    }
    if (_phaseIndex < _inhale + _hold) return 1.0;
    final exhaleProgress = _phaseIndex - _inhale - _hold;
    return 1.0 - (exhaleProgress / _exhale) * 0.55;
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() => _remaining--);
      if (_remaining <= 0) _next();
    });
  }

  Future<void> _next() async {
    _timer?.cancel();
    if (widget.standalone) {
      await completeStandaloneTool(ref, tool: 'breath');
      if (mounted) context.pop();
      return;
    }
    SessionNavigator.nextDrill(
      context,
      ref,
      sessionType: widget.sessionType!,
      drills: widget.drills,
      currentIndex: widget.drillIndex,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(stringsProvider);

    return SessionLeaveGuard(
      enabled: !widget.standalone,
      child: Scaffold(
        appBar: AppBar(
          title: Text(s.breathAnchor),
          leading: sessionCloseLeading(
            context,
            ref,
            standalone: widget.standalone,
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '4 · 7 · 8',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  _phaseLabel(s),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppTheme.primary,
                      ),
                ),
                Text(
                  s.secondsLabel(_phaseSecondsLeft),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textMuted,
                      ),
                ),
                const SizedBox(height: 32),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 900),
                  curve: Curves.easeInOut,
                  width: 200 * _breathScale,
                  height: 200 * _breathScale,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.primary.withValues(alpha: 0.12),
                    border: Border.all(
                      color: AppTheme.primary.withValues(alpha: 0.85),
                      width: 3,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  s.secondsLabel(_remaining),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:async';

import 'package:dhyan/core/widgets/leave_session_dialog.dart';
import 'package:dhyan/core/theme/app_theme.dart';
import 'package:dhyan/data/models/skill_track.dart';
import 'package:dhyan/features/games/drill_completion.dart';
import 'package:dhyan/features/session/session_navigator.dart';
import 'package:dhyan/providers/app_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Reels-style delayed reward — button unlocks only after wait.
class DelayTapScreen extends ConsumerStatefulWidget {
  const DelayTapScreen({
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
  ConsumerState<DelayTapScreen> createState() => _DelayTapScreenState();
}

class _DelayTapScreenState extends ConsumerState<DelayTapScreen> {
  static const _waitSeconds = 10;
  int _remaining = _waitSeconds;
  bool _unlocked = false;
  bool _earlyTaps = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        _remaining--;
        if (_remaining <= 0) _unlocked = true;
      });
    });
  }

  void _earlyTap() {
    if (_unlocked) return;
    setState(() => _earlyTaps = true);
  }

  Future<void> _onUnlockTap() async {
    if (!_unlocked) {
      _earlyTap();
      return;
    }
    _timer?.cancel();
    if (widget.standalone) {
      await completeStandaloneTool(
        ref,
        tool: 'delayTap',
        inhibitoryDelta: 10,
      );
      if (mounted) context.pop();
      return;
    }
    SessionNavigator.nextDrill(
      context,
      ref,
      sessionType: widget.sessionType!,
      drills: widget.drills,
      currentIndex: widget.drillIndex,
      inhibitoryDelta: 12,
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
        title: Text(s.delayTap),
        leading: sessionCloseLeading(context, ref, standalone: widget.standalone),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.hourglass_bottom,
                size: 48,
                color: _unlocked ? AppTheme.restoreGreen : AppTheme.textMuted,
              ),
              const SizedBox(height: 24),
              Text(
                _unlocked ? s.delayTapReady : s.delayTapWait,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              if (!_unlocked) ...[
                const SizedBox(height: 16),
                Text(
                  s.secondsLabel(_remaining),
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppTheme.focusBlue,
                      ),
                ),
              ],
              if (_earlyTaps && !_unlocked)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(
                    s.delayTapEarly,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.softLavender,
                        ),
                  ),
                ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _onUnlockTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _unlocked ? AppTheme.restoreGreen : AppTheme.surfaceElevated,
                  minimumSize: const Size(double.infinity, 52),
                ),
                child: Text(_unlocked ? s.delayTapButton : s.delayTapLocked),
              ),
            ],
          ),
        ),
      ),
    ),
    );
  }
}

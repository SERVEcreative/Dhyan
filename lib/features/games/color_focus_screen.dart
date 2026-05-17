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

/// White-dot sustained gaze on a dark field.
class ColorFocusScreen extends ConsumerStatefulWidget {
  const ColorFocusScreen({
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
  ConsumerState<ColorFocusScreen> createState() => _ColorFocusScreenState();
}

class _ColorFocusScreenState extends ConsumerState<ColorFocusScreen> {
  static const _duration = 50;
  int _remaining = _duration;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() => _remaining--);
      if (_remaining <= 0) _done();
    });
  }

  Future<void> _done() async {
    _timer?.cancel();
    if (widget.standalone) {
      await completeStandaloneTool(ref, tool: 'colorFocus', selectiveDelta: 5);
      if (mounted) context.pop();
      return;
    }
    SessionNavigator.nextDrill(
      context,
      ref,
      sessionType: widget.sessionType!,
      drills: widget.drills,
      currentIndex: widget.drillIndex,
      selectiveDelta: 5,
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
      backgroundColor: AppTheme.deepNavy,
      appBar: AppBar(
        title: Text(s.colorFocus),
        leading: sessionCloseLeading(context, ref, standalone: widget.standalone),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              s.colorFocusHint,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 40),
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.focusBlue,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.focusBlue.withValues(alpha: 0.55),
                    blurRadius: 32,
                    spreadRadius: 8,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Text(
              s.secondsLabel(_remaining),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppTheme.clarityTeal,
                  ),
            ),
          ],
        ),
      ),
    ),
    );
  }
}

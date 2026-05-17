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

/// Tolerate boredom without stimulus — retrains DMN escape to phone.
class BoredomBenchScreen extends ConsumerStatefulWidget {
  const BoredomBenchScreen({
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
  ConsumerState<BoredomBenchScreen> createState() => _BoredomBenchScreenState();
}

class _BoredomBenchScreenState extends ConsumerState<BoredomBenchScreen> {
  late int _remaining;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    final track =
        ref.read(userProgressProvider).valueOrNull?.track ?? SkillTrack.recovery;
    _remaining = switch (track) {
      SkillTrack.recovery => 45,
      SkillTrack.builder => 60,
      SkillTrack.master => 90,
    };
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() => _remaining--);
      if (_remaining <= 0) _done();
    });
  }

  Future<void> _done() async {
    _timer?.cancel();
    if (widget.standalone) {
      await completeStandaloneTool(ref, tool: 'boredomBench', selectiveDelta: 6);
      if (mounted) context.pop();
      return;
    }
    SessionNavigator.nextDrill(
      context,
      ref,
      sessionType: widget.sessionType!,
      drills: widget.drills,
      currentIndex: widget.drillIndex,
      selectiveDelta: 6,
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
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(s.boredomBench),
        leading: sessionCloseLeading(context, ref, standalone: widget.standalone),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.self_improvement, size: 48, color: AppTheme.restoreGreen.withValues(alpha: 0.6)),
              const SizedBox(height: 24),
              Text(
                s.boredomHint,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              Text(
                s.secondsLabel(_remaining),
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppTheme.softLavender,
                    ),
              ),
            ],
          ),
        ),
      ),
    ),
    );
  }
}

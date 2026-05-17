import 'dart:async';

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
  int _remaining = _duration;
  Timer? _timer;

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
        leading: sessionCloseLeading(context, ref, standalone: widget.standalone),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('4 - 7 - 8', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 24),
            Text(s.secondsLabel(_remaining), style: Theme.of(context).textTheme.titleLarge),
          ],
        ),
      ),
    ),
    );
  }
}

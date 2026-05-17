import 'dart:async';

import 'package:dhyan/core/widgets/leave_session_dialog.dart';
import 'package:dhyan/core/theme/app_theme.dart';
import 'package:dhyan/data/models/skill_track.dart';
import 'package:dhyan/domain/session_policy.dart';
import 'package:dhyan/domain/session_type_meta.dart';
import 'package:dhyan/features/session/session_navigator.dart';
import 'package:dhyan/providers/session_state.dart';
import 'package:dhyan/providers/app_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WarmupScreen extends ConsumerStatefulWidget {
  const WarmupScreen({super.key, required this.sessionType});

  final SessionType sessionType;

  @override
  ConsumerState<WarmupScreen> createState() => _WarmupScreenState();
}

class _WarmupScreenState extends ConsumerState<WarmupScreen> {
  late int _warmupSeconds;
  late int _remaining;
  Timer? _timer;
  bool _inhale = true;
  bool _started = false;

  @override
  void initState() {
    super.initState();
    _warmupSeconds = widget.sessionType.warmupSeconds;
    _remaining = _warmupSeconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        _remaining--;
        if (_remaining % 4 == 0) _inhale = !_inhale;
      });
      if (_remaining <= 0) _startSession();
    });
  }

  void _startSession() {
    if (_started) return;
    _started = true;
    _timer?.cancel();
    final progress = ref.read(userProgressProvider).valueOrNull;
    if (progress == null) return;
    beginSession(ref, widget.sessionType, progress.attentionIndex);
    final drills = SessionPolicy.drillsForSession(widget.sessionType, progress.track);
    SessionNavigator.startDrill(
      context,
      ref,
      sessionType: widget.sessionType,
      drills: drills,
      drillIndex: 0,
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
      child: Scaffold(
      appBar: AppBar(
        title: Text(s.warmup),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () async {
            final leave = await showLeaveSessionDialog(context, ref);
            if (leave && context.mounted) {
              abandonSessionAndGoHome(context, ref);
            }
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(seconds: 2),
                width: _inhale ? 120 : 80,
                height: _inhale ? 120 : 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.primary.withValues(alpha: 0.4),
                  border: Border.all(color: AppTheme.primary, width: 2),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                _inhale ? 'Inhale...' : 'Exhale...',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                s.secondsLabel(_remaining),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 48),
              TextButton(
                onPressed: _startSession,
                child: Text(s.isHindi ? 'Skip warm-up' : 'Skip warm-up'),
              ),
            ],
          ),
        ),
      ),
    ),
    );
  }
}

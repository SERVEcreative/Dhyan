import 'dart:async';
import 'dart:math';

import 'package:dhyan/core/widgets/leave_session_dialog.dart';
import 'package:dhyan/core/theme/app_theme.dart';
import 'package:dhyan/data/models/skill_track.dart';
import 'package:dhyan/features/games/drill_completion.dart';
import 'package:dhyan/features/session/session_navigator.dart';
import 'package:dhyan/providers/app_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sensors_plus/sensors_plus.dart';

class StillPointScreen extends ConsumerStatefulWidget {
  const StillPointScreen({
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
  ConsumerState<StillPointScreen> createState() => _StillPointScreenState();
}

class _StillPointScreenState extends ConsumerState<StillPointScreen> {
  StreamSubscription<AccelerometerEvent>? _accelSub;
  bool _useTouchMode = true;
  bool _holding = false;
  bool _showDistraction = false;
  bool _distractionIgnored = true;
  int _heldSeconds = 0;
  int _targetSeconds = 30;
  Timer? _tickTimer;
  double _movement = 0;

  @override
  void initState() {
    super.initState();
    final track = ref.read(userProgressProvider).valueOrNull?.track;
    _targetSeconds = track?.stillTargetSeconds ?? 30;
    _startAccel();
    _tickTimer = Timer.periodic(const Duration(seconds: 1), (_) => _onTick());
  }

  void _startAccel() {
    _accelSub = accelerometerEventStream().listen((e) {
      final mag = sqrt(e.x * e.x + e.y * e.y + e.z * e.z);
      _movement = (_movement * 0.9) + (mag - 9.8).abs() * 0.1;
      if (!_useTouchMode && _movement < 0.35) {
        if (!_holding) setState(() => _holding = true);
      } else if (!_useTouchMode && _movement >= 0.35) {
        if (_holding) setState(() => _holding = false);
      }
    });
  }

  void _onTick() {
    if (!mounted) return;
    if (_holding) {
      setState(() => _heldSeconds++);
      if (_heldSeconds == (_targetSeconds ~/ 2) && _targetSeconds >= 60) {
        _triggerDistraction();
      }
      if (_heldSeconds >= _targetSeconds) _complete();
    }
  }

  void _triggerDistraction() {
    HapticFeedback.mediumImpact();
    setState(() => _showDistraction = true);
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => _showDistraction = false);
    });
  }

  Future<void> _complete() async {
    _tickTimer?.cancel();
    _accelSub?.cancel();
    final selective = _distractionIgnored ? 8.0 : 0.0;
    if (widget.standalone) {
      await completeStandaloneTool(
        ref,
        tool: 'stillPoint',
        selectiveDelta: selective,
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
      stillnessSeconds: _heldSeconds,
      selectiveDelta: selective,
    );
  }

  @override
  void dispose() {
    _tickTimer?.cancel();
    _accelSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(stringsProvider);
    final progress = (_heldSeconds / _targetSeconds).clamp(0.0, 1.0);

    return SessionLeaveGuard(
      enabled: !widget.standalone,
      child: Scaffold(
      appBar: AppBar(
        title: Text(s.stillPoint),
        leading: sessionCloseLeading(context, ref, standalone: widget.standalone),
        actions: [
          TextButton(
            onPressed: () => setState(() {
              _useTouchMode = !_useTouchMode;
              _holding = false;
              _heldSeconds = 0;
            }),
            child: Text(_useTouchMode ? s.fingerHold : s.holdStill),
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          GestureDetector(
            onTapDown: (_) {
              if (_useTouchMode) setState(() => _holding = true);
            },
            onTapUp: (_) {
              if (_useTouchMode) setState(() => _holding = false);
            },
            onTapCancel: () {
              if (_useTouchMode) setState(() => _holding = false);
            },
            child: Container(
              color: AppTheme.background,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    width: 24 + progress * 48,
                    height: 24 + progress * 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _holding
                          ? AppTheme.primary
                          : AppTheme.primary.withValues(alpha: 0.3),
                      boxShadow: _holding
                          ? [
                              BoxShadow(
                                color: AppTheme.primary.withValues(alpha: 0.5),
                                blurRadius: 24,
                                spreadRadius: 4,
                              ),
                            ]
                          : null,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    _holding ? s.secondsLabel(_heldSeconds) : (_useTouchMode ? s.fingerHold : s.holdStill),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${s.secondsLabel(_targetSeconds)} goal',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 48),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: AppTheme.surface,
                      color: AppTheme.primary,
                      minHeight: 6,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_showDistraction)
            Positioned(
              top: 48,
              left: 16,
              right: 16,
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(12),
                color: AppTheme.surface,
                child: ListTile(
                  leading: const Icon(Icons.notifications, color: AppTheme.accent),
                  title: Text(s.distractionIgnore),
                  trailing: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      setState(() {
                        _showDistraction = false;
                        _distractionIgnored = true;
                      });
                    },
                  ),
                ),
              ),
            ),
        ],
      ),
    ),
    );
  }
}

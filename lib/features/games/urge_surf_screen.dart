import 'dart:async';
import 'dart:math';

import 'package:dhyan/core/theme/app_theme.dart';
import 'package:dhyan/core/widgets/keep_screen_on.dart';
import 'package:dhyan/data/models/skill_track.dart';
import 'package:dhyan/providers/app_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class UrgeSurfScreen extends ConsumerStatefulWidget {
  const UrgeSurfScreen({super.key});

  @override
  ConsumerState<UrgeSurfScreen> createState() => _UrgeSurfScreenState();
}

class _UrgeSurfScreenState extends ConsumerState<UrgeSurfScreen>
    with SingleTickerProviderStateMixin {
  static const _duration = 90;
  int _remaining = _duration;
  Timer? _timer;
  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() => _remaining--);
      if (_remaining <= 0) _done();
    });
  }

  Future<void> _done() async {
    _timer?.cancel();
    await ref.read(userProgressProvider.notifier).recordSession(
          type: SessionType.micro,
          stillnessSeconds: 0,
          inhibitoryDelta: 0,
          selectiveDelta: 5,
          urgeCompleted: true,
        );
    if (mounted) context.pop();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(stringsProvider);
    final phase = 1 - (_remaining / _duration);
    final urgeHeight = sin(phase * pi) * 80 + 40;

    return KeepScreenOn(
      child: Scaffold(
      appBar: AppBar(title: Text(s.urgeSurf)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                s.isHindi
                    ? 'Urge ko observe karo — fight mat karo'
                    : 'Observe the urge — do not fight it',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 40),
              AnimatedBuilder(
                animation: _waveController,
                builder: (_, __) {
                  return CustomPaint(
                    size: const Size(280, 120),
                    painter: _WavePainter(urgeHeight + _waveController.value * 10),
                  );
                },
              ),
              const SizedBox(height: 24),
              Text(
                s.secondsLabel(_remaining),
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
        ),
      ),
    ),
    );
  }
}

class _WavePainter extends CustomPainter {
  _WavePainter(this.amplitude);

  final double amplitude;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.primary.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final path = Path();
    for (var x = 0.0; x <= size.width; x++) {
      final y = size.height / 2 + sin(x / 30) * amplitude;
      if (x == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _WavePainter old) => old.amplitude != amplitude;
}

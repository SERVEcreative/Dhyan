import 'dart:async';

import 'package:dhyan/core/widgets/leave_session_dialog.dart';
import 'package:dhyan/core/theme/app_theme.dart';
import 'package:dhyan/data/models/skill_track.dart';
import 'package:dhyan/features/games/drill_completion.dart';
import 'package:dhyan/features/session/session_navigator.dart';
import 'package:dhyan/providers/app_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
/// Reels-style UI that tempts swiping — user must resist. Gentle popup on swipe.
class SwipeResistScreen extends ConsumerStatefulWidget {
  const SwipeResistScreen({
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
  ConsumerState<SwipeResistScreen> createState() => _SwipeResistScreenState();
}

class _SwipeResistScreenState extends ConsumerState<SwipeResistScreen>
    with SingleTickerProviderStateMixin {
  static const _duration = 60;
  static const _swipeThreshold = 36.0;

  int _remaining = _duration;
  int _swipeAttempts = 0;
  int _reelIndex = 0;
  double _dragOffset = 0;
  bool _popupOpen = false;
  DateTime _lastSwipePopup = DateTime.fromMillisecondsSinceEpoch(0);
  Timer? _timer;
  late AnimationController _bounceCtrl;
  late Animation<double> _bounceAnim;

  static const _reelGradients = [
    [Color(0xFF1A1A1A), Color(0xFF2E2E2E), Color(0xFF0A0A0A)],
    [Color(0xFF121212), Color(0xFF3A3A3A), Color(0xFF080808)],
    [Color(0xFF222222), Color(0xFF444444), Color(0xFF101010)],
    [Color(0xFF181818), Color(0xFF323232), Color(0xFF050505)],
  ];

  @override
  void initState() {
    super.initState();
    _bounceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _bounceAnim = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(parent: _bounceCtrl, curve: Curves.easeInOut),
    );
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() => _remaining--);
      if (_remaining <= 0) _finish();
    });
  }

  void _onSwipeAttempt() {
    final now = DateTime.now();
    setState(() {
      _swipeAttempts++;
      _reelIndex = (_reelIndex + 1) % _reelGradients.length;
      _dragOffset = 0;
    });
    if (_popupOpen) return;
    if (now.difference(_lastSwipePopup).inMilliseconds < 800) return;
    _lastSwipePopup = now;
    _showFocusPopup();
  }

  Future<void> _showFocusPopup() async {
    if (!mounted || _popupOpen) return;
    _popupOpen = true;
    final s = ref.read(stringsProvider);
    final quote = s.randomSwipeResistQuote();

    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.65),
      builder: (ctx) => _SwipeFocusPopup(
        title: s.swipeResistPopupTitle,
        message: quote,
        buttonLabel: s.swipeResistPopupButton,
      ),
    );

    if (mounted) _popupOpen = false;
  }

  Future<void> _finish() async {
    _timer?.cancel();
    if (widget.standalone) {
      await completeStandaloneTool(
        ref,
        tool: 'swipeResist',
        inhibitoryDelta: 8,
        selectiveDelta: 4,
      );
      if (mounted) Navigator.of(context).pop();
      return;
    }
    SessionNavigator.nextDrill(
      context,
      ref,
      sessionType: widget.sessionType!,
      drills: widget.drills,
      currentIndex: widget.drillIndex,
      inhibitoryDelta: 10,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _bounceCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(stringsProvider);
    final labels = [s.fakeReelLabel, s.fakeReelLabel2, s.fakeReelLabel3, s.fakeReelLabel];

    return SessionLeaveGuard(
      enabled: !widget.standalone,
      child: Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(s.swipeResist, style: const TextStyle(fontSize: 16)),
        leading: sessionCloseLeading(
          context,
          ref,
          standalone: widget.standalone,
          iconColor: Colors.white,
        ),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onVerticalDragUpdate: (d) {
          setState(() => _dragOffset += d.delta.dy);
          if (_dragOffset.abs() >= _swipeThreshold) {
            _onSwipeAttempt();
          }
        },
        onVerticalDragEnd: (_) {
          if (_dragOffset.abs() < _swipeThreshold) {
            setState(() => _dragOffset = 0);
          }
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            Transform.translate(
              offset: Offset(0, _dragOffset * 0.35),
              child: _TemptingReelCard(
                gradient: _reelGradients[_reelIndex % _reelGradients.length],
                label: labels[_reelIndex % labels.length],
                swipeCue: s.swipeResistSwipeCue,
                bounceAnim: _bounceAnim,
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    child: Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(2),
                            child: LinearProgressIndicator(
                              value: (_duration - _remaining) / _duration,
                              minHeight: 3,
                              backgroundColor: Colors.white24,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          s.secondsLabel(_remaining),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      s.swipeResistHint,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                    ),
                  ),
                  if (_swipeAttempts > 0)
                    Text(
                      s.swipeAttempts(_swipeAttempts),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.textMuted,
                          ),
                    ),
                ],
              ),
            ),
            Positioned(
              right: 12,
              bottom: 120,
              child: Column(
                children: [
                  _ReelSideAction(icon: Icons.favorite_border, label: '12K'),
                  const SizedBox(height: 16),
                  _ReelSideAction(icon: Icons.chat_bubble_outline, label: '248'),
                  const SizedBox(height: 16),
                  _ReelSideAction(icon: Icons.share_outlined, label: 'Share'),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
    );
  }
}

class _TemptingReelCard extends StatelessWidget {
  const _TemptingReelCard({
    required this.gradient,
    required this.label,
    required this.swipeCue,
    required this.bounceAnim,
  });

  final List<Color> gradient;
  final String label;
  final String swipeCue;
  final Animation<double> bounceAnim;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradient,
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.play_circle_outline,
                  size: 72,
                  color: Colors.white.withValues(alpha: 0.35),
                ),
                const SizedBox(height: 16),
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.55),
                    fontSize: 15,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 16,
            right: 72,
            bottom: 48,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    '@focus_training',
                    style: TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          AnimatedBuilder(
            animation: bounceAnim,
            builder: (context, child) {
              return Positioned(
                left: 0,
                right: 0,
                bottom: 24 + bounceAnim.value,
                child: child!,
              );
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.keyboard_arrow_up,
                  color: Colors.white.withValues(alpha: 0.7),
                  size: 32,
                ),
                Text(
                  swipeCue,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.65),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.white.withValues(alpha: 0.4),
                  size: 24,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ReelSideAction extends StatelessWidget {
  const _ReelSideAction({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 28),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 11),
        ),
      ],
    );
  }
}

class _SwipeFocusPopup extends StatelessWidget {
  const _SwipeFocusPopup({
    required this.title,
    required this.message,
    required this.buttonLabel,
  });

  final String title;
  final String message;
  final String buttonLabel;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppTheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('😢', style: TextStyle(fontSize: 56)),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 18,
                    color: AppTheme.textPrimary,
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    height: 1.45,
                    color: AppTheme.textMuted,
                  ),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              style: FilledButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: AppTheme.black,
                minimumSize: const Size(double.infinity, 48),
              ),
              child: Text(buttonLabel),
            ),
          ],
        ),
      ),
    );
  }
}

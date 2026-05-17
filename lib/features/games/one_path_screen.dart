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

/// Simple 5x5 maze — only one path from top-left to bottom-right.
class OnePathScreen extends ConsumerStatefulWidget {
  const OnePathScreen({
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
  ConsumerState<OnePathScreen> createState() => _OnePathScreenState();
}

class _OnePathScreenState extends ConsumerState<OnePathScreen> {
  // true = wall, false = path
  static const _walls = [
    [true, true, true, true, true, true, true],
    [true, false, false, false, false, false, true],
    [true, false, true, true, true, false, true],
    [true, false, false, false, true, false, true],
    [true, true, true, false, true, false, true],
    [true, false, false, false, false, false, true],
    [true, true, true, true, true, true, true],
  ];

  int _row = 1;
  int _col = 1;
  bool _waiting = false;
  int _waitSeconds = 0;
  Timer? _waitTimer;
  final _goalRow = 5;
  final _goalCol = 5;

  void _move(int dr, int dc) {
    if (_waiting) return;
    final nr = _row + dr;
    final nc = _col + dc;
    if (nr < 0 || nr >= _walls.length || nc < 0 || nc >= _walls[0].length) return;
    if (_walls[nr][nc]) {
      _penalty();
      return;
    }
    setState(() {
      _row = nr;
      _col = nc;
    });
    if (_row == _goalRow && _col == _goalCol) _finish();
  }

  void _penalty() {
    final s = ref.read(stringsProvider);
    setState(() {
      _waiting = true;
      _waitSeconds = 2;
    });
    _waitTimer?.cancel();
    _waitTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() => _waitSeconds--);
      if (_waitSeconds <= 0) {
        _waitTimer?.cancel();
        setState(() => _waiting = false);
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(s.wrongTurnWait), duration: const Duration(seconds: 2)),
    );
  }

  Future<void> _finish() async {
    if (widget.standalone) {
      await completeStandaloneTool(ref, tool: 'onePath', inhibitoryDelta: 10);
      if (mounted) context.pop();
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
    _waitTimer?.cancel();
    super.dispose();
  }

  static const _designCellSize = 26.0;

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(stringsProvider);
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return SessionLeaveGuard(
      enabled: !widget.standalone,
      child: Scaffold(
      appBar: AppBar(
        title: Text(s.onePath),
        leading: sessionCloseLeading(context, ref, standalone: widget.standalone),
      ),
      body: SafeArea(
        child: Column(
          children: [
            if (_waiting)
              Padding(
                padding: const EdgeInsets.only(top: 6, bottom: 4),
                child: Text(
                  s.secondsLabel(_waitSeconds),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: _MazeGrid(
                      walls: _walls,
                      row: _row,
                      col: _col,
                      goalRow: _goalRow,
                      goalCol: _goalCol,
                      cellSize: _designCellSize,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 8 + bottomInset),
              child: _DirectionPad(
                onUp: () => _move(-1, 0),
                onDown: () => _move(1, 0),
                onLeft: () => _move(0, -1),
                onRight: () => _move(0, 1),
              ),
            ),
          ],
        ),
      ),
    ),
    );
  }
}

class _MazeGrid extends StatelessWidget {
  const _MazeGrid({
    required this.walls,
    required this.row,
    required this.col,
    required this.goalRow,
    required this.goalCol,
    required this.cellSize,
  });

  final List<List<bool>> walls;
  final int row;
  final int col;
  final int goalRow;
  final int goalCol;
  final double cellSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(walls.length, (r) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(walls[r].length, (c) {
            final wall = walls[r][c];
            final isPlayer = r == row && c == col;
            final isGoal = r == goalRow && c == goalCol;
            return Container(
              width: cellSize,
              height: cellSize,
              margin: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                color: wall
                    ? AppTheme.surface
                    : isPlayer
                        ? AppTheme.primary
                        : isGoal
                            ? AppTheme.accent.withValues(alpha: 0.5)
                            : AppTheme.background,
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        );
      }),
    );
  }
}

class _DirectionPad extends StatelessWidget {
  const _DirectionPad({
    required this.onUp,
    required this.onDown,
    required this.onLeft,
    required this.onRight,
  });

  final VoidCallback onUp;
  final VoidCallback onDown;
  final VoidCallback onLeft;
  final VoidCallback onRight;

  @override
  Widget build(BuildContext context) {
    const pad = 36.0;
    return SizedBox(
      width: pad * 3,
      height: pad * 3 + 4,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(top: 0, child: _PadButton(icon: Icons.keyboard_arrow_up, onPressed: onUp)),
          Positioned(
            left: 0,
            top: pad,
            child: _PadButton(icon: Icons.keyboard_arrow_left, onPressed: onLeft),
          ),
          Positioned(
            right: 0,
            top: pad,
            child: _PadButton(icon: Icons.keyboard_arrow_right, onPressed: onRight),
          ),
          Positioned(
            bottom: 0,
            child: _PadButton(icon: Icons.keyboard_arrow_down, onPressed: onDown),
          ),
        ],
      ),
    );
  }
}

class _PadButton extends StatelessWidget {
  const _PadButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon),
      iconSize: 28,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints.tightFor(width: 40, height: 40),
      visualDensity: VisualDensity.compact,
    );
  }
}

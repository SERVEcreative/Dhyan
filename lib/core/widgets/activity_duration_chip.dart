import 'package:dhyan/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// Small pill for activity time — replaces raw "~90 sec" text lines.
class ActivityDurationChip extends StatelessWidget {
  const ActivityDurationChip({
    super.key,
    required this.label,
    this.muted = false,
  });

  final String label;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: muted
            ? AppTheme.surfaceElevated.withValues(alpha: 0.5)
            : AppTheme.surfaceElevated,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.cardBorder.withValues(alpha: muted ? 0.4 : 0.85),
        ),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
              color: muted ? AppTheme.textMuted : AppTheme.textPrimary,
            ),
      ),
    );
  }
}

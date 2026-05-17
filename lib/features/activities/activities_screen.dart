import 'package:dhyan/core/l10n/app_strings.dart';
import 'package:dhyan/core/theme/app_theme.dart';
import 'package:dhyan/core/widgets/activity_duration_chip.dart';
import 'package:dhyan/core/widgets/shell_scroll_padding.dart';
import 'package:dhyan/domain/activity_catalog.dart';
import 'package:dhyan/data/models/user_progress.dart';
import 'package:dhyan/domain/session_policy.dart';
import 'package:dhyan/domain/session_type_meta.dart';
import 'package:dhyan/providers/app_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ActivitiesScreen extends ConsumerWidget {
  const ActivitiesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(stringsProvider);
    final progress = ref.watch(userProgressProvider).valueOrNull;

    final byCategory = <ActivityCategory, List<ActivityDef>>{};
    for (final a in ActivityCatalog.all()) {
      byCategory.putIfAbsent(a.category, () => []).add(a);
    }

    return Scaffold(
      backgroundColor: AppTheme.homeCanvas,
      appBar: AppBar(
        title: Text(s.allActivities),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
          padding: shellScrollInsets(context, horizontal: 16, top: 4),
          children: [
            for (final category in ActivityCategory.values) ...[
              Text(
                ActivityCatalog.categoryLabel(category, s),
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: AppTheme.textMuted,
                    ),
              ),
              const SizedBox(height: 8),
              ...byCategory[category]!.map((a) {
                final blocked = _isBlocked(a, progress);
                return _ActivityTile(
                  activity: a,
                  strings: s,
                  enabled: !blocked,
                  subtitleExtra: blocked,
                  onTap: () => context.push(a.route),
                );
              }),
              const SizedBox(height: 16),
            ],
          ],
      ),
    );
  }

  bool _isBlocked(ActivityDef a, UserProgress? progress) {
    if (progress == null) return true;
    final type = SessionTypeMeta.fromRoute(a.id);
    if (type != null) {
      return !SessionPolicy.canStart(progress, type);
    }
    return false;
  }
}

class _ActivityTile extends StatelessWidget {
  const _ActivityTile({
    required this.activity,
    required this.strings,
    required this.onTap,
    required this.enabled,
    this.subtitleExtra = false,
  });

  final ActivityDef activity;
  final AppStrings strings;
  final VoidCallback onTap;
  final bool enabled;
  final bool subtitleExtra;

  @override
  Widget build(BuildContext context) {
    final duration = activity.durationLabel?.call(strings);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Icon(activity.icon, color: AppTheme.focusBlue),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              activity.title(strings),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: enabled
                                        ? AppTheme.textPrimary
                                        : AppTheme.textMuted,
                                  ),
                            ),
                          ),
                          if (duration != null) ...[
                            const SizedBox(width: 8),
                            ActivityDurationChip(
                              label: duration,
                              muted: !enabled,
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        activity.subtitle(strings),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 13,
                              height: 1.35,
                              color: AppTheme.textMuted,
                            ),
                      ),
                      if (subtitleExtra) ...[
                        const SizedBox(height: 4),
                        Text(
                          strings.sessionLimitReached,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppTheme.softLavender,
                              ),
                        ),
                      ],
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: enabled ? AppTheme.textMuted : AppTheme.textMuted.withValues(alpha: 0.3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

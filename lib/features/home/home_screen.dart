import 'package:dhyan/core/l10n/app_strings.dart';
import 'package:dhyan/core/theme/app_theme.dart';
import 'package:dhyan/core/widgets/shell_scroll_padding.dart';
import 'package:dhyan/data/models/skill_track.dart';
import 'package:dhyan/data/models/user_progress.dart';
import 'package:dhyan/domain/activity_catalog.dart';
import 'package:dhyan/domain/session_policy.dart';
import 'package:dhyan/domain/session_type_meta.dart';
import 'package:dhyan/features/home/reels_honesty_sheet.dart';
import 'package:dhyan/providers/app_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressAsync = ref.watch(userProgressProvider);
    final s = ref.watch(stringsProvider);

    return progressAsync.when(
      loading: () => const Scaffold(
        backgroundColor: AppTheme.homeCanvas,
        body: Center(
          child: CircularProgressIndicator(color: AppTheme.focusBlue),
        ),
      ),
      error: (e, _) => Scaffold(
        backgroundColor: AppTheme.homeCanvas,
        body: Center(child: Text('$e')),
      ),
      data: (progress) {
        if (!progress.onboardingComplete || !progress.profileComplete) {
          return const Scaffold(
            backgroundColor: AppTheme.homeCanvas,
            body: Center(
              child: CircularProgressIndicator(color: AppTheme.focusBlue),
            ),
          );
        }

        final antiReel = ActivityCatalog.all()
            .where((a) => a.category == ActivityCategory.antiReel)
            .toList();

        return Scaffold(
          backgroundColor: AppTheme.homeCanvas,
          body: SafeArea(
            bottom: false,
            child: ListView(
              padding: shellScrollInsets(context, horizontal: 16, top: 12),
              children: [
                Text(
                  s.greeting(progress.greetingName),
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  s.minimalTagline,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textMuted,
                        height: 1.35,
                      ),
                ),
                const SizedBox(height: 20),
                _AttentionCard(index: progress.attentionIndex, strings: s),
                const SizedBox(height: 16),
                _SessionPicker(
                  strings: s,
                  progress: progress,
                  onSession: (type) => context.push(type.routePath),
                ),
                const SizedBox(height: 20),
                Text(
                  s.antiReelTitle,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppTheme.textMuted,
                        letterSpacing: 0.2,
                      ),
                ),
                const SizedBox(height: 10),
                _AntiReelGrid(activities: antiReel, strings: s),
                const SizedBox(height: 4),
                Center(
                  child: TextButton(
                    onPressed: () => showReelsHonestySheet(context, ref),
                    style: TextButton.styleFrom(
                      foregroundColor: AppTheme.textMuted,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    child: Text(s.reelsLogCta),
                  ),
                ),
                Center(
                  child: TextButton(
                    onPressed: () => context.push('/privacy'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppTheme.textMuted,
                      textStyle: const TextStyle(fontSize: 13),
                    ),
                    child: Text(s.privacyPolicyLink),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _AttentionCard extends StatelessWidget {
  const _AttentionCard({required this.index, required this.strings});

  final double index;
  final AppStrings strings;

  @override
  Widget build(BuildContext context) {
    final pct = (index / 100).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: AppTheme.homeCardDecoration(
        borderColor: AppTheme.focusBlue.withValues(alpha: 0.35),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 64,
            height: 64,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: pct,
                  strokeWidth: 5,
                  backgroundColor: AppTheme.deepNavy,
                  color: AppTheme.textPrimary,
                ),
                Text(
                  index.toStringAsFixed(0),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppTheme.focusBlue,
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  strings.attentionIndex,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppTheme.textMuted,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  strings.homeAttentionHint,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 13,
                        height: 1.3,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SessionPicker extends StatelessWidget {
  const _SessionPicker({
    required this.strings,
    required this.progress,
    required this.onSession,
  });

  final AppStrings strings;
  final UserProgress progress;
  final void Function(SessionType type) onSession;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppTheme.homeCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            strings.homeSessionTitle,
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: 12),
          for (final type in sessionDisplayOrder) ...[
            _SessionTile(
              title: strings.sessionTitle(type),
              subtitle: strings.sessionSubtitle(type),
              highlight: type.isUniversalPrep,
              enabled: SessionPolicy.canStart(progress, type),
              blockReason: SessionPolicy.blockReason(progress, type),
              strings: strings,
              onTap: () => onSession(type),
            ),
            if (type != sessionDisplayOrder.last) const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}

class _SessionTile extends StatelessWidget {
  const _SessionTile({
    required this.title,
    required this.subtitle,
    required this.highlight,
    required this.enabled,
    required this.blockReason,
    required this.strings,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final bool highlight;
  final bool enabled;
  final String? blockReason;
  final AppStrings strings;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: highlight ? AppTheme.surfaceElevated : AppTheme.surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: highlight ? AppTheme.textPrimary : AppTheme.cardBorder,
              width: highlight ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: enabled ? AppTheme.textPrimary : AppTheme.textMuted,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      enabled
                          ? subtitle
                          : SessionPolicy.blockMessage(strings, blockReason),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.textMuted,
                            fontSize: 12,
                          ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.play_arrow_rounded,
                color: enabled ? AppTheme.textPrimary : AppTheme.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AntiReelGrid extends StatelessWidget {
  const _AntiReelGrid({required this.activities, required this.strings});

  final List<ActivityDef> activities;
  final AppStrings strings;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = 10.0;
        final cellW = (constraints.maxWidth - gap) / 2;

        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: activities.map((a) {
            return SizedBox(
              width: cellW,
              child: _QuickDrillTile(
                title: a.title(strings),
                icon: a.icon,
                onTap: () => context.push(a.route),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class _QuickDrillTile extends StatelessWidget {
  const _QuickDrillTile({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppTheme.cardBorder.withValues(alpha: 0.5)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: AppTheme.textPrimary, size: 22),
              const SizedBox(height: 8),
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 14,
                      height: 1.25,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

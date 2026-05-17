import 'package:dhyan/core/theme/app_theme.dart';
import 'package:dhyan/core/widgets/shell_scroll_padding.dart';
import 'package:dhyan/core/widgets/benefit_estimate_card.dart';
import 'package:dhyan/domain/benefit_estimator.dart';
import 'package:dhyan/providers/app_providers.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressAsync = ref.watch(userProgressProvider);
    final s = ref.watch(stringsProvider);

    return Scaffold(
      backgroundColor: AppTheme.homeCanvas,
      appBar: AppBar(title: Text(s.progress)),
      body: progressAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('$e')),
          data: (p) {
            final spots = <FlSpot>[];
            for (var i = 0; i < p.history.length; i++) {
              spots.add(FlSpot(i.toDouble(), p.history[i].attentionIndex));
            }
            if (spots.isEmpty) spots.add(const FlSpot(0, 0));

            final lastSession = p.history.isNotEmpty ? p.history.last : null;
            final estimate = lastSession == null
                ? null
                : BenefitEstimator.forSession(
                    sessionMinutes: lastSession.durationMinutes,
                    indexBefore: p.baselineAttentionIndex,
                    indexAfter: lastSession.attentionIndex,
                    track: p.track,
                    goal: p.focusGoal,
                    stillnessSeconds: lastSession.stillnessSeconds,
                  );

            final weeklyProj = (p.attentionIndex +
                    (p.totalFocusMinutes > 0 ? 8.0 : 3.0))
                .clamp(0, 100);

            return ListView(
              padding: shellScrollInsets(context, horizontal: 16, top: 8),
              children: [
                if (estimate != null)
                  BenefitEstimateCard(estimate: estimate, strings: s),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(s.sinceStart,
                            style: Theme.of(context).textTheme.labelLarge),
                        const SizedBox(height: 8),
                        Text(
                          '${s.totalTrained}: ${s.minutesUnit(p.totalFocusMinutes)}',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Text(
                          '${s.weeklyProjection}: ${weeklyProj.toStringAsFixed(0)}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _MetricRow(label: s.sustained, value: '${p.maxStillnessSeconds}s'),
                _MetricRow(
                  label: s.selective,
                  value: '${p.distractionResistRate.toStringAsFixed(0)}%',
                ),
                _MetricRow(
                  label: s.inhibitory,
                  value: '${p.inhibitoryScore.toStringAsFixed(0)}%',
                ),
                const SizedBox(height: 16),
                Text(s.attentionIndex,
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 12),
                SizedBox(
                  height: 200,
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        getDrawingHorizontalLine: (_) => FlLine(
                          color: AppTheme.textMuted.withValues(alpha: 0.2),
                        ),
                      ),
                      titlesData: const FlTitlesData(show: false),
                      borderData: FlBorderData(show: false),
                      minY: 0,
                      maxY: 100,
                      lineBarsData: [
                        LineChartBarData(
                          spots: spots,
                          isCurved: true,
                          color: AppTheme.focusBlue,
                          barWidth: 3,
                          dotData: const FlDotData(show: true),
                          belowBarData: BarAreaData(
                            show: true,
                            color: AppTheme.focusBlue.withValues(alpha: 0.12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '${s.streak}: ${p.streakDays} · Urge: ${p.urgeResistCount}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 12),
                Text(s.disclaimer, style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 16),
                Center(
                  child: TextButton(
                    onPressed: () => context.push('/privacy'),
                    child: Text(s.privacyPolicyLink),
                  ),
                ),
              ],
            );
          },
      ),
    );
  }
}

class _MetricRow extends StatelessWidget {
  const _MetricRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyLarge),
          Text(value, style: Theme.of(context).textTheme.labelLarge),
        ],
      ),
    );
  }
}

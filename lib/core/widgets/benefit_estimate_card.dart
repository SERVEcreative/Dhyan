import 'package:dhyan/core/l10n/app_strings.dart';
import 'package:dhyan/core/theme/app_theme.dart';
import 'package:dhyan/domain/benefit_estimator.dart';
import 'package:flutter/material.dart';

class BenefitEstimateCard extends StatelessWidget {
  const BenefitEstimateCard({
    super.key,
    required this.estimate,
    required this.strings,
    this.compact = false,
  });

  final FocusBenefitEstimate estimate;
  final AppStrings strings;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final insight = strings.isHindi ? estimate.insightHi : estimate.insightEn;

    return Container(
      decoration: BoxDecoration(
        gradient: AppTheme.calmCardGradient,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.focusBlue.withValues(alpha: 0.35)),
      ),
      padding: EdgeInsets.all(compact ? 14 : 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.psychology_outlined, color: AppTheme.restoreGreen, size: 22),
              const SizedBox(width: 8),
              Text(
                strings.estimatedBenefit,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: AppTheme.restoreGreen,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _Row(
            label: strings.attentionGain,
            value: '+${estimate.attentionIndexGain.toStringAsFixed(1)}',
            color: AppTheme.focusBlue,
          ),
          _Row(
            label: strings.readingEquiv,
            value: strings.minutesUnit(estimate.deepReadingMinutesEquiv),
            color: AppTheme.clarityTeal,
          ),
          _Row(
            label: strings.impulseBoost,
            value: '+${estimate.impulseControlPercent}%',
            color: AppTheme.softLavender,
          ),
          if (!compact) ...[
            const SizedBox(height: 10),
            Text(insight, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 6),
            Text(
              strings.estimateDisclaimer,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 11,
                    fontStyle: FontStyle.italic,
                  ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.value, required this.color});

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          Text(
            value,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

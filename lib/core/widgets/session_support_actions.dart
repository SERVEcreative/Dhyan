import 'dart:async';

import 'package:dhyan/core/ads/admob_service.dart';
import 'package:dhyan/core/l10n/app_strings.dart';
import 'package:dhyan/core/theme/app_theme.dart';
import 'package:dhyan/providers/app_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> showEyesClosedSponsorAd(BuildContext context, WidgetRef ref) async {
  final s = ref.read(stringsProvider);

  if (!AdMobService.isSupported) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(s.supportAdWebOnly)),
      );
    }
    return;
  }

  if (!context.mounted) return;
  unawaited(
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => PopScope(
        canPop: false,
        child: AlertDialog(
          backgroundColor: AppTheme.surface,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(color: AppTheme.primary),
              const SizedBox(height: 20),
              Text(
                s.supportAdLoading,
                textAlign: TextAlign.center,
                style: Theme.of(ctx).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              Text(
                s.supportEyesClosedHint,
                textAlign: TextAlign.center,
                style: Theme.of(ctx).textTheme.bodySmall?.copyWith(
                      color: AppTheme.textMuted,
                      height: 1.4,
                    ),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  var loadingDismissed = false;
  void dismissLoading() {
    if (loadingDismissed || !context.mounted) return;
    loadingDismissed = true;
    final nav = Navigator.of(context, rootNavigator: true);
    if (nav.canPop()) nav.pop();
  }

  final watched = await AdMobService.showRewardedAd(
    onAdShown: dismissLoading,
  );
  dismissLoading();

  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(watched ? s.supportEyesClosedDone : s.supportAdFailed),
      ),
    );
  }
}

void showDonateSupportSheet(BuildContext context, WidgetRef ref) {
  final s = ref.read(stringsProvider);
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: AppTheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) => Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(s.supportDonateTitle, style: Theme.of(ctx).textTheme.titleLarge),
          const SizedBox(height: 12),
          Text(s.supportDonateHint, style: Theme.of(ctx).textTheme.bodyMedium),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.surfaceElevated,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.cardBorder),
            ),
            child: Text(
              s.supportUpiPlaceholder,
              textAlign: TextAlign.center,
              style: Theme.of(ctx).textTheme.titleLarge?.copyWith(letterSpacing: 1.2),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: s.supportUpiPlaceholder));
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(s.supportDonateCopied)),
              );
            },
            icon: const Icon(Icons.copy),
            label: Text(s.supportDonateCopy),
          ),
        ],
      ),
    ),
  );
}

/// Congratulations + early-stage support request when a session ends.
Future<void> showSessionCompleteCelebrationDialog(
  BuildContext context,
  WidgetRef ref, {
  required int sessionMinutes,
  double? attentionIndex,
}) {
  final s = ref.read(stringsProvider);

  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => _CelebrationDialog(
      strings: s,
      sessionMinutes: sessionMinutes,
      attentionIndex: attentionIndex,
      onWatchAd: () async {
        Navigator.of(ctx).pop();
        await showEyesClosedSponsorAd(context, ref);
      },
      onDonate: () {
        Navigator.of(ctx).pop();
        showDonateSupportSheet(context, ref);
      },
    ),
  );
}

class _CelebrationDialog extends StatelessWidget {
  const _CelebrationDialog({
    required this.strings,
    required this.sessionMinutes,
    required this.attentionIndex,
    required this.onWatchAd,
    required this.onDonate,
  });

  final AppStrings strings;
  final int sessionMinutes;
  final double? attentionIndex;
  final Future<void> Function() onWatchAd;
  final VoidCallback onDonate;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppTheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: const BorderSide(color: AppTheme.cardBorder),
      ),
      contentPadding: const EdgeInsets.fromLTRB(24, 28, 24, 8),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🎉', style: TextStyle(fontSize: 56)),
            const SizedBox(height: 12),
            Text(
              strings.congratsTitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              strings.congratsSessionDone(sessionMinutes),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            if (attentionIndex != null) ...[
              const SizedBox(height: 8),
              Text(
                '${strings.attentionIndex}: ${attentionIndex!.toStringAsFixed(0)}',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppTheme.textPrimary,
                    ),
              ),
            ],
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.surfaceElevated,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.cardBorder),
              ),
              child: Text(
                strings.earlyStageHelpRequest,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      height: 1.45,
                      fontSize: 14,
                    ),
              ),
            ),
          ],
        ),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      actions: [
        FilledButton.icon(
          onPressed: () => onWatchAd(),
          icon: const Icon(Icons.visibility_off_outlined, size: 20),
          style: FilledButton.styleFrom(
            backgroundColor: AppTheme.primary,
            foregroundColor: AppTheme.black,
            minimumSize: const Size(double.infinity, 48),
          ),
          label: Text(strings.congratsWatchAd),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: onDonate,
          icon: const Icon(Icons.favorite_outline, size: 20),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 48),
          ),
          label: Text(strings.congratsDonate),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(strings.congratsMaybeLater),
        ),
      ],
    );
  }
}

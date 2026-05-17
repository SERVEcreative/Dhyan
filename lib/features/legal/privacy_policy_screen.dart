import 'package:dhyan/core/legal/app_legal.dart';
import 'package:dhyan/core/legal/privacy_policy_content.dart';
import 'package:dhyan/core/theme/app_theme.dart';
import 'package:dhyan/providers/app_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacyPolicyScreen extends ConsumerWidget {
  const PrivacyPolicyScreen({super.key});

  Future<void> _openHostedUrl() async {
    final url = Uri.tryParse(AppLegal.privacyPolicyUrl);
    if (url == null || AppLegal.privacyPolicyUrl.isEmpty) return;
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(stringsProvider);
    final isHindi = s.isHindi;

    return Scaffold(
      backgroundColor: AppTheme.homeCanvas,
      appBar: AppBar(title: Text(s.privacyPolicyTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            Text(
              s.privacyPolicyUpdated(AppLegal.privacyPolicyLastUpdated),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textMuted,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              '${AppLegal.appName} · ${AppLegal.packageName}',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppTheme.textMuted,
                  ),
            ),
            if (AppLegal.privacyPolicyUrl.isNotEmpty) ...[
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _openHostedUrl,
                icon: const Icon(Icons.open_in_new, size: 18),
                label: Text(s.privacyPolicyOpenWeb),
              ),
            ],
            const SizedBox(height: 20),
            for (final section in PrivacyPolicyContent.sections) ...[
              Text(
                section.title(isHindi),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                section.body(isHindi),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      height: 1.5,
                      color: AppTheme.textPrimary.withValues(alpha: 0.9),
                    ),
              ),
              const SizedBox(height: 20),
            ],
          ],
        ),
      ),
    );
  }
}

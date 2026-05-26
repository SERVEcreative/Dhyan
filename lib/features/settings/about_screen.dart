import 'package:dhyan/core/legal/app_legal.dart';
import 'package:dhyan/core/theme/app_theme.dart';
import 'package:dhyan/providers/app_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends ConsumerWidget {
  const AboutScreen({super.key});

  Future<void> _openUrl(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(stringsProvider);

    return Scaffold(
      backgroundColor: AppTheme.homeCanvas,
      appBar: AppBar(title: Text(s.aboutTitle)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: AppTheme.surfaceElevated,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.cardBorder),
              ),
              child: const Icon(Icons.self_improvement, size: 48),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            AppLegal.appName,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 4),
          Text(
            '${s.aboutVersion} ${AppLegal.appVersion} (${AppLegal.appBuildNumber})',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textMuted,
                ),
          ),
          const SizedBox(height: 28),
          _AboutTile(
            label: s.aboutCompanyName,
            value: AppLegal.developerName,
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              s.aboutMailBox,
              style: Theme.of(context).textTheme.labelMedium,
            ),
            trailing: IconButton.filled(
              onPressed: () => _openUrl('mailto:${AppLegal.contactEmail}'),
              icon: const Icon(Icons.mail_outline),
              tooltip: s.aboutMailBoxTap,
              style: IconButton.styleFrom(
                backgroundColor: AppTheme.surfaceElevated,
                foregroundColor: AppTheme.textPrimary,
              ),
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(s.privacyPolicyLink),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/privacy'),
          ),
          if (AppLegal.privacyPolicyUrl.isNotEmpty)
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(s.privacyPolicyOpenWeb),
              trailing: const Icon(Icons.open_in_new, size: 20),
              onTap: () => _openUrl(AppLegal.privacyPolicyUrl),
            ),
        ],
      ),
    );
  }
}

class _AboutTile extends StatelessWidget {
  const _AboutTile({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label, style: Theme.of(context).textTheme.labelMedium),
      subtitle: Text(value),
    );
  }
}

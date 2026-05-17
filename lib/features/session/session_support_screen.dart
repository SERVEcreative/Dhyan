import 'package:dhyan/core/theme/app_theme.dart';
import 'package:dhyan/core/widgets/session_support_actions.dart';
import 'package:dhyan/providers/app_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Standalone support page (also reachable from celebration dialog actions).
class SessionSupportScreen extends ConsumerStatefulWidget {
  const SessionSupportScreen({super.key});

  @override
  ConsumerState<SessionSupportScreen> createState() =>
      _SessionSupportScreenState();
}

class _SessionSupportScreenState extends ConsumerState<SessionSupportScreen> {
  bool _sponsorRunning = false;

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(stringsProvider);

    return Scaffold(
      backgroundColor: AppTheme.homeCanvas,
      appBar: AppBar(title: Text(s.supportTitle)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                s.earlyStageHelpRequest,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 28),
              _SupportOptionCard(
                icon: Icons.visibility_off_outlined,
                title: s.supportEyesClosedTitle,
                subtitle: s.supportEyesClosedHint,
                onTap: _sponsorRunning
                    ? null
                    : () async {
                        setState(() => _sponsorRunning = true);
                        await showEyesClosedSponsorAd(context, ref);
                        if (mounted) setState(() => _sponsorRunning = false);
                      },
              ),
              const SizedBox(height: 12),
              _SupportOptionCard(
                icon: Icons.favorite_outline,
                title: s.supportDonateTitle,
                subtitle: s.supportDonateHint,
                onTap: () => showDonateSupportSheet(context, ref),
              ),
              const Spacer(),
              TextButton(
                onPressed: () => context.push('/privacy'),
                child: Text(s.privacyPolicyLink),
              ),
              TextButton(
                onPressed: () => context.go('/'),
                child: Text(s.supportSkip),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SupportOptionCard extends StatelessWidget {
  const _SupportOptionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.cardBorder),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: AppTheme.textPrimary, size: 28),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontSize: 17,
                          ),
                    ),
                    const SizedBox(height: 6),
                    Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppTheme.textMuted),
            ],
          ),
        ),
      ),
    );
  }
}

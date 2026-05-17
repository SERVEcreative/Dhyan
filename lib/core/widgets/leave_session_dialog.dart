import 'package:dhyan/core/l10n/app_strings.dart';
import 'package:dhyan/core/theme/app_theme.dart';
import 'package:dhyan/core/widgets/keep_screen_on.dart';
import 'package:dhyan/providers/app_providers.dart';
import 'package:dhyan/providers/session_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Gentle scolding when user tries to quit mid-session. `true` = leave session.
Future<bool> showLeaveSessionDialog(BuildContext context, WidgetRef ref) async {
  final s = ref.read(stringsProvider);
  final quote = s.randomLeaveSessionQuote();

  final leave = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black.withValues(alpha: 0.72),
    builder: (ctx) => _LeaveSessionDialog(strings: s, quote: quote),
  );

  return leave == true;
}

void abandonSessionAndGoHome(BuildContext context, WidgetRef ref) {
  resetSessionState(ref);
  context.go('/');
}

/// Close button for session drills (shows leave dialog).
Widget sessionCloseLeading(
  BuildContext context,
  WidgetRef ref, {
  required bool standalone,
  Color? iconColor,
}) {
  if (standalone) {
    return IconButton(
      icon: Icon(Icons.close, color: iconColor),
      onPressed: () => context.pop(),
    );
  }
  return IconButton(
    icon: Icon(Icons.close, color: iconColor),
    onPressed: () async {
      final leave = await showLeaveSessionDialog(context, ref);
      if (leave && context.mounted) {
        abandonSessionAndGoHome(context, ref);
      }
    },
  );
}

class SessionLeaveGuard extends ConsumerWidget {
  const SessionLeaveGuard({
    super.key,
    required this.child,
    this.enabled = true,
    this.keepScreenOn = true,
  });

  final Widget child;
  final bool enabled;
  final bool keepScreenOn;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget content = child;
    if (enabled) {
      content = PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) async {
          if (didPop) return;
          final leave = await showLeaveSessionDialog(context, ref);
          if (leave && context.mounted) {
            abandonSessionAndGoHome(context, ref);
          }
        },
        child: child,
      );
    }
    if (!keepScreenOn) return content;
    return KeepScreenOn(child: content);
  }
}

class _LeaveSessionDialog extends StatelessWidget {
  const _LeaveSessionDialog({required this.strings, required this.quote});

  final AppStrings strings;
  final String quote;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppTheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: const BorderSide(color: AppTheme.cardBorder, width: 1.5),
      ),
      title: Column(
        children: [
          const Text('😤', style: TextStyle(fontSize: 52)),
          const SizedBox(height: 8),
          Text(
            strings.leaveSessionTitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              quote,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    height: 1.5,
                    fontSize: 16,
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              strings.leaveSessionSubtitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                  ),
            ),
          ],
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
      actions: [
        FilledButton(
          onPressed: () => Navigator.of(context).pop(false),
          style: FilledButton.styleFrom(
            backgroundColor: AppTheme.primary,
            foregroundColor: AppTheme.black,
            minimumSize: const Size(double.infinity, 48),
          ),
          child: Text(strings.leaveSessionStay),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: TextButton.styleFrom(foregroundColor: AppTheme.textMuted),
          child: Text(strings.leaveSessionQuit),
        ),
      ],
    );
  }
}

import 'package:dhyan/core/l10n/app_strings.dart';
import 'package:dhyan/core/theme/app_theme.dart';
import 'package:dhyan/providers/app_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Shows a focus-oriented exit prompt. Returns `true` if the user chose to leave.
Future<bool> showExitFocusDialog(BuildContext context, WidgetRef ref) async {
  final s = ref.read(stringsProvider);
  final quote = s.randomExitQuote();

  final leave = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => _ExitFocusDialog(strings: s, quote: quote),
  );

  return leave == true;
}

class _ExitFocusDialog extends StatelessWidget {
  const _ExitFocusDialog({required this.strings, required this.quote});

  final AppStrings strings;
  final String quote;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppTheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: AppTheme.cardBorder),
      ),
      title: Row(
        children: [
          Icon(Icons.psychology_outlined, color: AppTheme.textPrimary, size: 28),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              strings.exitDialogTitle,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18),
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              quote,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    height: 1.45,
                    fontSize: 16,
                    color: AppTheme.textPrimary,
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              strings.exitDialogSubtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 13,
                    color: AppTheme.textMuted,
                  ),
            ),
          ],
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      actions: [
        FilledButton(
          onPressed: () => Navigator.of(context).pop(false),
          style: FilledButton.styleFrom(
            backgroundColor: AppTheme.primary,
            foregroundColor: AppTheme.black,
            minimumSize: const Size(double.infinity, 48),
          ),
          child: Text(strings.exitStayFocused),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: TextButton.styleFrom(foregroundColor: AppTheme.textMuted),
          child: Text(strings.exitLeaveAnyway),
        ),
      ],
    );
  }
}

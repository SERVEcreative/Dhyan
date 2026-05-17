import 'package:dhyan/core/theme/app_theme.dart';
import 'package:dhyan/providers/app_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void showReelsHonestySheet(BuildContext context, WidgetRef ref) {
  final s = ref.read(stringsProvider);
  var minutes = ref.read(userProgressProvider).valueOrNull?.reelsLoggedMinutes ?? 0;

  showModalBottomSheet<void>(
    context: context,
    backgroundColor: AppTheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) {
      return StatefulBuilder(
        builder: (ctx, setState) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(s.reelsLogTitle, style: Theme.of(ctx).textTheme.titleLarge),
                const SizedBox(height: 8),
                Text(s.reelsLogHint, style: Theme.of(ctx).textTheme.bodyMedium),
                const SizedBox(height: 20),
                Slider(
                  value: minutes.toDouble(),
                  min: 0,
                  max: 300,
                  divisions: 60,
                  label: s.minutesUnit(minutes),
                  onChanged: (v) => setState(() => minutes = v.round()),
                ),
                Text(
                  s.minutesUnit(minutes),
                  textAlign: TextAlign.center,
                  style: Theme.of(ctx).textTheme.headlineMedium,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    await ref
                        .read(userProgressProvider.notifier)
                        .logReelsMinutes(minutes);
                    if (ctx.mounted) Navigator.pop(ctx);
                  },
                  child: Text(s.reelsLogSave),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

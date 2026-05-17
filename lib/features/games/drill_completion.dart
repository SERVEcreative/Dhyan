import 'package:dhyan/providers/app_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Quick anti-reel tool finished outside full session.
Future<void> completeStandaloneTool(
  WidgetRef ref, {
  required String tool,
  double inhibitoryDelta = 5,
  double selectiveDelta = 0,
}) async {
  await ref.read(userProgressProvider.notifier).recordQuickTool(
        tool: tool,
        inhibitoryDelta: inhibitoryDelta,
        selectiveDelta: selectiveDelta,
      );
}

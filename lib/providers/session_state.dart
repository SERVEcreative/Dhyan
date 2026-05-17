import 'package:dhyan/data/models/skill_track.dart';
import 'package:dhyan/domain/session_type_meta.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final sessionStillnessProvider = StateProvider<int>((ref) => 0);
final sessionInhibitoryProvider = StateProvider<double>((ref) => 0);
final sessionSelectiveProvider = StateProvider<double>((ref) => 0);
final sessionMinutesProvider = StateProvider<int>((ref) => 3);
final sessionTypeProvider = StateProvider<SessionType>((ref) => SessionType.micro);
final sessionIndexBeforeProvider = StateProvider<double>((ref) => 0);

void resetSessionState(WidgetRef ref) {
  ref.read(sessionStillnessProvider.notifier).state = 0;
  ref.read(sessionInhibitoryProvider.notifier).state = 0;
  ref.read(sessionSelectiveProvider.notifier).state = 0;
  ref.read(sessionMinutesProvider.notifier).state = 3;
}

void beginSession(WidgetRef ref, SessionType type, double indexBefore) {
  ref.read(sessionTypeProvider.notifier).state = type;
  ref.read(sessionIndexBeforeProvider.notifier).state = indexBefore;
  ref.read(sessionMinutesProvider.notifier).state = type.durationMinutes;
  ref.read(sessionStillnessProvider.notifier).state = 0;
  ref.read(sessionInhibitoryProvider.notifier).state = 0;
  ref.read(sessionSelectiveProvider.notifier).state = 0;
}

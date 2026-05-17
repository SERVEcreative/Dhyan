import 'package:dhyan/data/models/skill_track.dart';

extension SessionTypeMeta on SessionType {
  int get durationMinutes => switch (this) {
        SessionType.micro => 3,
        SessionType.quick => 5,
        SessionType.focus7 => 7,
        SessionType.calm => 10,
        SessionType.deep => 12,
        SessionType.extended => 15,
      };

  int get warmupSeconds => switch (this) {
        SessionType.focus7 => 15,
        _ => 30,
      };

  bool get usesMicroDailyLimit =>
      this == SessionType.micro ||
      this == SessionType.quick ||
      this == SessionType.calm;

  bool get usesDeepDailyLimit =>
      this == SessionType.deep || this == SessionType.extended;

  bool get isUniversalPrep => this == SessionType.focus7;

  String get routePath => '/session/$name';

  static const _reservedSegments = {'summary', 'support'};

  static SessionType? fromRoute(String? segment) {
    if (segment == null || _reservedSegments.contains(segment)) {
      return null;
    }
    for (final t in SessionType.values) {
      if (t.name == segment) return t;
    }
    return null;
  }
}

/// Home screen display order — universal prep first.
const sessionDisplayOrder = [
  SessionType.focus7,
  SessionType.micro,
  SessionType.quick,
  SessionType.calm,
  SessionType.deep,
  SessionType.extended,
];

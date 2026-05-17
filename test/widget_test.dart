import 'package:dhyan/app.dart';
import 'package:dhyan/domain/attention_index.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  test('Attention Index weights', () {
    final score = AttentionIndexCalculator.compute(
      maxStillnessSeconds: 150,
      distractionResistRate: 80,
      inhibitoryScore: 60,
      cognitiveScore: 40,
    );
    expect(score, greaterThan(0));
    expect(score, lessThanOrEqualTo(100));
  });

  testWidgets('App renders', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: DhyanApp()));
    await tester.pump();
    expect(find.byType(DhyanApp), findsOneWidget);
  });
}

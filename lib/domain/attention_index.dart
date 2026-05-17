/// Transparent Attention Index: sustained 30%, selective 25%,
/// inhibitory 25%, cognitive 20%.
class AttentionIndexCalculator {
  static double compute({
    required int maxStillnessSeconds,
    required double distractionResistRate,
    required double inhibitoryScore,
    required double cognitiveScore,
  }) {
    final sustained = (maxStillnessSeconds / 300).clamp(0.0, 1.0) * 100;
    final selective = distractionResistRate.clamp(0.0, 100.0);
    final inhibitory = inhibitoryScore.clamp(0.0, 100.0);
    final cognitive = cognitiveScore.clamp(0.0, 100.0);

    return (sustained * 0.30 +
            selective * 0.25 +
            inhibitory * 0.25 +
            cognitive * 0.20)
        .clamp(0.0, 100.0);
  }
}

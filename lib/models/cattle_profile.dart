enum CattleMode { dairy, beef }

enum PregnancyTrimester { none, first, second, third }

class CattleProfile {
  final CattleMode mode;
  final double bodyWeight; // kg
  final double dailyWeightGain; // kg/day

  // Dairy-specific
  final double milkProduction; // liters/day
  final double milkFat; // %
  final double milkProtein; // %
  final double lactometerReading;
  final PregnancyTrimester pregnancyTrimester;

  // Beef-specific
  final int semenCollectionsPerWeek;

  const CattleProfile({
    this.mode = CattleMode.dairy,
    this.bodyWeight = 350,
    this.dailyWeightGain = 0.5,
    this.milkProduction = 10,
    this.milkFat = 4.0,
    this.milkProtein = 3.3,
    this.lactometerReading = 28,
    this.pregnancyTrimester = PregnancyTrimester.none,
    this.semenCollectionsPerWeek = 0,
  });

  double get snf {
    // SNF = (LR / 4) + (0.21 * Fat) + 0.36
    return (lactometerReading / 4) + (0.21 * milkFat) + 0.36;
  }

  CattleProfile copyWith({
    CattleMode? mode,
    double? bodyWeight,
    double? dailyWeightGain,
    double? milkProduction,
    double? milkFat,
    double? milkProtein,
    double? lactometerReading,
    PregnancyTrimester? pregnancyTrimester,
    int? semenCollectionsPerWeek,
  }) {
    return CattleProfile(
      mode: mode ?? this.mode,
      bodyWeight: bodyWeight ?? this.bodyWeight,
      dailyWeightGain: dailyWeightGain ?? this.dailyWeightGain,
      milkProduction: milkProduction ?? this.milkProduction,
      milkFat: milkFat ?? this.milkFat,
      milkProtein: milkProtein ?? this.milkProtein,
      lactometerReading: lactometerReading ?? this.lactometerReading,
      pregnancyTrimester: pregnancyTrimester ?? this.pregnancyTrimester,
      semenCollectionsPerWeek:
          semenCollectionsPerWeek ?? this.semenCollectionsPerWeek,
    );
  }
}

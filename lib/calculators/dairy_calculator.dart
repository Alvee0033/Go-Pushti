import 'dart:math';
import '../models/cattle_profile.dart';

class DairyCalculator {
  /// ME for Maintenance (MJ/day)
  /// Formula: (0.53 × (BW / 1.08)^0.67 + Activity) / Km
  double calculateMEMaintenance(double bodyWeight) {
    final double fhp = 0.53 * pow(bodyWeight / 1.08, 0.67);
    final double activityAllowance = 0.0095 * bodyWeight;
    const double km = 0.72; // efficiency of ME use for maintenance
    return (fhp + activityAllowance) / km;
  }

  /// ME for Lactation (MJ/day)
  /// EVl = 0.0386 × Fat + 0.0205 × SNF − 0.236
  double calculateMELactation(double milkLiters, double fatPct, double snf) {
    if (milkLiters <= 0) return 0;
    final double evl = (0.0386 * fatPct) + (0.0205 * snf) - 0.236;
    final double totalNEl = evl * milkLiters;
    const double kl = 0.61; // efficiency of ME for lactation
    return totalNEl / kl;
  }

  /// ME for Growth / Weight Gain (MJ/day)
  double calculateMEGrowth(double bodyWeight, double dailyGain) {
    if (dailyGain <= 0) return 0;
    // NE_g ≈ (4.1 + 0.0332 × BW − 0.000009 × BW²) × DWG^1.097
    final double neG =
        (4.1 + 0.0332 * bodyWeight - 0.000009 * bodyWeight * bodyWeight) *
        pow(dailyGain, 1.097);
    const double kg = 0.40;
    return neG / kg;
  }

  /// ME for Pregnancy (MJ/day)
  double calculateMEPregnancy(PregnancyTrimester trimester) {
    switch (trimester) {
      case PregnancyTrimester.none:
        return 0;
      case PregnancyTrimester.first:
        return 1.5;
      case PregnancyTrimester.second:
        return 6.0;
      case PregnancyTrimester.third:
        return 16.0;
    }
  }

  /// Metabolizable Protein for Maintenance (g/day)
  double calculateMPMaintenance(double bodyWeight) {
    return 2.9 * pow(bodyWeight, 0.75);
  }

  /// MP for Lactation (g/day)
  double calculateMPLactation(double milkLiters, double milkProteinPct) {
    if (milkLiters <= 0) return 0;
    return milkLiters * milkProteinPct * 10 / 0.68;
  }

  /// MP for Growth (g/day)
  double calculateMPGrowth(double bodyWeight, double dailyGain) {
    if (dailyGain <= 0) return 0;
    // simplified: 168 × DWG − 0.1 × DWG × BW/100
    return 168 * dailyGain - 0.1 * dailyGain * bodyWeight / 100;
  }

  /// Total ME Required (MJ/day)
  double totalME(CattleProfile p) {
    return calculateMEMaintenance(p.bodyWeight) +
        calculateMELactation(p.milkProduction, p.milkFat, p.snf) +
        calculateMEGrowth(p.bodyWeight, p.dailyWeightGain) +
        calculateMEPregnancy(p.pregnancyTrimester);
  }

  /// Total CP / MP Required (g/day)
  double totalCP(CattleProfile p) {
    return calculateMPMaintenance(p.bodyWeight) +
        calculateMPLactation(p.milkProduction, p.milkProtein) +
        calculateMPGrowth(p.bodyWeight, p.dailyWeightGain);
  }

  /// Suggested DM Intake (kg/day) — ~2.5–3% of BW
  double suggestedDMIntake(double bodyWeight) {
    return bodyWeight * 0.028; // 2.8% midpoint
  }

  /// Calculate SNF from Lactometer Reading & Fat
  double calculateSNF(double lr, double fat) {
    return (lr / 4) + (0.21 * fat) + 0.36;
  }
}

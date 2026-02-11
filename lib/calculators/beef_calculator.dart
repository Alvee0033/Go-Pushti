import 'dart:math';
import '../models/cattle_profile.dart';

class BeefCalculator {
  /// ME for Maintenance (MJ/day)
  /// AFRC Beef: 8.3 + 0.091 × BW
  double calculateMEMaintenance(double bodyWeight) {
    return 8.3 + 0.091 * bodyWeight;
  }

  /// ME for Growth / Weight Gain (MJ/day)
  double calculateMEGrowth(double bodyWeight, double dailyGain) {
    if (dailyGain <= 0) return 0;
    // NE_g ≈ (6.28 + 0.0188 × BW) × DWG^1.097
    final double neG =
        (6.28 + 0.0188 * bodyWeight) * pow(dailyGain, 1.097);
    const double kg = 0.40;
    return neG / kg;
  }

  /// ME for Semen Collection — additional MJ per collection per week
  double calculateMESemen(int collectionsPerWeek) {
    if (collectionsPerWeek <= 0) return 0;
    return collectionsPerWeek * 6.0 / 7; // spread daily
  }

  /// CP for Maintenance (g/day)
  double calculateMPMaintenance(double bodyWeight) {
    return 3.1 * pow(bodyWeight, 0.75);
  }

  /// CP for Growth (g/day)
  double calculateMPGrowth(double bodyWeight, double dailyGain) {
    if (dailyGain <= 0) return 0;
    return 200 * dailyGain - 0.1 * dailyGain * bodyWeight / 100;
  }

  /// CP for Semen (g/day)
  double calculateMPSemen(int collectionsPerWeek) {
    if (collectionsPerWeek <= 0) return 0;
    return collectionsPerWeek * 30 / 7;
  }

  /// Total ME Required (MJ/day)
  double totalME(CattleProfile p) {
    return calculateMEMaintenance(p.bodyWeight) +
        calculateMEGrowth(p.bodyWeight, p.dailyWeightGain) +
        calculateMESemen(p.semenCollectionsPerWeek);
  }

  /// Total CP Required (g/day)
  double totalCP(CattleProfile p) {
    return calculateMPMaintenance(p.bodyWeight) +
        calculateMPGrowth(p.bodyWeight, p.dailyWeightGain) +
        calculateMPSemen(p.semenCollectionsPerWeek);
  }

  /// Suggested DM Intake (kg/day)
  double suggestedDMIntake(double bodyWeight) {
    return bodyWeight * 0.025; // 2.5% of BW for beef
  }
}

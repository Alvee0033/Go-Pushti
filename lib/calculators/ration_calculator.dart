import '../models/ingredient.dart';
import '../models/cattle_profile.dart';
import '../models/ration_result.dart';
import 'dairy_calculator.dart';
import 'beef_calculator.dart';

class RationCalculator {
  final DairyCalculator _dairy = DairyCalculator();
  final BeefCalculator _beef = BeefCalculator();

  RationResult calculate(CattleProfile profile, List<Ingredient> ingredients) {
    final bool isDairy = profile.mode == CattleMode.dairy;

    // ── Requirement calculations ──
    double meMaint, meLact, meGrowth, mePreg;
    double cpMaint, cpLact, cpGrowth;

    if (isDairy) {
      meMaint = _dairy.calculateMEMaintenance(profile.bodyWeight);
      meLact = _dairy.calculateMELactation(
        profile.milkProduction,
        profile.milkFat,
        profile.snf,
      );
      meGrowth = _dairy.calculateMEGrowth(
        profile.bodyWeight,
        profile.dailyWeightGain,
      );
      mePreg = _dairy.calculateMEPregnancy(profile.pregnancyTrimester);
      cpMaint = _dairy.calculateMPMaintenance(profile.bodyWeight);
      cpLact = _dairy.calculateMPLactation(
        profile.milkProduction,
        profile.milkProtein,
      );
      cpGrowth = _dairy.calculateMPGrowth(
        profile.bodyWeight,
        profile.dailyWeightGain,
      );
    } else {
      meMaint = _beef.calculateMEMaintenance(profile.bodyWeight);
      meLact = 0;
      meGrowth = _beef.calculateMEGrowth(
        profile.bodyWeight,
        profile.dailyWeightGain,
      );
      mePreg = _beef.calculateMESemen(profile.semenCollectionsPerWeek);
      cpMaint = _beef.calculateMPMaintenance(profile.bodyWeight);
      cpLact = _beef.calculateMPSemen(profile.semenCollectionsPerWeek);
      cpGrowth = _beef.calculateMPGrowth(
        profile.bodyWeight,
        profile.dailyWeightGain,
      );
    }

    final double requiredME = meMaint + meLact + meGrowth + mePreg;
    final double requiredCP = cpMaint + cpLact + cpGrowth;

    // ── Total DM Intake ──
    final double totalDMIntake =
        isDairy
            ? _dairy.suggestedDMIntake(profile.bodyWeight)
            : _beef.suggestedDMIntake(profile.bodyWeight);

    // ── Supply calculations from ingredients ──
    double suppliedME = 0;
    double suppliedCP = 0;
    double totalCost = 0;
    final List<TmrItem> tmr = [];

    for (final item in ingredients) {
      if (item.inclusionRate <= 0) continue;

      // FIX: Use slider value directly as percentage of total diet.
      // Do not normalize to 100%. If sliders sum to 20%, cow eats 20% of capacity.
      final double fraction = item.inclusionRate / 100.0;
      
      final double kgDM = totalDMIntake * fraction;
      final double kgAsFed =
          item.dryMatterPercent > 0 ? kgDM / (item.dryMatterPercent / 100) : 0;
      final double itemCost = kgAsFed * item.pricePerKg;

      suppliedME += kgDM * item.mePerKgDM;
      suppliedCP += kgDM * (item.cpPercentDM / 100) * 1000; // g
      totalCost += itemCost;

      tmr.add(
        TmrItem(name: item.name, nameBn: item.nameBn, kgAsFed: kgAsFed, kgDM: kgDM, cost: itemCost),
      );
    }

    final double costPerKgMilk =
        (isDairy && profile.milkProduction > 0)
            ? totalCost / profile.milkProduction
            : 0;

    return RationResult(
      requiredME: requiredME,
      suppliedME: suppliedME,
      requiredCP: requiredCP,
      suppliedCP: suppliedCP,
      totalDMIntake: totalDMIntake,
      totalCostPerDay: totalCost,
      feedCostPerKgMilk: costPerKgMilk,
      tmrBreakdown: tmr,
      meMaintenance: meMaint,
      meLactation: meLact,
      meGrowth: meGrowth,
      mePregnancy: mePreg,
      cpMaintenance: cpMaint,
      cpLactation: cpLact,
      cpGrowth: cpGrowth,
    );
  }
}

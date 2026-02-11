class TmrItem {
  final String name;
  final String nameBn;
  final double kgAsFed;
  final double kgDM;
  final double cost;

  const TmrItem({
    required this.name,
    this.nameBn = '',
    required this.kgAsFed,
    required this.kgDM,
    required this.cost,
  });

  String displayName(bool isBengali) =>
      isBengali && nameBn.isNotEmpty ? nameBn : name;
}

class RationResult {
  final double requiredME; // MJ/day
  final double suppliedME; // MJ/day
  final double requiredCP; // g/day
  final double suppliedCP; // g/day
  final double totalDMIntake; // kg/day
  final double totalCostPerDay; // Tk
  final double feedCostPerKgMilk; // Tk (0 for beef)
  final List<TmrItem> tmrBreakdown;

  // Sub-components for display
  final double meMaintenance;
  final double meLactation;
  final double meGrowth;
  final double mePregnancy;
  final double cpMaintenance;
  final double cpLactation;
  final double cpGrowth;

  const RationResult({
    required this.requiredME,
    required this.suppliedME,
    required this.requiredCP,
    required this.suppliedCP,
    required this.totalDMIntake,
    required this.totalCostPerDay,
    required this.feedCostPerKgMilk,
    required this.tmrBreakdown,
    this.meMaintenance = 0,
    this.meLactation = 0,
    this.meGrowth = 0,
    this.mePregnancy = 0,
    this.cpMaintenance = 0,
    this.cpLactation = 0,
    this.cpGrowth = 0,
  });

  double get meBalance => suppliedME - requiredME;
  double get cpBalance => suppliedCP - requiredCP;
  bool get meIsMet => suppliedME >= requiredME;
  bool get cpIsMet => suppliedCP >= requiredCP;
}

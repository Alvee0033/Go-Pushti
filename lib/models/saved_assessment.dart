import 'dart:convert';

class SavedIngredient {
  final String name;
  final double kgAsFed;
  final double cost;

  SavedIngredient({
    required this.name,
    required this.kgAsFed,
    required this.cost,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'kgAsFed': kgAsFed,
        'cost': cost,
      };

  factory SavedIngredient.fromJson(Map<String, dynamic> json) {
    return SavedIngredient(
      name: json['name'] as String,
      kgAsFed: (json['kgAsFed'] as num).toDouble(),
      cost: (json['cost'] as num).toDouble(),
    );
  }
}

/// A saved assessment result that can be persisted to local storage.
class SavedAssessment {
  final String id;
  final String cattleName;
  final String mode; // 'dairy' or 'beef'
  final DateTime createdAt;

  // Key results
  final double totalCostPerDay;
  final double costPerKgMilk;
  final double requiredME;
  final double suppliedME;
  final double requiredCP;
  final double suppliedCP;
  final double totalDMIntake;

  // Breakdown fields
  final double meMaintenance;
  final double meLactation;
  final double meGrowth;
  final double mePregnancy;

  // Profile snapshot
  final double bodyWeight;
  final double milkProduction;

  // Recipe
  final List<SavedIngredient> ingredients;

  const SavedAssessment({
    required this.id,
    required this.cattleName,
    required this.mode,
    required this.createdAt,
    required this.totalCostPerDay,
    required this.costPerKgMilk,
    required this.requiredME,
    required this.suppliedME,
    required this.requiredCP,
    required this.suppliedCP,
    required this.totalDMIntake,
    required this.bodyWeight,
    required this.milkProduction,
    required this.ingredients,
    this.meMaintenance = 0,
    this.meLactation = 0,
    this.meGrowth = 0,
    this.mePregnancy = 0,
  });

  bool get meIsMet => suppliedME >= requiredME;
  bool get cpIsMet => suppliedCP >= requiredCP;
  bool get isDairy => mode == 'dairy';

  Map<String, dynamic> toJson() => {
        'id': id,
        'cattleName': cattleName,
        'mode': mode,
        'createdAt': createdAt.toIso8601String(),
        'totalCostPerDay': totalCostPerDay,
        'costPerKgMilk': costPerKgMilk,
        'requiredME': requiredME,
        'suppliedME': suppliedME,
        'requiredCP': requiredCP,
        'suppliedCP': suppliedCP,
        'totalDMIntake': totalDMIntake,
        'bodyWeight': bodyWeight,
        'milkProduction': milkProduction,
        'meMaintenance': meMaintenance,
        'meLactation': meLactation,
        'meGrowth': meGrowth,
        'mePregnancy': mePregnancy,
        'ingredients': ingredients.map((i) => i.toJson()).toList(),
      };

  factory SavedAssessment.fromJson(Map<String, dynamic> json) {
    return SavedAssessment(
      id: json['id'] as String,
      cattleName: json['cattleName'] as String,
      mode: json['mode'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      totalCostPerDay: (json['totalCostPerDay'] as num).toDouble(),
      costPerKgMilk: (json['costPerKgMilk'] as num).toDouble(),
      requiredME: (json['requiredME'] as num).toDouble(),
      suppliedME: (json['suppliedME'] as num).toDouble(),
      requiredCP: (json['requiredCP'] as num).toDouble(),
      suppliedCP: (json['suppliedCP'] as num).toDouble(),
      totalDMIntake: (json['totalDMIntake'] as num).toDouble(),
      bodyWeight: (json['bodyWeight'] as num).toDouble(),
      milkProduction: (json['milkProduction'] as num).toDouble(),
      meMaintenance: (json['meMaintenance'] as num?)?.toDouble() ?? 0,
      meLactation: (json['meLactation'] as num?)?.toDouble() ?? 0,
      meGrowth: (json['meGrowth'] as num?)?.toDouble() ?? 0,
      mePregnancy: (json['mePregnancy'] as num?)?.toDouble() ?? 0,
      ingredients: (json['ingredients'] as List<dynamic>?)
              ?.map((i) => SavedIngredient.fromJson(i as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  String toJsonString() => jsonEncode(toJson());

  factory SavedAssessment.fromJsonString(String s) =>
      SavedAssessment.fromJson(jsonDecode(s) as Map<String, dynamic>);
}

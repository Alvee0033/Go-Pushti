class Ingredient {
  final String name;
  final String nameBn; // Bengali name
  final String category; // 'Roughage', 'Concentrate', 'Additive'
  final double dryMatterPercent;
  final double mePerKgDM; // MJ/kg DM
  final double cpPercentDM; // % of DM
  double pricePerKg; // Tk/kg — editable
  double inclusionRate; // % of total diet DM

  Ingredient({
    required this.name,
    this.nameBn = '',
    required this.category,
    required this.dryMatterPercent,
    required this.mePerKgDM,
    required this.cpPercentDM,
    required this.pricePerKg,
    this.inclusionRate = 0,
  });

  /// Returns Bengali or English name based on flag
  String displayName(bool isBengali) =>
      isBengali && nameBn.isNotEmpty ? nameBn : name;

  double get pricePerKgDM =>
      dryMatterPercent > 0 ? pricePerKg / (dryMatterPercent / 100) : 0;

  Ingredient copyWith({
    String? name,
    String? nameBn,
    String? category,
    double? dryMatterPercent,
    double? mePerKgDM,
    double? cpPercentDM,
    double? pricePerKg,
    double? inclusionRate,
  }) {
    return Ingredient(
      name: name ?? this.name,
      nameBn: nameBn ?? this.nameBn,
      category: category ?? this.category,
      dryMatterPercent: dryMatterPercent ?? this.dryMatterPercent,
      mePerKgDM: mePerKgDM ?? this.mePerKgDM,
      cpPercentDM: cpPercentDM ?? this.cpPercentDM,
      pricePerKg: pricePerKg ?? this.pricePerKg,
      inclusionRate: inclusionRate ?? this.inclusionRate,
    );
  }
}

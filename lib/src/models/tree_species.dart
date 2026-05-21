class TreeSpecies {
  const TreeSpecies({
    required this.name,
    required this.hindiName,
    required this.densityKgPerM3,
    required this.freshMoistureFactor,
    required this.dryMatterRatio,
    required this.timberRatePerKg,
    required this.carbonRatio,
  });

  final String name;
  final String hindiName;
  final double densityKgPerM3;
  final double freshMoistureFactor;
  final double dryMatterRatio;
  final double timberRatePerKg;
  final double carbonRatio;

  String label(String languageCode) => languageCode == 'hi' ? hindiName : name;
}

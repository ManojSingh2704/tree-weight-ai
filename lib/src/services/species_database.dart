import '../models/tree_species.dart';

class SpeciesDatabase {
  static const List<TreeSpecies> species = [
    TreeSpecies(
      name: 'Poplar',
      hindiName: 'पॉपलर',
      densityKgPerM3: 385,
      freshMoistureFactor: 1.45,
      dryMatterRatio: 0.62,
      timberRatePerKg: 7.5,
      carbonRatio: 0.47,
    ),
    TreeSpecies(
      name: 'Eucalyptus',
      hindiName: 'यूकेलिप्टस',
      densityKgPerM3: 610,
      freshMoistureFactor: 1.35,
      dryMatterRatio: 0.68,
      timberRatePerKg: 6.8,
      carbonRatio: 0.48,
    ),
    TreeSpecies(
      name: 'Neem',
      hindiName: 'नीम',
      densityKgPerM3: 720,
      freshMoistureFactor: 1.28,
      dryMatterRatio: 0.7,
      timberRatePerKg: 10.0,
      carbonRatio: 0.49,
    ),
    TreeSpecies(
      name: 'Mango',
      hindiName: 'आम',
      densityKgPerM3: 560,
      freshMoistureFactor: 1.32,
      dryMatterRatio: 0.66,
      timberRatePerKg: 8.5,
      carbonRatio: 0.47,
    ),
    TreeSpecies(
      name: 'Teak',
      hindiName: 'सागौन',
      densityKgPerM3: 650,
      freshMoistureFactor: 1.22,
      dryMatterRatio: 0.72,
      timberRatePerKg: 35.0,
      carbonRatio: 0.5,
    ),
    TreeSpecies(
      name: 'Bamboo',
      hindiName: 'बांस',
      densityKgPerM3: 500,
      freshMoistureFactor: 1.5,
      dryMatterRatio: 0.58,
      timberRatePerKg: 5.5,
      carbonRatio: 0.46,
    ),
  ];

  TreeSpecies byName(String value) {
    final normalized = value.toLowerCase().trim();
    return species.firstWhere(
      (item) => item.name.toLowerCase() == normalized || item.hindiName == value,
      orElse: () => species.first,
    );
  }

  TreeSpecies guessFromHint(String hint) {
    final normalized = hint.toLowerCase().trim();
    if (normalized.isEmpty) return species.first;
    return species.firstWhere(
      (item) => normalized.contains(item.name.toLowerCase()) || hint.contains(item.hindiName),
      orElse: () => species.first,
    );
  }
}

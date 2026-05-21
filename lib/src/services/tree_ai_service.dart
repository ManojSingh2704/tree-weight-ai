import 'dart:math';

import 'species_database.dart';

class SpeciesPrediction {
  const SpeciesPrediction({required this.speciesName, required this.confidence});

  final String speciesName;
  final double confidence;
}

class TreeAiService {
  TreeAiService({SpeciesDatabase? speciesDatabase}) : _speciesDatabase = speciesDatabase ?? SpeciesDatabase();

  final SpeciesDatabase _speciesDatabase;

  Future<SpeciesPrediction> identifySpecies({
    required String speciesHint,
    String? frontImagePath,
    String? sideImagePath,
  }) async {
    // Production integration point:
    // 1. Run YOLO/TFLite tree detector on front/side frames.
    // 2. Crop leaves, bark and canopy.
    // 3. Run TFLite species classifier.
    // 4. Fuse model confidence with user hint and regional species prior.
    final species = _speciesDatabase.guessFromHint(speciesHint);
    final confidence = speciesHint.trim().isEmpty ? 0.72 : 0.88 + min(speciesHint.length, 10) * 0.006;
    return SpeciesPrediction(speciesName: species.name, confidence: (confidence.clamp(0.65, 0.96) * 100).toDouble());
  }
}

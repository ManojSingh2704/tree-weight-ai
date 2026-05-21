import 'dart:math';

import 'package:uuid/uuid.dart';

import '../models/tree_scan.dart';
import '../models/tree_species.dart';
import 'feedback_learning_service.dart';

class TreeEstimatorInput {
  const TreeEstimatorInput({
    required this.species,
    required this.heightFeet,
    required this.diameterInches,
    required this.distanceFeet,
    required this.farmName,
    required this.plotDetails,
    required this.previousScans,
    this.speciesConfidence,
    this.latitude,
    this.longitude,
    this.frontImagePath,
    this.sideImagePath,
  });

  final TreeSpecies species;
  final double heightFeet;
  final double diameterInches;
  final double distanceFeet;
  final String farmName;
  final String plotDetails;
  final List<TreeScan> previousScans;
  final double? speciesConfidence;
  final double? latitude;
  final double? longitude;
  final String? frontImagePath;
  final String? sideImagePath;
}

class TreeEstimator {
  TreeEstimator({FeedbackLearningService? feedbackLearning})
      : _feedbackLearning = feedbackLearning ?? FeedbackLearningService();

  final FeedbackLearningService _feedbackLearning;
  static const _uuid = Uuid();

  TreeScan estimate(TreeEstimatorInput input) {
    final diameterMeters = input.diameterInches * 0.0254;
    final heightMeters = input.heightFeet * 0.3048;
    final basalArea = pi * pow(diameterMeters / 2, 2);

    // Forestry approximation: form factor accounts for taper and non-cylindrical trunk shape.
    final formFactor = input.species.name == 'Bamboo' ? 0.42 : 0.48;
    final woodVolumeM3 = basalArea * heightMeters * formFactor;
    final correction = _feedbackLearning.correctionFactorFor(input.previousScans, input.species.name);
    final baseWeight = woodVolumeM3 * input.species.densityKgPerM3 * correction;
    final freshWeight = baseWeight * input.species.freshMoistureFactor;
    final dryWeight = freshWeight * input.species.dryMatterRatio;
    final biomass = dryWeight * 1.18;
    final carbon = biomass * input.species.carbonRatio;
    final timberValue = baseWeight * input.species.timberRatePerKg;

    final confidence = input.speciesConfidence ?? _confidence(input);

    return TreeScan(
      id: _uuid.v4(),
      createdAt: DateTime.now(),
      species: input.species.name,
      confidence: confidence,
      heightFeet: input.heightFeet,
      diameterInches: input.diameterInches,
      distanceFeet: input.distanceFeet,
      woodVolumeM3: woodVolumeM3,
      estimatedWeightKg: baseWeight,
      freshWeightKg: freshWeight,
      dryWeightKg: dryWeight,
      biomassKg: biomass,
      carbonKg: carbon,
      timberValue: timberValue,
      farmName: input.farmName,
      plotDetails: input.plotDetails,
      latitude: input.latitude,
      longitude: input.longitude,
      frontImagePath: input.frontImagePath,
      sideImagePath: input.sideImagePath,
    );
  }

  double _confidence(TreeEstimatorInput input) {
    var score = 0.72;
    if (input.frontImagePath != null) score += 0.06;
    if (input.sideImagePath != null) score += 0.06;
    if (input.distanceFeet > 3) score += 0.04;
    if (input.heightFeet > 4 && input.diameterInches > 1) score += 0.08;
    return (score * 100).clamp(55, 96).toDouble();
  }
}

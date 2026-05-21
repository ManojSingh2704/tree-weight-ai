import 'dart:convert';

class TreeScan {
  TreeScan({
    required this.id,
    required this.createdAt,
    required this.species,
    required this.confidence,
    required this.heightFeet,
    required this.diameterInches,
    required this.distanceFeet,
    required this.woodVolumeM3,
    required this.estimatedWeightKg,
    required this.freshWeightKg,
    required this.dryWeightKg,
    required this.biomassKg,
    required this.carbonKg,
    required this.timberValue,
    required this.farmName,
    required this.plotDetails,
    this.latitude,
    this.longitude,
    this.frontImagePath,
    this.sideImagePath,
    this.actualWeightKg,
  });

  final String id;
  final DateTime createdAt;
  final String species;
  final double confidence;
  final double heightFeet;
  final double diameterInches;
  final double distanceFeet;
  final double woodVolumeM3;
  final double estimatedWeightKg;
  final double freshWeightKg;
  final double dryWeightKg;
  final double biomassKg;
  final double carbonKg;
  final double timberValue;
  final String farmName;
  final String plotDetails;
  final double? latitude;
  final double? longitude;
  final String? frontImagePath;
  final String? sideImagePath;
  final double? actualWeightKg;

  double? get errorKg => actualWeightKg == null ? null : actualWeightKg! - estimatedWeightKg;

  double? get accuracyPercent {
    if (actualWeightKg == null || actualWeightKg == 0) return null;
    final error = (estimatedWeightKg - actualWeightKg!).abs();
    return (100 - ((error / actualWeightKg!) * 100)).clamp(0, 100);
  }

  TreeScan copyWith({double? actualWeightKg}) {
    return TreeScan(
      id: id,
      createdAt: createdAt,
      species: species,
      confidence: confidence,
      heightFeet: heightFeet,
      diameterInches: diameterInches,
      distanceFeet: distanceFeet,
      woodVolumeM3: woodVolumeM3,
      estimatedWeightKg: estimatedWeightKg,
      freshWeightKg: freshWeightKg,
      dryWeightKg: dryWeightKg,
      biomassKg: biomassKg,
      carbonKg: carbonKg,
      timberValue: timberValue,
      farmName: farmName,
      plotDetails: plotDetails,
      latitude: latitude,
      longitude: longitude,
      frontImagePath: frontImagePath,
      sideImagePath: sideImagePath,
      actualWeightKg: actualWeightKg ?? this.actualWeightKg,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'createdAt': createdAt.toIso8601String(),
        'species': species,
        'confidence': confidence,
        'heightFeet': heightFeet,
        'diameterInches': diameterInches,
        'distanceFeet': distanceFeet,
        'woodVolumeM3': woodVolumeM3,
        'estimatedWeightKg': estimatedWeightKg,
        'freshWeightKg': freshWeightKg,
        'dryWeightKg': dryWeightKg,
        'biomassKg': biomassKg,
        'carbonKg': carbonKg,
        'timberValue': timberValue,
        'farmName': farmName,
        'plotDetails': plotDetails,
        'latitude': latitude,
        'longitude': longitude,
        'frontImagePath': frontImagePath,
        'sideImagePath': sideImagePath,
        'actualWeightKg': actualWeightKg,
      };

  factory TreeScan.fromMap(Map<String, dynamic> map) {
    double readDouble(String key) => (map[key] as num?)?.toDouble() ?? 0;
    return TreeScan(
      id: map['id'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      species: map['species'] as String,
      confidence: readDouble('confidence'),
      heightFeet: readDouble('heightFeet'),
      diameterInches: readDouble('diameterInches'),
      distanceFeet: readDouble('distanceFeet'),
      woodVolumeM3: readDouble('woodVolumeM3'),
      estimatedWeightKg: readDouble('estimatedWeightKg'),
      freshWeightKg: readDouble('freshWeightKg'),
      dryWeightKg: readDouble('dryWeightKg'),
      biomassKg: readDouble('biomassKg'),
      carbonKg: readDouble('carbonKg'),
      timberValue: readDouble('timberValue'),
      farmName: map['farmName'] as String? ?? '',
      plotDetails: map['plotDetails'] as String? ?? '',
      latitude: (map['latitude'] as num?)?.toDouble(),
      longitude: (map['longitude'] as num?)?.toDouble(),
      frontImagePath: map['frontImagePath'] as String?,
      sideImagePath: map['sideImagePath'] as String?,
      actualWeightKg: (map['actualWeightKg'] as num?)?.toDouble(),
    );
  }

  String toJson() => jsonEncode(toMap());

  factory TreeScan.fromJson(String source) => TreeScan.fromMap(jsonDecode(source) as Map<String, dynamic>);
}

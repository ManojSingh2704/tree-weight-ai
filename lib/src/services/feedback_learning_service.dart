import '../models/tree_scan.dart';

class FeedbackLearningService {
  double correctionFactorFor(List<TreeScan> scans, String species) {
    final feedback = scans.where((scan) => scan.species == species && scan.actualWeightKg != null).toList();
    if (feedback.isEmpty) return 1;

    final ratios = feedback.map((scan) => scan.actualWeightKg! / scan.estimatedWeightKg).where((ratio) => ratio.isFinite);
    if (ratios.isEmpty) return 1;
    final average = ratios.reduce((a, b) => a + b) / ratios.length;
    return average.clamp(0.65, 1.35).toDouble();
  }
}

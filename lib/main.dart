import 'package:flutter/material.dart';

import 'src/app/tree_weight_ai_app.dart';
import 'src/services/local_scan_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final repository = LocalScanRepository();
  await repository.init();
  runApp(TreeWeightAiApp(repository: repository));
}

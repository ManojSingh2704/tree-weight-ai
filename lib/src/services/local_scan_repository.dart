import 'package:shared_preferences/shared_preferences.dart';

import '../models/tree_scan.dart';

class LocalScanRepository {
  static const _key = 'tree_scans_v1';
  late SharedPreferences _preferences;

  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  List<TreeScan> getScans() {
    final values = _preferences.getStringList(_key) ?? [];
    return values.map(TreeScan.fromJson).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<void> saveScan(TreeScan scan) async {
    final scans = getScans();
    final index = scans.indexWhere((item) => item.id == scan.id);
    if (index >= 0) {
      scans[index] = scan;
    } else {
      scans.insert(0, scan);
    }
    await _preferences.setStringList(_key, scans.map((scan) => scan.toJson()).toList());
  }

  Future<void> clear() async {
    await _preferences.remove(_key);
  }
}

import 'package:flutter/material.dart';

import '../i18n/app_localizations.dart';
import '../models/tree_scan.dart';
import '../services/local_scan_repository.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key, required this.repository, required this.scan});

  final LocalScanRepository repository;
  final TreeScan scan;

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late TreeScan _scan;
  final _actual = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scan = widget.scan;
  }

  Future<void> _saveFeedback() async {
    final actual = double.tryParse(_actual.text);
    if (actual == null || actual <= 0) return;
    final updated = _scan.copyWith(actualWeightKg: actual);
    await widget.repository.saveScan(updated);
    setState(() => _scan = updated);
  }

  @override
  void dispose() {
    _actual.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.tr('result'), style: const TextStyle(fontWeight: FontWeight.w900))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${context.tr('species')}: ${_scan.species}', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900)),
                  const SizedBox(height: 6),
                  Text('${context.tr('confidence')}: ${_scan.confidence.toStringAsFixed(0)}%'),
                  const Divider(height: 28),
                  _Row(label: context.tr('height'), value: '${_scan.heightFeet.toStringAsFixed(1)} ${context.tr('feet')}'),
                  _Row(label: context.tr('diameter'), value: '${_scan.diameterInches.toStringAsFixed(1)} ${context.tr('inches')}'),
                  _Row(label: context.tr('woodVolume'), value: '${_scan.woodVolumeM3.toStringAsFixed(3)} m³'),
                  _Row(label: context.tr('weight'), value: '${_scan.estimatedWeightKg.toStringAsFixed(1)} ${context.tr('kg')}'),
                  _Row(label: context.tr('freshWeight'), value: '${_scan.freshWeightKg.toStringAsFixed(1)} ${context.tr('kg')}'),
                  _Row(label: context.tr('dryWeight'), value: '${_scan.dryWeightKg.toStringAsFixed(1)} ${context.tr('kg')}'),
                  _Row(label: context.tr('biomass'), value: '${_scan.biomassKg.toStringAsFixed(1)} ${context.tr('kg')}'),
                  _Row(label: context.tr('carbon'), value: '${_scan.carbonKg.toStringAsFixed(1)} ${context.tr('kg')}'),
                  _Row(label: context.tr('timberValue'), value: '₹${_scan.timberValue.toStringAsFixed(0)}'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(context.tr('feedback'), style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
                  const SizedBox(height: 12),
                  TextField(controller: _actual, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: context.tr('actualWeight'))),
                  const SizedBox(height: 12),
                  FilledButton.icon(onPressed: _saveFeedback, icon: const Icon(Icons.school), label: Text(context.tr('saveFeedback'))),
                  if (_scan.actualWeightKg != null) ...[
                    const SizedBox(height: 12),
                    Text('${context.tr('accuracy')}: ${_scan.accuracyPercent?.toStringAsFixed(1)}%'),
                    Text('Error: ${_scan.errorKg?.toStringAsFixed(1)} ${context.tr('kg')}'),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(child: Text(label, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant))),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}

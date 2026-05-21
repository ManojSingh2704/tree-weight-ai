import 'package:flutter/material.dart';

import '../i18n/app_localizations.dart';
import '../models/tree_scan.dart';
import '../services/local_scan_repository.dart';
import '../widgets/metric_card.dart';
import 'history_screen.dart';
import 'scanner_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({
    super.key,
    required this.repository,
    required this.locale,
    required this.onLocaleChanged,
  });

  final LocalScanRepository repository;
  final Locale locale;
  final ValueChanged<Locale> onLocaleChanged;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<TreeScan> _scans = [];

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  void _refresh() {
    setState(() => _scans = widget.repository.getScans());
  }

  Future<void> _openScanner() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ScannerScreen(repository: widget.repository),
      ),
    );
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    final totalWeight = _scans.fold<double>(0, (sum, scan) => sum + scan.estimatedWeightKg);
    final totalValue = _scans.fold<double>(0, (sum, scan) => sum + scan.timberValue);
    final totalCarbon = _scans.fold<double>(0, (sum, scan) => sum + scan.carbonKg);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('appName'), style: const TextStyle(fontWeight: FontWeight.w900)),
        actions: [
          TextButton(
            onPressed: () => widget.onLocaleChanged(widget.locale.languageCode == 'hi' ? const Locale('en') : const Locale('hi')),
            child: Text(context.tr('language'), style: const TextStyle(fontWeight: FontWeight.w900)),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => _refresh(),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
          children: [
            _HeroPanel(onScan: _openScanner),
            const SizedBox(height: 16),
            Text(context.tr('dashboard'), style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: MediaQuery.sizeOf(context).width > 700 ? 4 : 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.05,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                MetricCard(label: context.tr('totalTrees'), value: '${_scans.length}', icon: Icons.park),
                MetricCard(label: context.tr('estimatedWood'), value: '${totalWeight.toStringAsFixed(0)} ${context.tr('kg')}', icon: Icons.forest),
                MetricCard(label: context.tr('estimatedValue'), value: '₹${totalValue.toStringAsFixed(0)}', icon: Icons.currency_rupee),
                MetricCard(label: context.tr('carbonValue'), value: '${totalCarbon.toStringAsFixed(0)} ${context.tr('kg')}', icon: Icons.eco),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(child: Text(context.tr('history'), style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900))),
                TextButton.icon(
                  onPressed: () async {
                    await Navigator.of(context).push(MaterialPageRoute(builder: (_) => HistoryScreen(repository: widget.repository)));
                    _refresh();
                  },
                  icon: const Icon(Icons.history),
                  label: Text(context.tr('history')),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (_scans.isEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Text(context.tr('emptyHistory')),
                ),
              )
            else
              ..._scans.take(4).map((scan) => _ScanTile(scan: scan)),
          ],
        ),
      ),
    );
  }
}

class _HeroPanel extends StatelessWidget {
  const _HeroPanel({required this.onScan});

  final VoidCallback onScan;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [scheme.primary, scheme.secondary]),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.camera_alt, color: Colors.white, size: 42),
          const SizedBox(height: 34),
          Text(
            context.tr('tagline'),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 12),
          Text(context.tr('notMedical'), style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w600)),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: onScan,
            style: FilledButton.styleFrom(backgroundColor: Colors.white, foregroundColor: scheme.primary),
            icon: const Icon(Icons.document_scanner),
            label: Text(context.tr('scanTree')),
          ),
        ],
      ),
    );
  }
}

class _ScanTile extends StatelessWidget {
  const _ScanTile({required this.scan});

  final TreeScan scan;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(backgroundColor: Theme.of(context).colorScheme.primaryContainer, child: const Icon(Icons.park)),
        title: Text(scan.species, style: const TextStyle(fontWeight: FontWeight.w900)),
        subtitle: Text('${scan.heightFeet.toStringAsFixed(1)} ${context.tr('feet')} · ${scan.diameterInches.toStringAsFixed(1)} ${context.tr('inches')}'),
        trailing: Text('${scan.estimatedWeightKg.toStringAsFixed(0)} ${context.tr('kg')}', style: const TextStyle(fontWeight: FontWeight.w900)),
      ),
    );
  }
}

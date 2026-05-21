import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../i18n/app_localizations.dart';
import '../services/local_scan_repository.dart';
import 'result_screen.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key, required this.repository});

  final LocalScanRepository repository;

  @override
  Widget build(BuildContext context) {
    final scans = repository.getScans();
    return Scaffold(
      appBar: AppBar(title: Text(context.tr('history'), style: const TextStyle(fontWeight: FontWeight.w900))),
      body: scans.isEmpty
          ? Center(child: Text(context.tr('emptyHistory')))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: scans.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final scan = scans[index];
                return Card(
                  child: ListTile(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => ResultScreen(repository: repository, scan: scan))),
                    leading: const CircleAvatar(child: Icon(Icons.park)),
                    title: Text('${scan.species} · ${scan.estimatedWeightKg.toStringAsFixed(0)} ${context.tr('kg')}', style: const TextStyle(fontWeight: FontWeight.w900)),
                    subtitle: Text('${DateFormat.yMMMd().format(scan.createdAt)} · ${scan.farmName.isEmpty ? scan.plotDetails : scan.farmName}'),
                    trailing: scan.accuracyPercent == null ? null : Text('${scan.accuracyPercent!.toStringAsFixed(0)}%'),
                  ),
                );
              },
            ),
    );
  }
}

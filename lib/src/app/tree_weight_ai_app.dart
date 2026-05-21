import 'package:flutter/material.dart';

import '../i18n/app_localizations.dart';
import '../screens/dashboard_screen.dart';
import '../services/local_scan_repository.dart';
import 'tree_weight_theme.dart';

class TreeWeightAiApp extends StatefulWidget {
  const TreeWeightAiApp({super.key, required this.repository});

  final LocalScanRepository repository;

  @override
  State<TreeWeightAiApp> createState() => _TreeWeightAiAppState();
}

class _TreeWeightAiAppState extends State<TreeWeightAiApp> {
  Locale _locale = const Locale('hi');

  void _setLocale(Locale locale) {
    setState(() => _locale = locale);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tree Weight AI',
      debugShowCheckedModeBanner: false,
      locale: _locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      theme: TreeWeightTheme.light,
      home: DashboardScreen(
        repository: widget.repository,
        locale: _locale,
        onLocaleChanged: _setLocale,
      ),
    );
  }
}

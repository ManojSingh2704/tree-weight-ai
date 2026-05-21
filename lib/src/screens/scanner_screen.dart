import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../i18n/app_localizations.dart';
import '../services/local_scan_repository.dart';
import '../services/location_service.dart';
import '../services/species_database.dart';
import '../services/tree_ai_service.dart';
import '../services/tree_estimator.dart';
import 'result_screen.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key, required this.repository});

  final LocalScanRepository repository;

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _distance = TextEditingController(text: '12');
  final _height = TextEditingController(text: '18');
  final _diameter = TextEditingController(text: '10');
  final _farmName = TextEditingController();
  final _plotDetails = TextEditingController();
  final _speciesHint = TextEditingController(text: 'Eucalyptus');
  CameraController? _cameraController;
  String? _frontImagePath;
  String? _sideImagePath;
  bool _loadingCamera = true;
  bool _estimating = false;

  final _speciesDb = SpeciesDatabase();
  final _aiService = TreeAiService();
  final _estimator = TreeEstimator();
  final _locationService = LocationService();

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        setState(() => _loadingCamera = false);
        return;
      }
      _cameraController = CameraController(cameras.first, ResolutionPreset.medium, enableAudio: false);
      await _cameraController!.initialize();
    } catch (_) {
      _cameraController = null;
    }
    if (mounted) setState(() => _loadingCamera = false);
  }

  Future<void> _capture({required bool side}) async {
    final controller = _cameraController;
    if (controller == null || !controller.value.isInitialized) return;
    final file = await controller.takePicture();
    setState(() {
      if (side) {
        _sideImagePath = file.path;
      } else {
        _frontImagePath = file.path;
      }
    });
  }

  Future<void> _estimate() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _estimating = true);
    final prediction = await _aiService.identifySpecies(
      speciesHint: _speciesHint.text,
      frontImagePath: _frontImagePath,
      sideImagePath: _sideImagePath,
    );
    final species = _speciesDb.byName(prediction.speciesName);
    final location = await _locationService.currentLocation();
    final scan = _estimator.estimate(
      TreeEstimatorInput(
        species: species,
        heightFeet: double.parse(_height.text),
        diameterInches: double.parse(_diameter.text),
        distanceFeet: double.parse(_distance.text),
        farmName: _farmName.text.trim(),
        plotDetails: _plotDetails.text.trim(),
        previousScans: widget.repository.getScans(),
        speciesConfidence: prediction.confidence,
        latitude: location?.latitude,
        longitude: location?.longitude,
        frontImagePath: _frontImagePath,
        sideImagePath: _sideImagePath,
      ),
    );
    final adjusted = scan.copyWith();
    await widget.repository.saveScan(adjusted);
    if (!mounted) return;
    setState(() => _estimating = false);
    await Navigator.of(context).push(MaterialPageRoute(builder: (_) => ResultScreen(repository: widget.repository, scan: adjusted)));
    if (mounted) Navigator.of(context).pop();
  }

  String? _requiredNumber(String? value) {
    final parsed = double.tryParse(value ?? '');
    if (parsed == null || parsed <= 0) return 'Required';
    return null;
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _distance.dispose();
    _height.dispose();
    _diameter.dispose();
    _farmName.dispose();
    _plotDetails.dispose();
    _speciesHint.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.tr('scanTree'), style: const TextStyle(fontWeight: FontWeight.w900))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _CameraPanel(
            controller: _cameraController,
            loading: _loadingCamera,
            frontCaptured: _frontImagePath != null,
            sideCaptured: _sideImagePath != null,
            onFront: () => _capture(side: false),
            onSide: () => _capture(side: true),
          ),
          const SizedBox(height: 16),
          Text(context.tr('cameraGuide'), style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          Form(
            key: _formKey,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(context.tr('manualInputs'), style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
                    const SizedBox(height: 12),
                    TextFormField(controller: _speciesHint, decoration: InputDecoration(labelText: context.tr('speciesHint'))),
                    const SizedBox(height: 12),
                    TextFormField(controller: _distance, validator: _requiredNumber, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: context.tr('distance'))),
                    const SizedBox(height: 12),
                    TextFormField(controller: _height, validator: _requiredNumber, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: context.tr('height'))),
                    const SizedBox(height: 12),
                    TextFormField(controller: _diameter, validator: _requiredNumber, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: context.tr('diameter'))),
                    const SizedBox(height: 12),
                    TextFormField(controller: _farmName, decoration: InputDecoration(labelText: context.tr('farmName'))),
                    const SizedBox(height: 12),
                    TextFormField(controller: _plotDetails, decoration: InputDecoration(labelText: context.tr('plotDetails'))),
                    const SizedBox(height: 18),
                    FilledButton.icon(
                      onPressed: _estimating ? null : _estimate,
                      icon: _estimating ? const SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.auto_awesome),
                      label: Text(context.tr('estimate')),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CameraPanel extends StatelessWidget {
  const _CameraPanel({
    required this.controller,
    required this.loading,
    required this.frontCaptured,
    required this.sideCaptured,
    required this.onFront,
    required this.onSide,
  });

  final CameraController? controller;
  final bool loading;
  final bool frontCaptured;
  final bool sideCaptured;
  final VoidCallback onFront;
  final VoidCallback onSide;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 4 / 3,
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : controller == null || !controller!.value.isInitialized
                    ? Center(child: Text(context.tr('cameraUnavailable')))
                    : Stack(
                        fit: StackFit.expand,
                        children: [
                          CameraPreview(controller!),
                          const _TreeFrameGuide(),
                        ],
                      ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: FilledButton.tonalIcon(
                    onPressed: onFront,
                    icon: Icon(frontCaptured ? Icons.check_circle : Icons.photo_camera),
                    label: Text(context.tr('frontAngle')),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton.tonalIcon(
                    onPressed: onSide,
                    icon: Icon(sideCaptured ? Icons.check_circle : Icons.photo_camera),
                    label: Text(context.tr('sideAngle')),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TreeFrameGuide extends StatelessWidget {
  const _TreeFrameGuide();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 2),
            borderRadius: BorderRadius.circular(120),
          ),
        ),
      ),
    );
  }
}

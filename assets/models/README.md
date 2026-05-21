Place production AI model files here:

- `tree_species_classifier.tflite`
- `tree_detector_yolo.tflite`
- `dbh_regression.tflite`
- `height_depth_regression.tflite`

The current app includes service integration points and forestry formulas. Replace the stub in
`lib/src/services/tree_ai_service.dart` with real TensorFlow Lite inference when model files are ready.

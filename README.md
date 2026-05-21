# Tree Weight AI

Professional Flutter Android app for AI-assisted tree scanning, tree species detection, DBH measurement, wood volume, fresh/dry weight, biomass and carbon estimation.

## Languages

- Hindi
- English

## Core Features

- Camera scanner for front and side tree capture
- Guided scan positioning
- Species prediction integration point for TensorFlow Lite / YOLO
- Height, DBH, distance and volume-based weight calculator
- Species density database for Poplar, Eucalyptus, Neem, Mango, Teak and Bamboo
- Fresh wood weight, dry wood weight, biomass and carbon estimate
- Farmer dashboard with total trees, total wood, value and carbon
- Offline local history using SharedPreferences
- GPS location capture
- Feedback learning: actual weight adjusts future species correction
- FastAPI backend skeleton for feedback sync and model learning

## Important Accuracy Policy

The app is designed to avoid blind guessing from a photo. It combines:

- Camera images
- Front and side angle capture
- User-entered distance from tree
- Height and DBH measurements
- Species density database
- Feedback correction from actual weight

Production model files should be added in `assets/models/` and connected inside `lib/src/services/tree_ai_service.dart`.

## Run Android App

Install Flutter SDK, then:

```bash
cd tree_weight_ai
flutter pub get
flutter run
```

If platform files need regeneration:

```bash
flutter create .
flutter pub get
flutter run
```

## Backend

```bash
cd backend
python -m venv .venv
.venv\Scripts\activate
pip install -r requirements.txt
uvicorn main:app --reload
```

## Production AI Roadmap

- Add `tree_species_classifier.tflite`
- Add YOLO tree detector model
- Add DBH and height regression models
- Use ARCore depth API on supported Android phones
- Sync feedback to backend
- Retrain regression model from actual field weights
- Add Firebase/PostgreSQL persistence for admin dashboard

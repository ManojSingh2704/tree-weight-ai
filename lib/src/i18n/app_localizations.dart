import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static const supportedLocales = [Locale('hi'), Locale('en')];

  static const localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    _AppLocalizationsDelegate(),
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static final Map<String, Map<String, String>> _values = {
    'en': {
      'appName': 'Tree Weight AI',
      'tagline': 'AI-assisted tree weight, biomass and carbon estimator',
      'language': 'हिंदी',
      'scanTree': 'Scan Tree',
      'dashboard': 'Farmer Dashboard',
      'history': 'History',
      'totalTrees': 'Total trees',
      'estimatedWood': 'Estimated wood',
      'estimatedValue': 'Estimated value',
      'carbonValue': 'Carbon value',
      'openCamera': 'Open Camera Scanner',
      'cameraGuide': 'Capture full tree from front and side. Keep the trunk base visible and enter measured distance from the tree.',
      'frontAngle': 'Front angle',
      'sideAngle': 'Side angle',
      'capture': 'Capture',
      'manualInputs': 'Measurement inputs',
      'distance': 'Distance from tree (feet)',
      'height': 'Tree height (feet)',
      'diameter': 'DBH / trunk diameter (inches)',
      'farmName': 'Farm name',
      'plotDetails': 'Plot details',
      'speciesHint': 'Species hint',
      'estimate': 'Estimate Weight',
      'result': 'AI Result',
      'species': 'Species',
      'confidence': 'Confidence',
      'woodVolume': 'Wood volume',
      'weight': 'Approx weight',
      'freshWeight': 'Fresh wood weight',
      'dryWeight': 'Dry wood weight',
      'biomass': 'Biomass',
      'carbon': 'Carbon',
      'timberValue': 'Timber value',
      'feedback': 'Feedback learning',
      'actualWeight': 'Actual weight in KG',
      'saveFeedback': 'Save feedback',
      'offline': 'Offline ready',
      'sync': 'Sync pending scans later',
      'emptyHistory': 'No scans yet. Start with the camera scanner.',
      'accuracy': 'Accuracy',
      'kg': 'KG',
      'feet': 'ft',
      'inches': 'in',
      'locationSaved': 'GPS location saved',
      'notMedical': 'Use camera + distance + depth + feedback. The app never guesses blindly from a photo.',
      'cameraUnavailable': 'Camera is unavailable. You can still enter manual measurements.',
    },
    'hi': {
      'appName': 'ट्री वेट AI',
      'tagline': 'पेड़ का वजन, लकड़ी, बायोमास और कार्बन अनुमान',
      'language': 'English',
      'scanTree': 'पेड़ स्कैन करें',
      'dashboard': 'किसान डैशबोर्ड',
      'history': 'इतिहास',
      'totalTrees': 'कुल पेड़',
      'estimatedWood': 'अनुमानित लकड़ी',
      'estimatedValue': 'अनुमानित मूल्य',
      'carbonValue': 'कार्बन वैल्यू',
      'openCamera': 'कैमरा स्कैनर खोलें',
      'cameraGuide': 'पेड़ को सामने और साइड से पूरा कैप्चर करें। तना और जड़ का हिस्सा दिखे, और पेड़ से दूरी जरूर डालें।',
      'frontAngle': 'सामने का फोटो',
      'sideAngle': 'साइड फोटो',
      'capture': 'कैप्चर',
      'manualInputs': 'माप जानकारी',
      'distance': 'पेड़ से दूरी (फीट)',
      'height': 'पेड़ की ऊंचाई (फीट)',
      'diameter': 'DBH / तने का व्यास (इंच)',
      'farmName': 'खेत का नाम',
      'plotDetails': 'प्लॉट जानकारी',
      'speciesHint': 'पेड़ की प्रजाति संकेत',
      'estimate': 'वजन निकालें',
      'result': 'AI परिणाम',
      'species': 'प्रजाति',
      'confidence': 'विश्वास',
      'woodVolume': 'लकड़ी आयतन',
      'weight': 'अनुमानित वजन',
      'freshWeight': 'गीली लकड़ी वजन',
      'dryWeight': 'सूखी लकड़ी वजन',
      'biomass': 'बायोमास',
      'carbon': 'कार्बन',
      'timberValue': 'लकड़ी मूल्य',
      'feedback': 'फीडबैक लर्निंग',
      'actualWeight': 'असल वजन KG में',
      'saveFeedback': 'फीडबैक सेव करें',
      'offline': 'ऑफलाइन तैयार',
      'sync': 'बाद में sync करें',
      'emptyHistory': 'अभी कोई स्कैन नहीं है। कैमरा स्कैनर से शुरू करें।',
      'accuracy': 'सटीकता',
      'kg': 'KG',
      'feet': 'फीट',
      'inches': 'इंच',
      'locationSaved': 'GPS लोकेशन सेव हुई',
      'notMedical': 'कैमरा + दूरी + depth + feedback का उपयोग करें। ऐप सिर्फ फोटो देखकर अंधा अनुमान नहीं लगाता।',
      'cameraUnavailable': 'कैमरा उपलब्ध नहीं है। आप manual measurements डाल सकते हैं।',
    },
  };

  String t(String key) => _values[locale.languageCode]?[key] ?? _values['en']![key] ?? key;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'hi'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async => AppLocalizations(locale);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

extension LocalizedContext on BuildContext {
  String tr(String key) => AppLocalizations.of(this).t(key);
}

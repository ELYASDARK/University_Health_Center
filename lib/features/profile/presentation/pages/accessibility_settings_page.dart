import 'package:flutter/material.dart';

/// Accessibility settings page
class AccessibilitySettingsPage extends StatelessWidget {
  const AccessibilitySettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Accessibility Settings')),
      body: const Center(child: Text('Accessibility settings coming soon')),
    );
  }
}

/// Accessibility provider
class AccessibilityProvider extends ChangeNotifier {
  double _fontSize = 14.0;
  bool _highContrast = false;
  bool _screenReader = false;

  double get fontSize => _fontSize;
  bool get highContrast => _highContrast;
  bool get screenReader => _screenReader;

  Future<void> loadSettings() async {
    // TODO: Load from storage
    notifyListeners();
  }

  void setFontSize(double size) {
    _fontSize = size;
    notifyListeners();
  }

  void setHighContrast(bool enabled) {
    _highContrast = enabled;
    notifyListeners();
  }

  void setScreenReader(bool enabled) {
    _screenReader = enabled;
    notifyListeners();
  }
}




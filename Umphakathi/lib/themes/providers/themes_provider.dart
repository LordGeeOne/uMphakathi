import 'package:flutter/material.dart';

class CustomTheme {
  final Map<String, Map<String, List<Color>>>? gradients;
  final Map<String, Map<String, Color>>? colorCategories;

  CustomTheme({
    this.gradients,
    this.colorCategories,
  });
}

class ThemeProvider extends ChangeNotifier {
  CustomTheme? _currentCustomTheme;

  CustomTheme? get currentCustomTheme => _currentCustomTheme ?? _getDefaultTheme();

  CustomTheme _getDefaultTheme() {
    return CustomTheme(
      gradients: {
        'Cards': {
          'Home Card': [const Color(0xFF667eea), const Color(0xFF764ba2)],
        },
      },
      colorCategories: {
        'Primary Colors': {
          'Primary Color': const Color(0xFF6A1B9A),
          'Accent Color': const Color(0xFF667eea),
        },
      },
    );
  }

  void setCustomTheme(CustomTheme theme) {
    _currentCustomTheme = theme;
    notifyListeners();
  }
}

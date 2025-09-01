import 'package:flutter/material.dart';

class FontHelper {
  static String getFontFamilyForLocale(Locale locale) {
    switch (locale.languageCode) {
      case 'hi':
        return 'Noto Sans Devanagari';
      case 'ta':
        return 'Noto Sans Tamil';
      case 'te':
        return 'Noto Sans Telugu';
      case 'kn':
        return 'Noto Sans Kannada';
      case 'ml':
        return 'Noto Sans Malayalam';
      case 'bn':
        return 'Noto Sans Bengali';
      default:
        return 'Noto Sans';
    }
  }
}

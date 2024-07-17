import 'package:flutter/material.dart';


class LocaleProvider extends ChangeNotifier {
  Locale _locale; // Private field to hold the current locale.

  LocaleProvider(this._locale); 

  Locale get locale => _locale; // Getter to access the current locale.

  void setLocale(Locale locale) {
    if (locale != _locale) { 
      _locale = locale; // Updates the locale.
      notifyListeners(); // Notifies listeners about the change.
    }
  }

  void clearLocale() {
    _locale = const Locale('en'); // Resets the locale to English.
    notifyListeners(); 
  }
}

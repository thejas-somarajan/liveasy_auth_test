import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:liveasy_demo/page_1.dart';
import 'firebase_options.dart';
import 'locale_provider.dart';
import 'package:provider/provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, 
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => LocaleProvider(const Locale('en')), // Provides the locale state to the app.
      child: const LivEasy(), 
    ),
  );
}

class LivEasy extends StatelessWidget {
  const LivEasy({super.key}); 
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, localeProvider, child) { // Uses a Consumer to listen for changes in LocaleProvider.
        return const MaterialApp(
          localizationsDelegates: [
            AppLocalizations.delegate, // Delegate for app-specific localizations.
            GlobalMaterialLocalizations.delegate, // Delegate for material localizations.
            GlobalWidgetsLocalizations.delegate, // Delegate for widgets localizations.
            GlobalCupertinoLocalizations.delegate, // Delegate for Cupertino localizations.
          ],
          supportedLocales: [
            Locale('en', ''), // Supports English locale.
            Locale('hi', ''), // Supports Hindi locale.
          ],
          home: LanguagePage(), 
        );
      }
    );
  }
}

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
      create: (context) => LocaleProvider(const Locale('en')), 
      child: const LivEasy(),
    ),
  );
}


class LivEasy extends StatelessWidget {
  const LivEasy({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, localeProvider, child) {
        return const MaterialApp(
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          Locale('en', ''), 
          Locale('hi', ''), 
        ],
        home: LanguagePage(),
      );
      }
    );
  }
}
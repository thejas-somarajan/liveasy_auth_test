import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:liveasy_demo/page_2.dart';
import 'locale_provider.dart';
import 'package:provider/provider.dart';

class LanguagePage extends StatelessWidget {
  const LanguagePage({super.key}); 

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!; // Gets the localized strings.

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 255, 255, 255), 
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, 
                children: [
                  const Icon(
                    Icons.image_outlined, 
                    size: 85,
                  ),
                  const SizedBox(height: 50), 
                  Text(
                    localizations.languageText, // Displays the localized language text.
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 80), 
                    child: Text(
                      localizations.languageInfo, // Displays the localized language info text.
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        color: Colors.blueGrey,
                      ),
                      textAlign: TextAlign.center, // Centers the text.
                    ),
                  ),
                  const SizedBox(height: 20), 
                  const LanguageDropdown(), // Displays the language dropdown widget.
                  const SizedBox(height: 30), 
                  Container(
                    width: 310,
                    height: 82,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10), 
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const PhoneNo()), // Navigates to PhoneNo page on button press.
                        );
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 31, 59, 108)), 
                        shape: MaterialStateProperty.all(
                          const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero, 
                          ),
                        ),
                      ),
                      child: Text(
                        localizations.button, // Displays the localized button text.
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20), 
            Align(
              alignment: Alignment.bottomCenter, 
              child: Stack(
                children: [
                  ClipPath(
                    clipper: WaveClipperTwo(reverse: true), // Clips the container with a wave shape.
                    child: Container(
                      color: const Color.fromARGB(255, 139, 203, 255),
                      height: 110,
                    ),
                  ),
                  ClipPath(
                    clipper: WaveClipperOne(reverse: true), // Clips the container with another wave shape.
                    child: Container(
                      color: const Color.fromARGB(120, 117, 146, 172), 
                      height: 110,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LanguageDropdown extends StatefulWidget {
  const LanguageDropdown({super.key}); 

  @override
  State<LanguageDropdown> createState() => _LanguageDropdownState(); 
}

class _LanguageDropdownState extends State<LanguageDropdown> {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!; // Gets the localized strings.
    String dropdownvalue = localizations.option; // Sets the initial dropdown value.
    final localeProvider = Provider.of<LocaleProvider>(context); // Gets the locale provider.

    List<String> languages = [localizations.englishOption, localizations.hindiOption]; 

    return Container(
      width: 280,
      height: 55,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10), 
      decoration: BoxDecoration(
        border: Border.all(), 
      ),
      child: DropdownButton(
        isExpanded: true, 
        value: dropdownvalue, 
        icon: const Icon(Icons.keyboard_arrow_down_rounded), 
        elevation: 16,
        underline: Container(
          height: 0, 
        ),
        style: const TextStyle(
          fontWeight: FontWeight.w300,
          color: Colors.black,
          fontSize: 23,
        ),
        selectedItemBuilder: (BuildContext context) {
          return languages.map((String language) {
            return Container(
              alignment: Alignment.centerLeft, 
              padding: const EdgeInsets.only(right: 20), // Adds padding to the right.
              child: Text(language),
            );
          }).toList();
        },
        items: languages.map((String language) {
          return DropdownMenuItem(
            value: language, 
            child: Text(language), 
          );
        }).toList(),
        onChanged: (String? newValue) {
          Locale newLocale;
          if (newValue == localizations.englishOption) {
            newLocale = const Locale('en'); // Sets the locale to English.
          } else {
            newLocale = const Locale('hi'); // Sets the locale to Hindi.
          }
          _changeLocale(context, newLocale); // Changes the app's locale.
          localeProvider.setLocale(newLocale); // Updates the locale provider.
          setState(() {
            dropdownvalue = newValue!; 
          });
        },
      ),
    );
  }

  void _changeLocale(BuildContext context, Locale newLocale) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (BuildContext context) => Localizations.override(
          context: context,
          locale: newLocale, // Overrides the locale.
          child: const LanguagePage(), // Rebuilds the LanguagePage with the new locale.
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'locale_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  int _selectedProfile = 0; // Variable to track selected profile option.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: FutureBuilder<AppLocalizations>(
            future: AppLocalizations.delegate.load(
              Provider.of<LocaleProvider>(context, listen: false).locale,
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                final localizations = snapshot.data!; // Gets localized strings.

                return DecoratedBox(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: Center(
                      child: Column(
                        children: [
                          const SizedBox(height: 100,),
                          Text(
                            localizations.profileText,
                            style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 50,),
                          Container(
                            padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 2.0,
                                )
                              ),
                            child: RadioListTile<int>(
                                title:Row(
                                  children: [
                                    const Icon(Icons.warehouse_outlined, size: 50),
                                    const SizedBox(width: 20),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(localizations.shipperButton, style: const TextStyle(fontSize: 25)),
                                        const Text(
                                          'Lorem ipsum dolor sit amet,\nconsectetur adipiscing',
                                          style: TextStyle(fontSize: 13),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                value: 0,
                                groupValue: _selectedProfile,
                                onChanged: (value) => setState(() => _selectedProfile = value!), // Updates selected profile.
                              ),
                          ),
                            const SizedBox(height: 50,),
                            Container(
                              padding:  const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 2.0,
                                )
                              ),
                              child: RadioListTile<int>(
                                title:  Row(
                                  children: [
                                    const Icon(Icons.fire_truck_outlined, size: 50),
                                    const SizedBox(width: 20),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(localizations.transporterButton, style: const TextStyle(fontSize: 25)),
                                        const Text(
                                          'Lorem ipsum dolor sit amet,\nconsectetur adipiscing',
                                          style: TextStyle(
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                value: 1,
                                groupValue: _selectedProfile,
                                onChanged: (value) => setState(() => _selectedProfile = value!), // Updates selected profile.
                              ),
                            ),
                            const SizedBox(height: 50,),
                            Container(
                              height: 70,
                              width: 400,
                              child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context, 
                                      MaterialPageRoute(builder: (context) => const ProfilePage()),
                                    );
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 23, 46, 85)),
                                    shape: MaterialStateProperty.all(
                                      const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.zero,
                                      ),
                                    ),
                                  ), 
                                  child: Text(
                                    localizations.cButton,
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
                  ),
                );
              }
            },
          ),
        );
  }
}
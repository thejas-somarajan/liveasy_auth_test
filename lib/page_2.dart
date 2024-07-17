import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:liveasy_demo/page_3.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'locale_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';



class PhoneNo extends StatefulWidget {
  const PhoneNo({super.key});
  

  @override
  State<PhoneNo> createState() => _PhoneNoState();
}

class _PhoneNoState extends State<PhoneNo> {


  String? validatePhoneNumber(String? value) {
    String pattern = r'^[6-9]\d{9}$';
    RegExp regExp = RegExp(pattern);
    if (value == null || value.isEmpty) {
      return 'Please enter a phone number';
    } else if (!regExp.hasMatch(value)) {
      return 'Please enter a valid 10-digit Indian phone number';
    }
    return null;
  }

  Country country = Country(
    phoneCode: "+91", 
    countryCode: "IN", 
    e164Sc: 0, 
    geographic: true, 
    level: 1, 
    name: "India", 
    example: "India", 
    displayName: "India", 
    displayNameNoCountryCode: "IN", 
    e164Key: "",
  );

  final FirebaseAuth _auth = FirebaseAuth.instance; // Instance of FirebaseAuth.
  final TextEditingController _phoneController = TextEditingController(); // Controller for phone number input.
  late String _verificationId; // Verification ID for phone authentication.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: FutureBuilder<AppLocalizations>(
            future: AppLocalizations.delegate.load(
              Provider.of<LocaleProvider>(context, listen: false).locale,
              ), // Loads the localized strings based on the current locale.
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator()); // Shows a loading indicator while waiting.
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}')); // Displays an error message if loading fails.
                } else {
                  final localizations = snapshot.data!; // Gets the localized strings.

                  return DecoratedBox(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                      child: Column(
                        children: [
                          const SizedBox(height: 50),
                          Align(
                            alignment: Alignment.topLeft,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: BorderSide.none,
                              ),
                              onPressed: () {
                                Navigator.pop(context); // Navigates back to the previous screen.
                              }, 
                              child: const Icon(
                                Icons.cancel_outlined,
                                size: 30,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(height: 50,),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                Text(
                                  localizations.phonenumberText, // Displays the localized phone number text.
                                  style: const TextStyle(
                                    fontSize: 23,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 50),
                                  child:Text(
                                    localizations.phonenumberInfo, // Displays the localized phone number info.
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.blueGrey,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                TextFormField(
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                    border: const OutlineInputBorder(),
                                    hintText: localizations.hintText, // Displays the localized hint text
                                    prefixIcon: Container(
                                      padding: const EdgeInsets.all(10.0),
                                      child: InkWell(
                                        onTap: () {},
                                        child: Text(
                                          "${country.flagEmoji} ${country.phoneCode} - ", // Displays the country flag and phone code.
                                          style: const TextStyle(
                                            fontSize: 20,
                                          ),
                                          ),
                                      ),
                                    ),
                                  ),
                                  controller: _phoneController, // Sets the controller for the phone number input.
                                  validator: validatePhoneNumber,
                                  style: const TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                                const SizedBox(height: 25,),
                                SizedBox(
                                  width: 700,
                                  height: 70,
                                  child: ElevatedButton(
                                  onPressed: () {
                                    _verifyPhoneNumber(); // Calls the phone number verification function.
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
                                    localizations.cButton,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24,
                                    ),
                                  ),
                                  ),
                                ),
                                ]
                              ),
                            ),
                          ),
                        ],
                      ),
                  );
                }
              },
          ),
        );
  }

  void _verifyPhoneNumber() async {
    final PhoneVerificationCompleted verificationCompleted = (PhoneAuthCredential credential) async {
      await _auth.signInWithCredential(credential);
      print('Phone number automatically verifiedand user signed in: ${_auth.currentUser?.uid}');
    };

    final PhoneVerificationFailed verificationFailed = (FirebaseAuthException e) {
      print('Phone Number verification failed ${e.code}');
    };

    final PhoneCodeSent codeSent = (String verificationId, int? resendToken) async {
      print('Please check your phone for the verfication code');
      setState(() {
        _verificationId = verificationId;
      });
      Navigator.pushReplacement(
          context, 
          MaterialPageRoute(
            builder: (context) => CodeVerification(verificationId: verificationId, phone: _phoneController.text),
          )
       );
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout = (String verificationId) {
      print('verification code: ${verificationId}');
      setState(() {
        _verificationId = verificationId;
      });
    };


    String phoneNumber = "+91${_phoneController.text}";
    
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 60),
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }
}
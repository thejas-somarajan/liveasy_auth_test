import 'package:flutter/material.dart';
import 'package:liveasy_demo/page_2.dart';
import 'package:liveasy_demo/page_4.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'locale_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:timer_count_down/timer_count_down.dart';


class CodeVerification extends StatefulWidget {
  final String verificationId;
  final String phone;
  const CodeVerification({super.key,required this.verificationId, required this.phone});

  @override
  State<CodeVerification> createState() => _CodeVerificationState();
}

class _CodeVerificationState extends State<CodeVerification> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _otpController = TextEditingController(); // Controller for OTP input.

  bool _isButtonDisabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: FutureBuilder<AppLocalizations>(
            future: AppLocalizations.delegate.load(
              Provider.of<LocaleProvider>(context, listen: false).locale,
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator()); // Shows loading indicator while waiting.
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}')); // Displays error message if loading fails.
              } else {
                final localizations = snapshot.data!;

                return DecoratedBox(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Column(
                      children: [
                        const SizedBox(height: 50,),
                        Align(
                          alignment: Alignment.topLeft,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: BorderSide.none,
                            ),
                            onPressed: () {
                              Navigator.pop(context); // Navigates back to previous screen.
                            }, 
                            child: const Icon(
                              Icons.arrow_back,
                              size: 30,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(15),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(height: 30,),
                                Text(
                                localizations.verifyText,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 15),
                              Text(
                                '${localizations.verifyInfo} ${widget.phone}',  // Displays localized verification info with phone number.
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.blueGrey,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 25),
                              PinPut(
                                eachFieldWidth: 55.0, 
                                eachFieldHeight: 55.0, 
                                withCursor: true, 
                                fieldsCount: 6,
                                controller: _otpController,
                                eachFieldMargin: const EdgeInsets.symmetric(horizontal: 3), 
                                submittedFieldDecoration: BoxDecoration( 
                                  color: const Color.fromARGB(255, 8, 89, 171), 
                                  borderRadius: BorderRadius.circular(15.0), 
                                ),
                                selectedFieldDecoration: BoxDecoration( 
                                  color: const Color.fromARGB(255, 8, 89, 171), 
                                  borderRadius: BorderRadius.circular(15.0), 
                                ), 
                                followingFieldDecoration: BoxDecoration( 
                                  color: const Color.fromARGB(255, 112, 200, 235), 
                                  borderRadius: BorderRadius.circular(0), 
                                ),  
                                pinAnimationType: PinAnimationType.none, 
                                textStyle: const TextStyle(color: Colors.white, fontSize: 20.0, height: 1), 
                              ),
                              const SizedBox(height: 20,),
                              Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      localizations.recodeOption,
                                      style: const TextStyle(
                                        color: Color.fromARGB(255, 86, 86, 86),
                                        fontSize: 15,
                                      ),
                                    ),
                                    const SizedBox(width: 5,),
                                    TextButton(
                                      onPressed: _isButtonDisabled ? null : () {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(builder: (context) => const PhoneNo()), // Navigates to PhoneNo screen.
                                        );
                                      },
                                      child: Text(
                                        localizations.recodeButton,
                                        style: TextStyle(
                                          color: _isButtonDisabled ? Colors.grey : Colors.black,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 5,),
                                    Countdown(
                                      seconds: 60,
                                      build: (BuildContext context, double time) => Text(time.toString()), // Displays countdown timer.
                                      interval: const Duration(milliseconds: 100),
                                      onFinished: () {
                                        print('Timer is done!');
                                        setState(() {
                                          _isButtonDisabled = false; // Enables resend button after timer finishes.
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 15,),
                              Container(
                                width: 550,
                                height: 90,
                                padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                child: ElevatedButton(
                                onPressed: () {
                                  _signInWithPhoneNumber(); // Calls function to sign in with phone number.
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
                                  localizations.vcButton,
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

  void _signInWithPhoneNumber() async {
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId, 
        smsCode: _otpController.text,
      );
      final User? user = (await _auth.signInWithCredential(credential)).user; // Signs in user with credential.
      print('Successfully signed in UID: ${user!.uid}');
      Navigator.pushReplacement(
          context, 
          MaterialPageRoute(builder: (context) => const ProfilePage()), // Signs in user with credential.
      );
    } catch (e) {
      print('Failed to sign in: $e');
    }
  }
}




import 'package:flutter/material.dart';
import 'package:liveasy_demo/page_4.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'locale_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class CodeVerification extends StatefulWidget {
  final String verificationId;
  const CodeVerification({super.key,required this.verificationId});

  @override
  State<CodeVerification> createState() => _CodeVerificationState();
}

class _CodeVerificationState extends State<CodeVerification> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: FutureBuilder<AppLocalizations>(
            future: AppLocalizations.delegate.load(
              Provider.of<LocaleProvider>(context, listen: false).locale,
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
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
                              Navigator.pop(context);
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
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 15),
                              Text(
                                localizations.verifyInfo,
                                style: TextStyle(
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
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 86, 86, 86),
                                        fontSize: 18,
                                      ),
                                    ),
                                    const SizedBox(width: 5,),
                                    TextButton(
                                      onPressed: () {}, 
                                      child: Text(
                                        localizations.recodeButton,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                        ),
                                      ),
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
                                  _signInWithPhoneNumber();
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 23, 46, 85)),
                                  shape: MaterialStateProperty.all(
                                    const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.zero,
                                    ),
                                  ),
                                  // padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 5))
                                ), 
                                child: Text(
                                  localizations.vcButton,
                                  style: TextStyle(
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
      final User? user = (await _auth.signInWithCredential(credential)).user;
      print('Successfully signed in UID: ${user!.uid}');
      Navigator.pushReplacement(
          context, 
          MaterialPageRoute(builder: (context) => const ProfilePage()),
      );
    } catch (e) {
      print('Failed to sign in: $e');
      print(_otpController.text);
    }
  }
}


class InputReciever extends StatefulWidget {
  const InputReciever({super.key});

  @override
  State<InputReciever> createState() => _InputRecieverState();
}

class _InputRecieverState extends State<InputReciever> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _otpController = TextEditingController();
  late String _verificationId;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
              const Text(
                'Didn\'t recieve the code?',
                style: TextStyle(
                  color: Color.fromARGB(255, 86, 86, 86),
                  fontSize: 18,
                ),
              ),
              const SizedBox(width: 5,),
              TextButton(
                onPressed: () {}, 
                child: const Text(
                  'Request Again',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  void _signInWithPhoneNumber() async {
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId, 
        smsCode: _otpController.text,
      );
      final User? user = (await _auth.signInWithCredential(credential)).user;
      print('Successfully signed in UID: ${user!.uid}');
    } catch (e) {
      print('Failed to sign in: $e');
    }
  }

}

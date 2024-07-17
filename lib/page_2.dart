import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:liveasy_demo/page_3.dart';
import 'package:firebase_auth/firebase_auth.dart';


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

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _phoneController = TextEditingController();
  late String _verificationId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
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
                    Navigator.pop(context);
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
                    const Text(
                      "Please enter your mobile number",
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: const Text(
                        'You ll recieve a 6 digit code to verify next',
                        style: TextStyle(
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
                        hintText: 'Mobile Number',
                        // prefix: Text( '+91 - ' ),
                        prefixIcon: Container(
                          padding: const EdgeInsets.all(10.0),
                          child: InkWell(
                            onTap: () {},
                            child: Text(
                              "${country.flagEmoji} ${country.phoneCode} - ",
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                              ),
                          ),
                        ),
                      ),
                      controller: _phoneController,
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
                        _verifyPhoneNumber();
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 31, 59, 108)),
                        shape: MaterialStateProperty.all(
                          const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                      ), 
                      child: const Text(
                        'CONTINUE',
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
            builder: (context) => CodeVerification(verificationId: verificationId,),
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
      timeout: Duration(seconds: 60),
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }
}
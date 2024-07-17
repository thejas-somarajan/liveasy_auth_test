import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class PhoneAuthScreen extends StatefulWidget {
  const PhoneAuthScreen({super.key});

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  late String _verificationId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phone Authentication'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                ),
                keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 16,),
            ElevatedButton(
              onPressed: _verifyPhoneNumber, 
              child: Text('Verify Phone number'),
            ),
            TextField(
              controller: _otpController,
              decoration: InputDecoration(
                labelText: 'OTP',
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10,),
            ElevatedButton(
              onPressed: _signInWithPhoneNumber, 
              child: Text('Sign in with OTP'),
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
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout = (String verificationId) {
      print('verification code: ${verificationId}');
      setState(() {
        _verificationId = verificationId;
      });
    };


    await _auth.verifyPhoneNumber(
      phoneNumber: _phoneController.text,
      timeout: Duration(seconds: 60),
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
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




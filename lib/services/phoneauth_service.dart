// ignore_for_file: prefer_function_declarations_over_variables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../screen/authentication/otp_screen.dart';

class PhoneAuthService {
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> verifyPhoneNumber(BuildContext context, number) async {
    final PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential credential) async {
      await auth.signInWithCredential(credential);
      //after verification signin
    };
    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException e) {
      //if verification failed
      if (e.code == 'invalid-phone-number') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Alert'),
              content: const Text('Please Enter correct Number'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
      //print("This error is ${e.code}");
    };
    final PhoneCodeSent codeSent = (String verID, int? resendToken) async {
      //if OTP send new screen will open
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OTPScreen(
            number: number,
            verId: verID,
          ),
        ),
      );
    };

    try {
      auth.verifyPhoneNumber(
          phoneNumber: number,
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          timeout: const Duration(seconds: 60),
          codeAutoRetrievalTimeout: (String verificationId) {
            //print(verificationId);
          });
    } catch (e) {
      //print('Error ${e.toString()}');
    }
  }
}

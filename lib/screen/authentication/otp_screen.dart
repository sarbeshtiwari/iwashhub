// ignore_for_file: no_leading_underscores_for_local_identifiers, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:iwash/screen/starting/add_screen.dart';

import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

class OTPScreen extends StatefulWidget {
  static const String id = "OTPScreen";
  final String number, verId;
  const OTPScreen(
      {super.key,
      required this.number,
      required this.verId}); //added super.key and const

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  String error = '';

  Future<void> phoneCredential(BuildContext context, String otp, verId) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          smsCode: otp, verificationId: widget.verId);
      //need to otp validated or not
      final User? user = (await _auth.signInWithCredential(credential)).user;
      if (user != null) {
        //signed in

        // Check if a document with the phone number already exists
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        if (!userDoc.exists) {
          // If the document doesn't exist, create a new one
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set({
            'Phone Number': widget.number,
            'Created At': FieldValue.serverTimestamp(),
          });
        }
        Navigator.pushReplacementNamed(context, AddScreen.id);
      } else {
        if (mounted) {
          setState(() {
            error = 'Login Failed';
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          error = 'Invalid OTP';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ProgressDialog progressDialog = ProgressDialog(
      context,
    );
    progressDialog.style(
        message: 'Please wait',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: const CircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progressTextStyle: const TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: const TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600));
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 82, 165, 233),
        body: Container(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "CODE",
                style: TextStyle(fontSize: 50.0, fontWeight: FontWeight.bold),
              ),
              Text("Verification",
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(
                height: 40.0,
              ),
              const Text(
                "Enter the verification code send at",
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20.0,
              ),
              OtpTextField(
                numberOfFields: 6,
                fillColor: Colors.black.withOpacity(0.1),
                filled: true,
                keyboardType: TextInputType.number,
                onSubmit: (code) {
                  progressDialog.show();
                  phoneCredential(context, code, null);
                },
              ),
              const SizedBox(
                height: 20.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

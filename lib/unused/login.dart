// ignore_for_file: use_build_context_synchronously, unused_local_variable

//import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:iwash/screen/main/home.dart';
import 'package:iwash/screen/screen2/privacy_policy.dart';
import 'package:iwash/screen/screen2/terms_condition.dart';

import 'package:iwash/screen/starting/add_screen.dart';
import 'package:iwash/services/phoneauth_service.dart';

final _firebase = FirebaseAuth.instance;

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  static String id = 'SignUpScreen';

  @override
  State<SignUpScreen> createState() {
    return _SignUpScreenState();
  }
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _form = GlobalKey<FormState>();
  var countryCodeController = TextEditingController(text: '+91');
  var phoneNumberController = TextEditingController();
  final PhoneAuthService _service = PhoneAuthService();

  var _isLogin = true;
  var _enteredEmail = '';
  var _enteredPassword = '';
  var _enteredUsername = '';
  var _phoneNumber = '';
  var _enteredAddress = '';
  var _isAuthenticating = false;

  void _submit() async {
    final isValid = _form.currentState!.validate();

    if (!isValid) {
      // show error message ...
      return;
    }

    _form.currentState!.save();

    try {
      setState(() {
        _isAuthenticating = true;
      });
      if (_isLogin) {
        final userCredentials = await _firebase.signInWithEmailAndPassword(
          email: _enteredEmail,
          password: _enteredPassword,
        );
        Navigator.pushNamed(context, AddScreen.id);
      } else {
        final userCredentials = await _firebase.createUserWithEmailAndPassword(
          email: _enteredEmail,
          password: _enteredPassword,
        );

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredentials.user!.uid)
            .set({
          'code': userCredentials.user!.uid,
          'username': _enteredUsername,
          'email': _enteredEmail,
          'Phone Number': _phoneNumber,
          'Address': _enteredAddress,
        });

        String number =
            '${countryCodeController.text}${phoneNumberController.text}';
        _service.verifyPhoneNumber(context, number);
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == 'email-already-in-use') {
        // ...
      }
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message ?? 'Authentication failed.'),
        ),
      );
      setState(() {
        _isAuthenticating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 82, 165, 233),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(
                      top: 20,
                      bottom: 20,
                      right: 20,
                    ),
                    child: Image.asset(
                      'assets/images/log.png',
                      width: MediaQuery.of(context).size.width * .5,
                    ),
                  ),
                ),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  color: const Color.fromARGB(255, 82, 165, 233),
                  elevation: 0,
                  margin: const EdgeInsets.only(
                      top: 20, bottom: 20, left: 50, right: 50),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Form(
                        key: _form,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (!_isLogin)
                              TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Name',
                                  hintText: 'Enter your name',
                                  filled: true,
                                  fillColor: Color.fromARGB(255, 105, 235, 252),
                                  labelStyle: TextStyle(color: Colors.black),
                                  border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                ),
                                keyboardType: TextInputType.name,
                                enableSuggestions: true,
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      value.trim().length < 2) {
                                    return 'Please enter name';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _enteredUsername = value!;
                                },
                              ),
                            const SizedBox(
                              height: 15,
                            ),
                            if (!_isLogin)
                              TextFormField(
                                controller: phoneNumberController,
                                decoration: const InputDecoration(
                                  labelText: 'Phone Number',
                                  hintText: 'Otp will be send',
                                  filled: true,
                                  fillColor: Color.fromARGB(255, 105, 235, 252),
                                  labelStyle: TextStyle(color: Colors.black),
                                  border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                ),
                                enableSuggestions: false,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      value.trim().length > 10 ||
                                      value.trim().length < 10) {
                                    return 'Please enter correct phone number';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _phoneNumber = value!;
                                },
                              ),
                            const SizedBox(
                              height: 15,
                            ),
                            if (!_isLogin)
                              TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Address',
                                  hintText: "Enter Your Full Address",
                                  filled: true,
                                  fillColor: Color.fromARGB(255, 105, 235, 252),
                                  labelStyle: TextStyle(color: Colors.black),
                                  border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                ),
                                enableSuggestions: true,
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      value.trim().length < 5) {
                                    return 'Please enter at least 10 characters.';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _enteredAddress = value!;
                                },
                              ),
                            const SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                hintText: 'Use for login',
                                filled: true,
                                fillColor: Color.fromARGB(255, 105, 233, 250),
                                labelStyle: TextStyle(color: Colors.black),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              autocorrect: false,
                              textCapitalization: TextCapitalization.none,
                              validator: (value) {
                                if (value == null ||
                                    value.trim().isEmpty ||
                                    !value.contains('@')) {
                                  return 'Please enter a valid email address.';
                                }

                                return null;
                              },
                              onSaved: (value) {
                                _enteredEmail = value!;
                              },
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Password',
                                hintText: 'Use for login',
                                filled: true,
                                fillColor: Color.fromARGB(255, 105, 235, 252),
                                labelStyle: TextStyle(color: Colors.black),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                              ),
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.trim().length < 6) {
                                  return 'Password must be at least 6 characters long.';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _enteredPassword = value!;
                              },
                            ),
                            const SizedBox(height: 12),
                            if (_isAuthenticating)
                              const CircularProgressIndicator(),
                            if (!_isAuthenticating)
                              ElevatedButton(
                                onPressed: _submit,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                ),
                                child: Text(
                                  _isLogin ? 'Login' : 'Signup',
                                ),
                              ),
                            if (!_isAuthenticating)
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _isLogin = !_isLogin;
                                  });
                                },
                                child: Text(
                                  _isLogin
                                      ? 'Create an account'
                                      : 'I already have an account',
                                  style: const TextStyle(color: Colors.orange),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 60, right: 30),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: RichText(
                      text: TextSpan(
                        style: DefaultTextStyle.of(context)
                            .style
                            .copyWith(decoration: TextDecoration.none),
                        children: [
                          const TextSpan(
                            text: "   By Proceeding, You Agree to the ",
                            style: TextStyle(
                                fontSize: 11,
                                color: Color.fromARGB(255, 255, 255, 255)),
                          ),
                          TextSpan(
                            text: "\nTerms and Conditions",
                            style: const TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pushNamed(context, TermsCondition.id);
                                // Open Terms and Conditions Word document
                              },
                          ),
                          const TextSpan(
                            text: " & ",
                            style: TextStyle(
                                fontSize: 11,
                                color: Color.fromARGB(255, 255, 255, 255)),
                          ),
                          TextSpan(
                            text: "Privacy Policy",
                            style: const TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pushNamed(context, PrivacyPolicy.id);
                                // Open Privacy Policy Word document
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

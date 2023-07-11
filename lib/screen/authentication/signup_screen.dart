// ignore_for_file: use_build_context_synchronously, unused_local_variable

//import 'dart:io';

//import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

//import 'package:iwash/screen/main/home.dart';
import 'package:iwash/screen/screen2/privacy_policy.dart';
import 'package:iwash/screen/screen2/terms_condition.dart';

//import 'package:iwash/screen/starting/add_screen.dart';
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

  // ignore: unused_field
  var _phoneNumber = '';

  var _isAuthenticating = false;

  void _submit() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      // show error message ...
      return;
    }

    _form.currentState!.save();

    try {
      // // ...
      // print("1$_phoneNumber");
      // // Perform phone number authentication
      // final userCredentials =
      //     await _firebase.verifyPhoneNumber(phoneNumber: _phoneNumber)
      // print("2$_phoneNumber");
      // await FirebaseFirestore.instance
      //     .collection('users')
      //     .doc(_phoneNumber)
      //     .set({
      //   'Phone Number': _phoneNumber,
      // });
      // print("3$_phoneNumber");
      _isAuthenticating = true;
      String number =
          '${countryCodeController.text}${phoneNumberController.text}';
      _service.verifyPhoneNumber(context, number);

      // Fetch user details from the Firebase database
      // final userSnapshot = await FirebaseFirestore.instance
      //     .collection('users')
      //     .where('phoneNumber', isEqualTo: _phoneNumber)
      //     .limit(1)
      //     .get();

      // if (userSnapshot.docs.isNotEmpty) {
      //   final userData = userSnapshot.docs[0].data();
      //   // Extract user details from userData and store them as desired

      //   // Navigate to the desired screen
      //   Navigator.pushNamed(context, AddScreen.id);
      // }
      // ignore: unused_catch_clause
    } on FirebaseAuthException catch (error) {
      // ...
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.orange,
        //backgroundColor: const Color.fromARGB(255, 82, 165, 233),
        body: CustomPaint(
          painter: CurvePainter(),
          child: Center(
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
                              TextFormField(
                                controller: phoneNumberController,
                                decoration: const InputDecoration(
                                  labelText: 'Phone Number',
                                  hintText: 'Enter your Phone Number',
                                  filled: true,
                                  fillColor: Color.fromARGB(255, 105, 235, 252),
                                  labelStyle: TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    fontFamily: 'DMSans',
                                  ),
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
                              const SizedBox(height: 12),
                              if (_isAuthenticating)
                                const CircularProgressIndicator(),
                              if (!_isAuthenticating)
                                ElevatedButton(
                                  onPressed: _submit,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange,
                                  ),
                                  child: const Text(
                                    'Login',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 60, right: 30, top: 60),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: RichText(
                        text: TextSpan(
                          style: DefaultTextStyle.of(context)
                              .style
                              .copyWith(decoration: TextDecoration.none),
                          children: [
                            const TextSpan(
                              text: "By Proceeding, You Agree to the ",
                              style: TextStyle(
                                fontSize: 11,
                                color: Color.fromARGB(255, 255, 255, 255),
                                //fontFamily: 'Muller',
                              ),
                            ),
                            TextSpan(
                              text: "\nTerms and Conditions",
                              style: const TextStyle(
                                color: Color.fromARGB(255, 248, 162, 33),
                                fontSize: 11,
                                fontFamily: 'Muller',
                                fontWeight: FontWeight.bold,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushNamed(
                                      context, TermsCondition.id);
                                  // Open Terms and Conditions Word document
                                },
                            ),
                            const TextSpan(
                              text: " & ",
                              style: TextStyle(
                                fontSize: 11,
                                color: Color.fromARGB(255, 255, 255, 255),
                                //fontFamily: 'Muller',
                              ),
                            ),
                            TextSpan(
                              text: "Privacy Policy",
                              style: const TextStyle(
                                color: Color.fromARGB(255, 248, 162, 33),
                                fontSize: 11,
                                fontFamily: 'Muller',
                                fontWeight: FontWeight.bold,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushNamed(
                                      context, PrivacyPolicy.id);
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
      ),
    );
  }
}

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = const Color.fromARGB(255, 82, 165, 233);
    paint.style = PaintingStyle.fill;

    var path = Path();
    path.lineTo(0, size.height * 0.2);
    path.quadraticBezierTo(size.width * 0.25, size.height * 0.25,
        size.width * 0.5, size.height * 0.15);
    path.quadraticBezierTo(
        size.width * 0.75, size.height * 0.06, size.width, size.height * 0.2);
    path.lineTo(size.width, size.height * 0.95);
    path.quadraticBezierTo(size.width * 0.75, size.height * .9,
        size.width * 0.5, size.height * .95);
    path.quadraticBezierTo(
        size.width * 0.25, size.height * 1, 0, size.height * 0.9);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

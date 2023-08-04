// ignore_for_file: no_leading_underscores_for_local_identifiers, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:iwash/screen/starting/add_screen.dart';
import 'package:iwash/screen/starting/initial_screen.dart';
import 'package:mysql1/mysql1.dart';

import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_autofill/sms_autofill.dart';

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
  // Add a TextEditingController to control the OTP TextField
  final TextEditingController _otpController = TextEditingController();
  String error = '';

  @override
  void initState() {
    super.initState();
    // Listen for incoming SMS messages
    //_listenForSms();
  }

  // void _listenForSms() async {
  //   await SmsAutoFill().listenForCode;
  // }

  Future<void> signInWithOTP(BuildContext context, String enteredOtp,
      String sentOtp, String number) async {
    // Check if the entered OTP matches the one that was sent
    if (enteredOtp == sentOtp) {
      // Create a ConnectionSettings object with the connection details for your Hostinger database
      final ConnectionSettings settings = ConnectionSettings(
        host: 'srv665.hstgr.io',
        port: 3306,
        user: 'u332079037_iwashhubonline', //u332079037_iwashhubonline
        password: 'Iwashhub@123', //'Iwashhub@123
        db: 'u332079037_iwashhubapp',
      );

      // Connect to the Hostinger database
      final MySqlConnection conn = await MySqlConnection.connect(settings);

      // Execute a CREATE TABLE query to create the users table
      await conn.query('''
CREATE TABLE IF NOT EXISTS users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  phone_number VARCHAR(255) NOT NULL,
  created_at TIMESTAMP NOT NULL
)
''');

      // Execute a SELECT query to check if a row with the phone number already exists
      Results results = await conn
          .query('SELECT * FROM users WHERE phone_number = ?', [number]);

      int userId;
      if (results.isEmpty) {
        // If the row doesn't exist, insert a new one
        Results insertResults = await conn.query(
            'INSERT INTO users (phone_number, created_at) VALUES (?, NOW())',
            [number]);
        userId = insertResults.insertId!;
      } else {
        // If the row already exists, get the user ID
        userId = results.first['id'];
      }

      // Close the database connection
      storeUserId(userId);
      await conn.close();

      storeLoginState(true);
      Navigator.pushReplacementNamed(context, AddScreen.id);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('The entered OTP is incorrect. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ProgressDialog progressDialog = ProgressDialog(
      context,
      isDismissible: false,
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
        backgroundColor: Colors.orange,
        body: CustomPaint(
          painter: CurvePainter(),
          child: Container(
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "OTP",
                  style: TextStyle(
                      fontSize: 50.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const Text(
                  "Verification",
                  style: TextStyle(fontSize: 30.0, color: Colors.white),
                ),
                const SizedBox(
                  height: 40.0,
                ),

                const Text(
                  "Kindly enter the 6 digit OTP shared on your mobile number",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                PinFieldAutoFill(
                  controller: _otpController,
                  codeLength: 6,
                  onCodeChanged: (code) {
                    if (code != null && code.length == 6) {
                      // Submit the OTP code when it is complete
                      signInWithOTP(context, code, widget.verId, widget.number);
                    }
                  },
                ),
                // OtpTextField(
                //   numberOfFields: 6,
                //   fillColor: Colors.black.withOpacity(0.1),
                //   filled: true,
                //   keyboardType: TextInputType.number,
                //   onSubmit: (code) {
                //     progressDialog.show();
                //     signInWithOTP(context, code, widget.verId, widget.number);
                //   },
                // ),
                const SizedBox(
                  height: 20.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void storeUserId(int userId) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt('userId', userId);
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

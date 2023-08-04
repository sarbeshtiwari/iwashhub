// ignore_for_file: prefer_function_declarations_over_variables

import 'package:flutter/material.dart';
import '../screen/authentication/otp_screen.dart';
import 'dart:math';

import 'package:http/http.dart' as http;

class PhoneAuthService {
  Future<void> verifyPhoneNumber(BuildContext context, String number) async {
    if (number == '+911234567890') {
      Navigator.push(
        context, //here getting a issue recheck it during authentication
        MaterialPageRoute(
          builder: (context) => OTPScreen(
            number: number,
            verId: '548915',
          ),
        ),
      );
    } else {
      // Generate an OTP
      String otp = generateOTP();

      // Send the OTP to the phone number using an external SMS API
      await sendOTP(context, number, otp);
    }
  }

  Future<void> sendOTP(context, String number, String otp) async {
    // Set the base URL
    String url = 'http://smsw.co.in/API/WebSMS/Http/v1.0a/index.php';

    // Set the query parameters
    Map<String, String> queryParams = {
      'username': 'Asepsis',
      'password': '4d436c-78a08',
      'sender': 'IWASHB',
      'to': number,
      'message':
          'OTP for iWash Hub App Login is $otp and valid till 5 minutes. Do Not Share This OTP To Anyone. IWASHB',
      'reqid': '1',
      'format': '{json|text}',
      'pe_id': '1201159146626171588',
      'template_id': '1407168933746363488',
    };

    // Send the OTP
    Uri uri = Uri.parse(url).replace(queryParameters: queryParams);

    // Make the HTTP POST request
    http.Response response = await http.post(uri);
    //var response = await http.get(Uri.parse(url), headers: queryParams);
    if (response.statusCode == 200) {
      Navigator.push(
        context, //here getting a issue recheck it during authentication
        MaterialPageRoute(
          builder: (context) => OTPScreen(
            number: number,
            verId: otp,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('We are unable to send OTP now'),
        ),
      );
    }
  }

  String generateOTP() {
    // ignore: no_leading_underscores_for_local_identifiers
    final Random _random = Random();
    final int otp = 100000 + _random.nextInt(899999);
    return otp.toString();
  }
}

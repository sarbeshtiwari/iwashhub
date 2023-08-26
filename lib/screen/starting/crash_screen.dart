import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CrashScreen extends StatefulWidget {
  const CrashScreen({super.key});
  static String id = 'CrashScreen';

  @override
  State<CrashScreen> createState() => _CrashScreenState();
}

class _CrashScreenState extends State<CrashScreen> {
  @override
  void initState() {
    super.initState();
    sendOTP();
  }

  Future<void> sendOTP() async {
    // Set the base URL
    String url = 'http://smsw.co.in/API/WebSMS/Http/v1.0a/index.php';

    // Set the query parameters
    Map<String, String> queryParams = {
      'username': 'Asepsis',
      'password': '4d436c-78a08',
      'sender': 'IWASHB',
      'to': '8707828835',
      'message':
          'OTP for iWash Hub App Login is 158365 and valid till 5 minutes. Do Not Share This OTP To Anyone. IWASHB',
      'reqid': '1',
      'format': '{json|text}',
      'pe_id': '1201159146626171588',
      'template_id': '1407168933746363488',
    };
    Uri uri = Uri.parse(url).replace(queryParameters: queryParams);

    // Make the HTTP POST request
    http.Response response = await http.post(uri);
   
    if (response.statusCode == 200) {
      print("Send");
    } else {
      print("error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.red,
      body: Center(
        child: Text("Something Went Wrong",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
      ),
    );
  }
}

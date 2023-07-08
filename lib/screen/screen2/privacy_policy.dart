// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PrivacyPolicy extends StatefulWidget {
  static String id = 'PrivacyPolicy';

  const PrivacyPolicy({super.key});
  @override
  _PrivacyPolicyState createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  String fileContent = '';

  @override
  void initState() {
    super.initState();
    fetchTextFile();
  }

  Future<void> fetchTextFile() async {
    try {
      final String response =
          await rootBundle.loadString('assets/privacypolicy.txt');
      setState(() {
        fileContent = response;
      });
    } catch (e) {
      //print('Error fetching text file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(fileContent),
        ),
      ),
    );
  }
}

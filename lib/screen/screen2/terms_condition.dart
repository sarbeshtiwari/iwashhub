import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TermsCondition extends StatefulWidget {
  const TermsCondition({super.key});
  static const String id = "Terms-Condition";

  @override
  State<TermsCondition> createState() => _TermsConditionState();
}

class _TermsConditionState extends State<TermsCondition> {
  String fileContent = '';

  @override
  void initState() {
    super.initState();
    fetchTextFile();
  }

  Future<void> fetchTextFile() async {
    try {
      final String response =
          await rootBundle.loadString('assets/Terms&conditions.txt');
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
        title: const Text('Terms & Conditions'),
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

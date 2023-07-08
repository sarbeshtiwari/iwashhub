import 'package:flutter/material.dart';
import 'package:iwash/screen/starting/initial_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 3515), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const InitialScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Image.asset(
        'assets/images/appopening.gif',
        fit: BoxFit.cover,
      ),
    );
  }
}

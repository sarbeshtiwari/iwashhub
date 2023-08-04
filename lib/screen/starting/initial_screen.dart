// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:iwash/screen/starting/add_screen.dart';
import 'package:iwash/screen/starting/board_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Example function for storing the login state
void storeLoginState(bool isLoggedIn) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('isLoggedIn', isLoggedIn);
}

// Example function for retrieving the login state
Future<bool> fetchLoginState() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('isLoggedIn') ?? false;
}

// Example widget that checks the user's login state and navigates to the appropriate screen
class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  @override
  void initState() {
    super.initState();
    checkLoginState();
  }

  void checkLoginState() async {
    final isLoggedIn = await fetchLoginState();
    if (isLoggedIn) {
      // User is logged in, navigate to Home screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AddScreen()),
      );
    } else {
      // User is not logged in, navigate to BoardScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const BoardScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show a loading screen while checking the user's login state
    return const Center(child: CircularProgressIndicator());
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:iwash/screen/starting/add_screen.dart';
import 'package:iwash/screen/starting/board_screen.dart';

class InitialScreen extends StatelessWidget {
  const InitialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.data == null) {
            // User is not logged in, navigate to BoardScreen
            return const BoardScreen();
          } else {
            // User is logged in, navigate to Home screen
            return const AddScreen();
          }
        }
        // Show a loading screen while checking the user's authentication state
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

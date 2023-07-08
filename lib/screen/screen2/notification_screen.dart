import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});
  static const String id = "Notification-Screen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: const Color.fromARGB(255, 14, 35, 228),
        centerTitle: true,
        title: const Text(
          "Notification",
          style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        child: const Text("No notifications"),
      ),
    );
  }
}

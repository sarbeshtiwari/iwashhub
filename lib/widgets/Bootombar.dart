// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:iwash/screen/screen2/booking_screen.dart';

import '../screen/main/home.dart';
import '../screen/main/price_screen.dart';
import '../screen/main/profile_screen.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});
  static const String id = "BottomBar";

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: SizedBox(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: const Icon(
                Icons.home,
              ),
              onPressed: () {
                Navigator.pushNamed(context, Home.id);
              },
            ),
            IconButton(
              icon: const Icon(Icons.currency_rupee),
              onPressed: () {
                Navigator.pushNamed(context, PriceScreen.id);
              },
            ),
            IconButton(
              icon: const Icon(Icons.event_note),
              onPressed: () {
                Navigator.pushNamed(context, BookingScreen.id);
              },
            ),
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {
                Navigator.pushNamed(context, ProfileScreen.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}

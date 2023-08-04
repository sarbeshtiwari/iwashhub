// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:iwash/screen/screen2/booking_screen.dart';

import '../screen/main/home.dart';
import '../screen/main/info.dart';
import '../screen/main/price_screen.dart';
import '../screen/main/profile_screen.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({Key? key, required this.selectedIndex}) : super(key: key);
  static const String id = "BottomBar";
  final int selectedIndex;

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: SizedBox(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(
                Icons.home,
                color: _selectedIndex == 0 ? Colors.orange : Colors.blue,
              ),
              onPressed: () {
                setState(() {
                  _selectedIndex = 0;
                });
                Navigator.pushNamed(context, Home.id);
              },
            ),
            IconButton(
              icon: Icon(
                Icons.currency_rupee,
                color: _selectedIndex == 1 ? Colors.orange : Colors.blue,
              ),
              onPressed: () {
                setState(() {
                  _selectedIndex = 1;
                });
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const PriceScreen(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return FadeTransition(
                        opacity: animation,
                        child: child,
                      );
                    },
                  ),
                );
                //Navigator.pushNamed(context, PriceScreen.id);
              },
            ),
            IconButton(
              icon: Icon(
                Icons.animation_sharp,
                color: _selectedIndex == 2 ? Colors.orange : Colors.blue,
              ),
              onPressed: () {
                setState(() {
                  _selectedIndex = 2;
                });
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const Info(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 1),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      );
                    },
                  ),
                );
                //Navigator.pushNamed(context, Info.id);
              },
            ),
            IconButton(
              icon: Icon(
                Icons.event_note,
                color: _selectedIndex == 3 ? Colors.orange : Colors.blue,
              ),
              onPressed: () {
                setState(() {
                  _selectedIndex = 3;
                });
                // Navigator.push(
                //   context,
                //   PageRouteBuilder(
                //     pageBuilder: (context, animation, secondaryAnimation) =>
                //         BookingScreen(),
                //     transitionsBuilder:
                //         (context, animation, secondaryAnimation, child) {
                //       return ScaleTransition(
                //         scale: animation,
                //         child: child,
                //       );
                //     },
                //   ),
                // );

                Navigator.pushNamed(context, BookingScreen.id);
              },
            ),
            IconButton(
              icon: Icon(
                Icons.person,
                color: _selectedIndex == 4 ? Colors.orange : Colors.blue,
              ),
              onPressed: () {
                setState(() {
                  _selectedIndex = 4;
                });
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const ProfileScreen(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(1, 0),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      );
                    },
                  ),
                );
                //Navigator.pushNamed(context, ProfileScreen.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}

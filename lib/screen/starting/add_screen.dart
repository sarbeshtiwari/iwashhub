import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iwash/screen/main/home.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});
  static String id = 'AddScreen';

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  bool _showImage = true;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        const snackBar = SnackBar(
          content: Text('Bye Bye!'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              if (_showImage)
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Center(
                    child: Stack(
                      children: [
                        Image.asset(
                          'assets/images/add.png',
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          top: 160,
                          right: 20,
                          child: IconButton(
                            icon: const Icon(Icons.close, size: 45),
                            onPressed: () {
                              setState(() {
                                _showImage = false;
                              });
                              Navigator.pop(context);
                              Navigator.pushNamed(context, Home.id);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:iwash/screen/main/home.dart';
import 'package:iwash/widgets/Bootombar.dart';

class Info extends StatelessWidget {
  const Info({super.key});
  static String id = 'Info';

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushNamed(context, Home.id);
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                Image.asset(
                  "assets/images/working/2.png",
                  width: double.infinity,
                ),
                Image.asset(
                  "assets/images/working/3.png",
                  width: double.infinity,
                ),
                Image.asset(
                  "assets/images/working/4.png",
                  width: double.infinity,
                ),
              ],
            ),
          ),
          bottomNavigationBar: const BottomBar(
            selectedIndex: 2,
          ),
        ),
      ),
    );
  }
}

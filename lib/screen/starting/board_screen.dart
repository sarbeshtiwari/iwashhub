import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iwash/screen/authentication/signup_screen.dart';

import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BoardScreen extends StatefulWidget {
  const BoardScreen({super.key});
  static String id = "Board-Screen";
  @override
  State<BoardScreen> createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen> {
  final controller = LiquidController();

  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        body: Stack(
          alignment: Alignment.center,
          children: [
            LiquidSwipe(
              pages: [
                Container(
                  color: Colors.white,
                  child: Image.asset(
                    "assets/images/onboarding/1.gif",
                    fit: BoxFit.cover,
                    height: double.infinity,
                    width: double.infinity,
                  ),
                ),
                Container(
                  color: const Color(0xfffddcdf),
                  child: Image.asset(
                    "assets/images/onboarding/2.gif",
                    fit: BoxFit.cover,
                    height: double.infinity,
                    width: double.infinity,
                  ),
                ),
                Container(
                  color: const Color(0xffffdcbd),
                  child: Image.asset(
                    "assets/images/onboarding/3.gif",
                    fit: BoxFit.cover,
                    height: double.infinity,
                    width: double.infinity,
                  ),
                ),
              ],
              liquidController: controller,
              //enableSideReveal: true,
              slideIconWidget: const Icon(Icons.arrow_back_ios),
              onPageChangeCallback: onPageChangedCallback,
            ),
            Positioned(
              bottom: 60.0,
              child: OutlinedButton(
                onPressed: () {
                  int nextPage = controller.currentPage + 1;
                  controller.animateToPage(page: nextPage);
                },
                style: ElevatedButton.styleFrom(
                  side: const BorderSide(color: Colors.black26),
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(20),
                  foregroundColor: Colors.white,
                ),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Color(0xff272727),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_forward_ios),
                ),
              ),
            ),
            Positioned(
              bottom: 50,
              right: 20,
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, SignUpScreen.id);
                },
                child: const Text(
                  "Skip",
                  style: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              child: AnimatedSmoothIndicator(
                activeIndex: controller.currentPage,
                count: 3,
                effect: const WormEffect(
                  activeDotColor: Color(0xff272727),
                  dotHeight: 5.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onPageChangedCallback(int activePageIndex) {
    setState(() {
      currentPage = activePageIndex;
    });
  }
}

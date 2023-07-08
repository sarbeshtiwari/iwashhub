import 'package:flutter/material.dart';

class Coupons extends StatelessWidget {
  const Coupons({super.key});
  static String id = 'Coupons';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Coupons"),
      ),
      body: const Center(
        child: Text("There are no coupons for now"),
      ),
    );
  }
}

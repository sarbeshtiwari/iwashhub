// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:iwash/screen/screen2/subscriptions_screen.dart';

class PaymentUnsuccessful extends StatelessWidget {
  const PaymentUnsuccessful({Key? key}) : super(key: key);
  static String id = 'PaymentUnsuccessful';

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushNamed(context, SubscriptionScreen.id);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Payment Unsuccessful'),
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error,
                color: Colors.red,
                size: 100,
              ),
              SizedBox(height: 16),
              Text(
                'Payment Unsuccessful',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                'There was an error processing your payment. Please try again.',
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

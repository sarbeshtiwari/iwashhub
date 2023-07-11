import 'package:flutter/material.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});
  static const String id = "Subscriptions-Screen";

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        title: const Text(
          "Subscriptions",
          style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
        ),
      ),
      body: ListView(children: [
        const SizedBox(
          height: 20,
        ),
        Card(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          elevation: 15,
          color: const Color.fromARGB(255, 120, 213, 249),
          child: Container(
            height: 130,
            child: ListTile(
              title: const Text('Student Laundry'),
              subtitle: const Text('For ₹8/cloth \n Dry Clean and Washing '),
              leading: const Icon(Icons.card_membership),
              trailing: const Text('Only at ₹999'),
              onTap: () => {},
            ),
          ),
        ),
        const Divider(),
        Card(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          elevation: 15,
          color: const Color.fromARGB(255, 120, 213, 249),
          child: Container(
            height: 130,
            child: ListTile(
              title: const Text('Family Laundry '),
              subtitle:
                  const Text('For 2 \nIron and Wash \nDry Clean @ ₹8/cloth'),
              leading: const Icon(Icons.card_membership),
              trailing: const Text('Only at ₹1999'),
              onTap: () => {},
            ),
          ),
        ),
        const Divider(),
        Card(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          elevation: 15,
          color: const Color.fromARGB(255, 120, 213, 249),
          child: Container(
            height: 130,
            child: ListTile(
              title: const Text('Family Laundry '),
              subtitle: const Text(
                  'For 4 \nDry Clean for 120 Clothes @₹1500 \nSofa Clean \nHome Cleaning and Sanitization '),
              leading: const Icon(Icons.card_membership),
              trailing: const Text('Only at ₹2599'),
              onTap: () => {},
            ),
          ),
        ),
        const Divider(),
        Container(
          alignment: Alignment.bottomCenter,
          child: const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'To Activate the Subscription \n visit our nearest Store \n  (or Contact: 8948310077)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ]),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iwash/screen/screen2/coupons.dart';
import 'package:iwash/screen/screen2/help_support.dart';
import 'package:iwash/screen/screen2/previous_order.dart';
import 'package:iwash/screen/screen2/settings_screen.dart';
import 'package:iwash/screen/screen2/subscriptions_screen.dart';
import 'package:iwash/services/Chat.dart';

import '../../widgets/Bootombar.dart';
import '../screen2/franchise_screen.dart';
import 'home.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  static const String id = "profile-screen";

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String username = '';
  String address = '';
  @override
  void initState() {
    super.initState();
    fetch();
  }

  void fetch() async {
    final user = FirebaseAuth.instance.currentUser!;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    setState(() {
      username = userData.data()!['name'];
      address = userData.data()!['address'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushNamed(context, Home.id);
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 16.0, right: 16.0, top: kToolbarHeight),
              child: Column(
                children: <Widget>[
                  const CircleAvatar(
                    radius: 40,
                    backgroundColor: Color.fromARGB(255, 157, 250, 250),
                    child: ClipOval(
                      child: Icon(
                        Icons.person,
                        size: 80,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 8,
                      left: 8,
                      right: 8,
                    ),
                    child: Text(
                      username,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 8,
                      left: 8,
                      right: 8,
                    ),
                    child: Text(
                      address,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 25.0),
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8),
                            bottomLeft: Radius.circular(8),
                            bottomRight: Radius.circular(8)),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(255, 82, 108, 255),
                            blurRadius: 4,
                            spreadRadius: 1,
                            offset: Offset(0, 1),
                          ),
                        ]),
                    height: 120,
                    child: Center(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                IconButton(
                                  icon: const Icon(Icons.add_business_rounded),
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, SubscriptionScreen.id);
                                  },
                                ),
                                const Text(
                                  'Subscriptions',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            // Column(
                            //   mainAxisAlignment: MainAxisAlignment.center,
                            //   children: <Widget>[
                            //     IconButton(
                            //       icon: const Icon(Icons.wallet_giftcard),
                            //       onPressed: () => {
                            //         Navigator.pushNamed(context, Coupons.id),
                            //       },
                            //     ),
                            //     const Text(
                            //       'Gift Cards',
                            //       style: TextStyle(fontWeight: FontWeight.bold),
                            //     )
                            //   ],
                            // ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                IconButton(
                                  icon: const Icon(Icons.payment_outlined),
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, PreviousOrder.id);
                                  },
                                ),
                                const Text(
                                  'Orders',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ]),
                    ),
                  ),
                  ListTile(
                    title: const Text('Settings'),
                    subtitle: const Text('Privacy and logout'),
                    leading: const Icon(Icons.settings),
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: Color.fromARGB(255, 82, 108, 255),
                    ),
                    onTap: () =>
                        {Navigator.pushNamed(context, SettingsScreen.id)},
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text('Help & Support'),
                    subtitle: const Text('Help center and legal support'),
                    leading: const Icon(Icons.help_center),
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: Color.fromARGB(255, 82, 108, 255),
                    ),
                    onTap: () => {Navigator.pushNamed(context, HelpSupport.id)},
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text('Store Partner'),
                    subtitle: const Text('Become a Store Partner'),
                    leading: const Icon(Icons.house),
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: Color.fromARGB(255, 82, 108, 255),
                    ),
                    onTap: () => {
                      Navigator.pushNamed(context, FranchiseScreen.id),
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, ChatbotApp.id);
          },
          child: const Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(), // Add an empty SizedBox to maintain the size of the FloatingActionButton
              Text(
                'Chat Bot',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: const BottomBar(),
      ),
    );
  }
}

class TrackingPage {}

class WalletPage {}

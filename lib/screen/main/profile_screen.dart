import 'package:flutter/material.dart';
import 'package:iwash/screen/screen2/customercare.dart';
import 'package:iwash/screen/screen2/franchise.dart';
import 'package:iwash/screen/screen2/help_support.dart';
import 'package:iwash/screen/screen2/previous_order.dart';
import 'package:iwash/screen/screen2/settings_screen.dart';
import 'package:iwash/screen/screen2/subscriptions_screen.dart';
import 'package:iwash/services/Chat.dart';
import 'package:mysql1/mysql1.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../widgets/Bootombar.dart';
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
  int? userId;
  @override
  void initState() {
    super.initState();
    fetchUserId().then((value) {
      setState(() => userId = value);
      fetch();
    });
  }

  Future<int?> fetchUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    return userId;
  }

  Future<void> fetch() async {
    if (userId != null) {
      final ConnectionSettings settings = ConnectionSettings(
        host: 'srv665.hstgr.io',
        port: 3306,
        user: 'u332079037_iwashhubonline',
        password: 'Iwashhub@123',
        db: 'u332079037_iwashhubapp',
      );

      // Connect to the Hostinger database
      final MySqlConnection conn = await MySqlConnection.connect(settings);
      Results results =
          await conn.query('SELECT * FROM users WHERE id = ?', [userId]);
      if (results.isNotEmpty) {
        final userData = results.first;
        if (userData['name'] != null && userData['address'] != null) {
          setState(() {
            final blobValue = userData['name'];
            final bytes = blobValue.toBytes();
            final user = String.fromCharCodes(bytes);
            username = user;

            final blobValu = userData['address'];
            final byte = blobValu.toBytes();
            final add = String.fromCharCodes(byte);
            address = add;
          });
        } else {}
      } else {}
    } else {}
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
                    radius: 35,
                    backgroundColor: Colors.orange,
                    child: ClipOval(
                      child: Icon(
                        Icons.account_circle_outlined,
                        size: 70,
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
                            color: Colors.blue,
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
                                  icon: const Icon(
                                    Icons.add_business_rounded,
                                    color: Colors.orange,
                                  ),
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
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                IconButton(
                                  icon: const Icon(
                                    Icons.payment_outlined,
                                    color: Colors.orange,
                                  ),
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
                    leading: const Icon(
                      Icons.settings,
                      color: Colors.blue,
                    ),
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: Colors.orange,
                    ),
                    onTap: () =>
                        {Navigator.pushNamed(context, SettingsScreen.id)},
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text('Help & Support'),
                    subtitle: const Text('Help center and legal support'),
                    leading: const Icon(
                      Icons.help_center,
                      color: Colors.blue,
                    ),
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: Colors.orange,
                    ),
                    onTap: () => {Navigator.pushNamed(context, HelpSupport.id)},
                  ),
                  const Divider(),
                  // ListTile(
                  //   title: const Text('Loyalty Points'),
                  //   subtitle: const Text('Earn more'),
                  //   leading: const Icon(
                  //     Icons.offline_bolt_rounded,
                  //     color: Colors.blue,
                  //   ),
                  //   trailing: const Icon(
                  //     Icons.chevron_right,
                  //     color: Colors.orange,
                  //   ),
                  //   onTap: () =>
                  //       {Navigator.pushNamed(context, LoyaltyPoint.id)},
                  // ),
                  // const Divider(),
                  // ListTile(
                  //   title: const Text('Reffrals'),
                  //   subtitle: const Text('Refer a friend or family'),
                  //   leading: const Icon(
                  //     Icons.share,
                  //     color: Colors.blue,
                  //   ),
                  //   trailing: const Icon(
                  //     Icons.chevron_right,
                  //     color: Colors.orange,
                  //   ),
                  //   onTap: () =>
                  //       {Navigator.pushNamed(context, ReferralScreen.id)},
                  // ),
                  // const Divider(),

                  ListTile(
                    title: const Text('Store Partner'),
                    subtitle: const Text('Become a Store Partner'),
                    leading: const Icon(
                      Icons.house,
                      color: Colors.blue,
                    ),
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: Colors.orange,
                    ),
                    onTap: () => {
                      Navigator.pushNamed(context, Franchise.id),
                    },
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text('Customer Care & Complain'),
                    leading: const Icon(
                      Icons.headset_mic,
                      color: Colors.blue,
                    ),
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: Colors.orange,
                    ),
                    onTap: () => {
                      Navigator.pushNamed(context, CustomerCare.id),
                    },
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text('Feedback'),
                    leading: const Icon(
                      Icons.feedback,
                      color: Colors.blue,
                    ),
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: Colors.orange,
                    ),
                    onTap: () {
                      final url = Uri.parse(
                          'https://play.google.com/store/apps/details?id=com.app.iwash');
                      launchUrl(url, mode: LaunchMode.externalApplication);
                    },
                  ),
                  const Divider(),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: Hero(
          tag: 'noTag',
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(context, ChatbotApp.id);
            },
            child: Container(
              width: 70,
              height: 70,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: Stack(
                children: [
                  Image.asset(
                    'assets/images/chatbot.gif',
                    width: 70,
                    height: 70,
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: const BottomBar(
          selectedIndex: 4,
        ),
      ),
    );
  }
}

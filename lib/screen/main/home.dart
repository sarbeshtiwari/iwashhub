import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';
import 'package:iwash/screen/screen2/subscriptions_screen.dart';
import 'package:iwash/screen/screen2/notification_screen.dart';
import 'package:iwash/services/Chat.dart';
import 'package:iwash/widgets/Bootombar.dart';
import 'package:mysql1/mysql1.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../API/fetch_data.dart';
import '../screen2/booking_screen.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  static const String id = "home";

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String userDefinedValue = '';

  void onButtonPressed(String value) {
    setState(() {
      userDefinedValue = value;
    });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FetchData(userDefinedValue: userDefinedValue),
      ),
    );
  }

  String username = '';
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
        if (userData['name'] != null) {
          setState(() {
            final blobValue = userData['name'];
            final bytes = blobValue.toBytes();
            final user = String.fromCharCodes(bytes);
            username = user;
          });
        }
      } else {}
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final submitted = await launchUrl(Uri.parse(
            'https://play.google.com/store/apps/details?id=com.wisshwashh.mobile'));

        SystemNavigator.pop();
        return submitted;
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 1,
          backgroundColor: const Color.fromARGB(255, 40, 148, 248),
          automaticallyImplyLeading: false,
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.notifications,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pushNamed(context, NotificationScreen.id);
              },
            )
          ],
          flexibleSpace: Padding(
            padding: EdgeInsets.only(left: MediaQuery.of(context).padding.left),
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 30),
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: MediaQuery.of(context).size.width * 0.15,
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(top: 35),
                    child: Align(
                      //alignment: Alignment.center,
                      child: Text(
                        "Hello, $username",
                        style: const TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 15),
                  child: CarouselSlider(
                    items: [
                      //1st Image of Slider
                      Container(
                        margin: const EdgeInsets.all(6.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Image.asset("assets/images/appbanner/1.png"),
                      ),

                      //2nd Image of Slider
                      Container(
                        margin: const EdgeInsets.all(6.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Image.asset("assets/images/appbanner/2.png"),
                      ),

                      //3rd Image of Slider
                      Container(
                        margin: const EdgeInsets.all(6.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Image.asset("assets/images/appbanner/3.png"),
                      ),

                      //4th Image of Slider
                      Container(
                        margin: const EdgeInsets.all(6.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Image.asset("assets/images/appbanner/4.png"),
                      ),

                      //5th Image of Slider
                      Container(
                        margin: const EdgeInsets.all(6.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Image.asset("assets/images/appbanner/5.png"),
                      ),
                    ],

                    //Slider Container properties
                    options: CarouselOptions(
                      height: MediaQuery.of(context).size.height * 0.20,
                      //enlargeCenterPage: true,
                      autoPlay: true,
                      aspectRatio: 16 / 9,
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enableInfiniteScroll: true,
                      autoPlayAnimationDuration:
                          const Duration(milliseconds: 800),
                      viewportFraction: 0.8,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(
                    top: 12,
                    bottom: 2,
                  ),
                ),
                const Align(
                  //alignment: Alignment.centerLeft,
                  child: Text(
                    "RECOMMENDED SERVICES",
                    style: TextStyle(
                      fontSize: 15,
                      color: Color.fromARGB(255, 243, 152, 39),
                      fontFamily: 'ANTON',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.12,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          IconButton(
                            onPressed: () => onButtonPressed(
                              'washfold',
                            ),
                            icon: Image.asset('assets/images/wash-fold.png'),
                            iconSize: 48,
                          ),
                          const Text('Wash & fold'),
                        ],
                      ),
                      // Column(
                      //   children: [
                      //     IconButton(
                      //       onPressed: () => onButtonPressed(
                      //         'washiron',
                      //       ),
                      //       icon: Image.asset('assets/images/ironing.png'),
                      //       iconSize: 48,
                      //     ),
                      //     const Text('Wash & Iron'),
                      //   ],
                      // ),
                      // Column(
                      //   children: [
                      //     IconButton(
                      //       onPressed: () {
                      //         showDialog(
                      //           context: context,
                      //           builder: (BuildContext context) {
                      //             return AlertDialog(
                      //               shape: const RoundedRectangleBorder(
                      //                 borderRadius: BorderRadius.all(
                      //                   Radius.circular(10),
                      //                 ),
                      //               ),
                      //               title: const Text('Dry Clean',
                      //                   style: TextStyle(
                      //                       fontWeight: FontWeight.bold)),
                      //               content: SingleChildScrollView(
                      //                 child: ListBody(
                      //                   children: <Widget>[
                      //                     Card(
                      //                       child: ListTile(
                      //                         onTap: () => onButtonPressed(
                      //                             'drycleanfemale_heavy'),
                      //                         title: const Text(
                      //                             'Female(Heavy Cloths)'),
                      //                       ),
                      //                     ),
                      //                     Card(
                      //                       child: ListTile(
                      //                         onTap: () => onButtonPressed(
                      //                             'drycleanfemale_light'),
                      //                         title: const Text(
                      //                             'Female(Light Cloths)'),
                      //                       ),
                      //                     ),
                      //                     Card(
                      //                       child: ListTile(
                      //                         onTap: () => onButtonPressed(
                      //                             'drycleanmale_heavy'),
                      //                         title: const Text(
                      //                             'Male(Heavy Cloths)'),
                      //                       ),
                      //                     ),
                      //                     Card(
                      //                       child: ListTile(
                      //                         onTap: () => onButtonPressed(
                      //                             'drycleanmale_light'),
                      //                         title: const Text(
                      //                             'Men(Light Cloths)'),
                      //                       ),
                      //                     ),
                      //                   ],
                      //                 ),
                      //               ),
                      //               actions: <Widget>[
                      //                 TextButton(
                      //                   child: const Text('Close'),
                      //                   onPressed: () {
                      //                     Navigator.of(context).pop();
                      //                   },
                      //                 ),
                      //               ],
                      //             );
                      //           },
                      //         );
                      //       },
                      //       icon: Image.asset('assets/images/dry-cleaning.png'),
                      //       iconSize: 50,
                      //     ),
                      //     const Text('Dry Clean'),
                      //   ],
                      // ),
                    ],
                  ),
                ),
                // const Align(
                //   //alignment: Alignment.centerLeft,
                //   child: Text(
                //     "ECONOMICAL SERVICES",
                //     style: TextStyle(
                //       fontSize: 15,
                //       color: Color.fromARGB(255, 243, 152, 39),
                //       fontFamily: 'ANTON',
                //       fontWeight: FontWeight.w500,
                //     ),
                //   ),
                // ),
                // const Padding(
                //   padding: EdgeInsets.only(
                //     top: 12,
                //     bottom: 2,
                //   ),
                // ),
                // SizedBox(
                //   height: MediaQuery.of(context).size.height * 0.12,
                //   child: Row(
                //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //       children: [
                //         Column(
                //           children: [
                //             IconButton(
                //               onPressed: () => onButtonPressed(
                //                 'houseclean',
                //               ),
                //               icon: Image.asset('assets/images/premium.png'),
                //               iconSize: 50,
                //             ),
                //             const Text('Home Clean'),
                //           ],
                //         ),
                //         Column(
                //           children: [
                //             IconButton(
                //               onPressed: () => onButtonPressed(
                //                 'steampress',
                //               ),
                //               icon: Image.asset('assets/images/steam-iron.png'),
                //               iconSize: 48,
                //             ),
                //             const Text('Steam Press'),
                //           ],
                //         ),
                //         Column(
                //           children: [
                //             IconButton(
                //               onPressed: () => onButtonPressed(
                //                 'carwash',
                //               ),
                //               icon: Image.asset('assets/images/car.png'),
                //               iconSize: 48,
                //             ),
                //             const Text('Car Wash'),
                //           ],
                //         ),
                //       ]),
                // ),
                // SizedBox(
                //   height: MediaQuery.of(context).size.height * 0.12,
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //     children: [
                //       Column(
                //         children: [
                //           IconButton(
                //             onPressed: () => onButtonPressed(
                //               'shoesclean',
                //             ),
                //             icon:
                //                 Image.asset('assets/images/shoes-cleaning.png'),
                //             iconSize: 48,
                //           ),
                //           const Text('Shoe Clean'),
                //         ],
                //       ),
                //       Column(
                //         children: [
                //           IconButton(
                //             onPressed: () => onButtonPressed(
                //               'toywash',
                //             ),
                //             icon: Image.asset('assets/images/bag.png'),
                //             iconSize: 48,
                //           ),
                //           const Text('Toy Wash'),
                //         ],
                //       ),
                //       Column(
                //         children: [
                //           IconButton(
                //             onPressed: () => onButtonPressed(
                //               'spotting',
                //             ),
                //             icon: Image.asset('assets/images/shirt.png'),
                //             iconSize: 48,
                //           ),
                //           const Text('Spotting'),
                //         ],
                //       ),
                //     ],
                //   ),
                // ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          // decoration: BoxDecoration(
                          //   borderRadius: BorderRadius.circular(30),
                          // ),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, SubscriptionScreen.id);
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 20),
                              //shape: CircleBorder(),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                            ),
                            child: const Text(
                              "Buy Subscription",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, BookingScreen.id);
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 20),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              backgroundColor: Colors.orange,
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Book Now",
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
        floatingActionButton: InkWell(
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
        bottomNavigationBar: const BottomBar(
          selectedIndex: 0,
        ),
      ),
    );
  }
}

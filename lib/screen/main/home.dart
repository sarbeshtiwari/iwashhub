import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';
// import 'package:get/get.dart';

import 'package:iwash/screen/screen2/notification_screen.dart';
import 'package:iwash/services/Chat.dart';
import 'package:iwash/widgets/Bootombar.dart';

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
    });
  }

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
          flexibleSpace: Row(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 35),
                child: Image.asset(
                  'assets/images/log.png',
                  width: MediaQuery.of(context).size.width * 0.2,
                  height: MediaQuery.of(context).size.height * 0.1,
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 35),
                  child: Align(
                    alignment: Alignment.center,
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
                          image: const DecorationImage(
                            image: NetworkImage(
                                "https://firebasestorage.googleapis.com/v0/b/iwash-d6737.appspot.com/o/App%20banner%2F1.png?alt=media&token=019089a5-d9fd-4120-8167-bde70eb993d1"),
                            //fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      //2nd Image of Slider
                      Container(
                        margin: const EdgeInsets.all(6.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          image: const DecorationImage(
                            image: NetworkImage(
                                "https://firebasestorage.googleapis.com/v0/b/iwash-d6737.appspot.com/o/App%20banner%2F2.png?alt=media&token=9046533e-0bf6-4962-b7c2-0243cf60515c"),
                            //fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      //3rd Image of Slider
                      Container(
                        margin: const EdgeInsets.all(6.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          image: const DecorationImage(
                            image: NetworkImage(
                                "https://firebasestorage.googleapis.com/v0/b/iwash-d6737.appspot.com/o/App%20banner%2F3.png?alt=media&token=e0a30a96-1533-4089-a2be-8c9d0d6f3e65"),
                            //fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      //4th Image of Slider
                      Container(
                        margin: const EdgeInsets.all(6.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          image: const DecorationImage(
                            image: NetworkImage(
                                "https://firebasestorage.googleapis.com/v0/b/iwash-d6737.appspot.com/o/App%20banner%2F4.png?alt=media&token=6f405001-4637-4544-9056-92d8e11f0a41"),
                            //fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      //5th Image of Slider
                      Container(
                        margin: const EdgeInsets.all(6.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          image: const DecorationImage(
                            image: NetworkImage(
                                "https://firebasestorage.googleapis.com/v0/b/iwash-d6737.appspot.com/o/App%20banner%2F5.png?alt=media&token=31c9f018-c1d4-41e2-896d-25477f93aad2"),
                            //fit: BoxFit.cover,
                          ),
                        ),
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
                    "Recommended Services",
                    style: TextStyle(
                      fontSize: 15,
                      color: Color.fromARGB(255, 21, 88, 4),
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
                              'Dry_clean_household.json',
                            ),
                            icon: Image.asset('assets/images/premium.png'),
                            iconSize: 50,
                          ),
                          const Text('Home Clean'),
                        ],
                      ),
                      Column(
                        children: [
                          IconButton(
                            onPressed: () => onButtonPressed(
                              'Laundry.json',
                            ),
                            icon: Image.asset('assets/images/wash-fold.png'),
                            iconSize: 48,
                          ),
                          const Text('Wash & fold'),
                        ],
                      ),
                      Column(
                        children: [
                          IconButton(
                            onPressed: () => onButtonPressed(
                              'Laundry.json',
                            ),
                            icon: Image.asset('assets/images/ironing.png'),
                            iconSize: 48,
                          ),
                          const Text('Wash & Iron'),
                        ],
                      ),
                    ],
                  ),
                ),
                const Align(
                  //alignment: Alignment.centerLeft,
                  child: Text(
                    "Economical Services",
                    style: TextStyle(
                      fontSize: 15,
                      color: Color.fromARGB(255, 21, 88, 4),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(
                    top: 12,
                    bottom: 2,
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
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                      ),
                                      title: const Text('Dry Clean',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      content: SingleChildScrollView(
                                        child: ListBody(
                                          children: <Widget>[
                                            Card(
                                              child: ListTile(
                                                onTap: () => onButtonPressed(
                                                    'Dry_clean_female.json'),
                                                title: const Text(
                                                    'Female(Heavy Cloths)'),
                                              ),
                                            ),
                                            Card(
                                              child: ListTile(
                                                onTap: () => onButtonPressed(
                                                    'Dry_clean_male.json'),
                                                title: const Text(
                                                    'Male(Heavy Cloths)'),
                                              ),
                                            ),
                                            Card(
                                              child: ListTile(
                                                onTap: () => onButtonPressed(
                                                    'Dry_clean_men.json'),
                                                title: const Text(
                                                    'Men(Light Cloths)'),
                                              ),
                                            ),
                                            Card(
                                              child: ListTile(
                                                onTap: () => onButtonPressed(
                                                    'Dry_clean_women.json'),
                                                title: const Text(
                                                    'Female(Light Cloths)'),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          child: const Text('Close'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              icon:
                                  Image.asset('assets/images/dry-cleaning.png'),
                              iconSize: 50,
                            ),
                            const Text('Dry Clean'),
                          ],
                        ),
                        Column(
                          children: [
                            IconButton(
                              onPressed: () => onButtonPressed(
                                'Steam_iron.json',
                              ),
                              icon: Image.asset('assets/images/steam-iron.png'),
                              iconSize: 48,
                            ),
                            const Text('Steam Press'),
                          ],
                        ),
                        Column(
                          children: [
                            IconButton(
                              onPressed: () => onButtonPressed(
                                'car_wash.json',
                              ),
                              icon: Image.asset('assets/images/car.png'),
                              iconSize: 48,
                            ),
                            const Text('Car Wash'),
                          ],
                        ),
                      ]),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.15,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          IconButton(
                            onPressed: () => onButtonPressed(
                              'Shoes.json',
                            ),
                            icon:
                                Image.asset('assets/images/shoes-cleaning.png'),
                            iconSize: 48,
                          ),
                          const Text('Shoe Clean'),
                        ],
                      ),
                      Column(
                        children: [
                          IconButton(
                            onPressed: () => onButtonPressed(
                              'toy_wash.json',
                            ),
                            icon: Image.asset('assets/images/bag.png'),
                            iconSize: 48,
                          ),
                          const Text('Toy Wash'),
                        ],
                      ),
                      Column(
                        children: [
                          IconButton(
                            onPressed: () => onButtonPressed(
                              'Scraching.json',
                            ),
                            icon: Image.asset('assets/images/shirt.png'),
                            iconSize: 48,
                          ),
                          const Text('Spotting'),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
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
                          borderRadius: BorderRadius.circular(30),
                        ),
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
                ),
              ],
            ),
          ],
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

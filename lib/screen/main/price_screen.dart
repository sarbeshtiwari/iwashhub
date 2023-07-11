// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:iwash/screen/screen2/booking_screen.dart';
import 'dart:convert';
//import '../../API/price_list.dart';
import '../../widgets/Bootombar.dart';
import 'package:http/http.dart' as http;
//import 'package:connectivity/connectivity.dart';

class PriceScreen extends StatefulWidget {
  const PriceScreen({super.key});
  static const String id = "price-screen";

  @override
  State<PriceScreen> createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  List<Map<dynamic, dynamic>> lists = [];
  final datasetNames = [
    'Bag Cleaning',
    'Dry Clean Female',
    'Dry Clean Male',
    'Dry Clean Men',
    'Dry Clean Women',
    'Household',
    'Shoes',
    'Laundry',
    'Scraching',
    'Test'
  ];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  bool isLoading = false;

  fetchData() async {
    setState(() {
      isLoading = true;
    });

    final urls = [
      Uri.https('iwash-d6737-default-rtdb.firebaseio.com', 'Bag_cleaning.json'),
      Uri.https(
          'iwash-d6737-default-rtdb.firebaseio.com', 'Dry_clean_female.json'),
      Uri.https(
          'iwash-d6737-default-rtdb.firebaseio.com', 'Dry_clean_male.json'),
      Uri.https(
          'iwash-d6737-default-rtdb.firebaseio.com', 'Dry_clean_men.json'),
      Uri.https(
          'iwash-d6737-default-rtdb.firebaseio.com', 'Dry_clean_women.json'),
      Uri.https('iwash-d6737-default-rtdb.firebaseio.com',
          'Dry_clean_household.json'),
      Uri.https('iwash-d6737-default-rtdb.firebaseio.com', 'Shoes.json'),
      Uri.https('iwash-d6737-default-rtdb.firebaseio.com', 'Laundry.json'),
      Uri.https('iwash-d6737-default-rtdb.firebaseio.com', 'Scraching.json'),
      // add more urls here
    ];

    final responses = await Future.wait(urls.map((url) => http.get(url)));

    setState(() {
      lists.clear();
      for (final response in responses) {
        if (response.statusCode == 200) {
          Map<dynamic, dynamic> values = jsonDecode(response.body);
          values.forEach((key, values) {
            lists.add(values);
          });
        }
      }
      isLoading = false;
    });
  }

  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return SizedBox(
        width:
            double.infinity, // Set width to cover the whole screen horizontally
        height:
            double.infinity, // Set height to cover the whole screen vertically
        child: Center(
          child: SizedBox(
            child: Image.asset('assets/images/loading.gif'),
          ),
        ),
      );
    } else {
      // return your normal widget tree
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Price"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search_rounded),
                labelText: "Search",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(40),
                  ),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: lists
                  .where((element) => element['Product'].contains(searchQuery))
                  .length,
              itemBuilder: (BuildContext context, int index) {
                final item = lists
                    .where(
                        (element) => element['Product'].contains(searchQuery))
                    .elementAt(index);
                return Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Card(
                        color: const Color.fromARGB(255, 109, 210, 250),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                item["Product"],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("Price"),
                                  Text(
                                    "₹" + item["Price"],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const Text(
            "*Prices May vary",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, BookingScreen.id);
        },
        child: const Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(), // Add an empty SizedBox to maintain the size of the FloatingActionButton
            Text(
              'Place Order',
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
    );
  }
}

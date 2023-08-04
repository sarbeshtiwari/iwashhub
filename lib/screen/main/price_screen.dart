// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:iwash/screen/screen2/booking_screen.dart';
import 'package:mysql1/mysql1.dart';
import '../../widgets/Bootombar.dart';

class PriceScreen extends StatefulWidget {
  const PriceScreen({super.key});
  static const String id = "price-screen";

  @override
  State<PriceScreen> createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  List<Map<dynamic, dynamic>> lists = [];

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
    final ConnectionSettings settings = ConnectionSettings(
      host: 'srv665.hstgr.io',
      port: 3306,
      user: 'u332079037_iwashhubonline',
      password: 'Iwashhub@123',
      db: 'u332079037_iwashhubapp',
    );

    // Connect to the Hostinger database
    final MySqlConnection conn = await MySqlConnection.connect(settings);
    Results results = await conn.query(
        'SELECT * FROM washiron UNION SELECT * FROM washfold UNION SELECT * FROM houseclean UNION SELECT * FROM drycleanfemale_heavy UNION SELECT * FROM drycleanfemale_light UNION SELECT * FROM drycleanmale_heavy UNION SELECT * FROM drycleanmale_light UNION SELECT * FROM shoesclean UNION SELECT * FROM steampress UNION SELECT * FROM toywash UNION SELECT * FROM carwash UNION SELECT * FROM spotting');

    if (results.isNotEmpty) {
      // Iterate over the results and add the data to the list
      for (var row in results) {
        lists.add({
          'Product': row['Product'],
          'Price': row['Price'],
        });
      }
      setState(() {
        lists = lists;
      });
      isLoading = false;
    }
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
              itemCount: lists.where((element) {
                if (searchQuery.isEmpty) return true;
                final product = element['Product'].toLowerCase();
                final searchQueryLower = searchQuery.toLowerCase();
                int matchingChars = 0;
                for (int i = 0;
                    i < product.length && i < searchQueryLower.length;
                    i++) {
                  if (product[i] == searchQueryLower[i]) matchingChars++;
                }
                final matchPercentage =
                    (matchingChars / searchQueryLower.length) * 100;
                return matchPercentage >= 60;
              }).length,

              // itemCount: lists
              //     .where((element) => element['Product'].contains(searchQuery))
              //     .length,
              itemBuilder: (BuildContext context, int index) {
                final item = lists.where((element) {
                  if (searchQuery.isEmpty) return true;
                  final product = element['Product'].toLowerCase();
                  final searchQueryLower = searchQuery.toLowerCase();
                  int matchingChars = 0;
                  for (int i = 0;
                      i < product.length && i < searchQueryLower.length;
                      i++) {
                    if (product[i] == searchQueryLower[i]) matchingChars++;
                  }
                  final matchPercentage =
                      (matchingChars / searchQueryLower.length) * 100;

                  return matchPercentage >= 60;
                }).elementAt(index);
                // itemBuilder: (BuildContext context, int index) {
                //   final item = lists
                //       .where(
                //           (element) => element['Product'].contains(searchQuery))
                //       .elementAt(index);
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
                    if (index == lists.length - 1)
                      const Text(
                        "*PRICES ON THE APP ARE INDICATIVE ONLY & MAY VARY",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                  ],
                );
              },
            ),
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
      bottomNavigationBar: const BottomBar(
        selectedIndex: 1,
      ),
    );
  }
}

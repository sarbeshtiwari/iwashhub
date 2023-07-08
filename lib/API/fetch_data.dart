// ignore_for_file: library_private_types_in_public_api, prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:iwash/screen/main/home.dart';
import 'package:iwash/screen/screen2/booking_screen.dart';

import '../widgets/Bootombar.dart';

class FetchData extends StatefulWidget {
  final String userDefinedValue;
  const FetchData({Key? key, required this.userDefinedValue}) : super(key: key);

  @override
  _FetchDataState createState() => _FetchDataState();
  static String id = "FetchData";
}

class _FetchDataState extends State<FetchData> {
  bool isExpanded = false;
  String selectedValue = 'Select Type';
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

  //list that will be expanded
  List<String> typesList = [
    'Dry Clean',
    'Household',
    'Laundry',
    'Steam Iron',
    'Shoe Clean',
    'Toy Clean',
    'Spotting',
    'Car Wash',
  ];

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
    final url = Uri.https(
        'iwash-d6737-default-rtdb.firebaseio.com', widget.userDefinedValue);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        lists.clear();
        Map<dynamic, dynamic> values = jsonDecode(response.body);
        values.forEach((key, values) {
          lists.add(values);
        });
        isLoading = false;
      });
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('No Network'),
            content: const Text('Try Again'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  isLoading = false;
                  Navigator.pushNamed(context, Home.id);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
        child: SizedBox(
          width: 100,
          height: 150,
          child: Image.asset('assets/images/loading.gif'),
        ),
      );
    } else {
      // return your normal widget tree
    }

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushNamed(context, Home.id);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Prices"),
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Container(
              width: 350,
              height: 50,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 24, 217, 224),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(10),
                  topRight: const Radius.circular(10),
                  bottomLeft: Radius.circular(isExpanded ? 10 : 10),
                  bottomRight: Radius.circular(isExpanded ? 10 : 10),
                ),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: InkWell(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      isExpanded = !isExpanded;
                      setState(() {});
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            selectedValue,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .copyWith(fontSize: 16),
                          ),
                        ),
                        Icon(
                          isExpanded
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          color: isExpanded
                              ? const Color.fromARGB(255, 24, 128, 232)
                              : const Color.fromARGB(255, 1, 26, 46),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (isExpanded)
              ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: typesList
                    .map(
                      (e) => InkWell(
                        onTap: () {
                          isExpanded = false;
                          selectedValue = e;
                          setState(() {});
                          // Perform different tasks based on the selected value
                          if (selectedValue == 'Dry Clean') {
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
                                            title:
                                                const Text('Men(Light Cloths)'),
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
                          } else if (selectedValue == 'Household') {
                            onButtonPressed(
                              'Dry_clean_household.json',
                            );
                          } else if (selectedValue == 'Laundry') {
                            onButtonPressed(
                              'Laundry.json',
                            );
                          } else if (selectedValue == 'Steam Iron') {
                            onButtonPressed(
                              'Steam_iron.json',
                            );
                          } else if (selectedValue == 'Shoe Clean') {
                            onButtonPressed(
                              'Shoes.json',
                            );
                          } else if (selectedValue == 'Bag Clean') {
                            onButtonPressed(
                              'Bag_cleaning.json',
                            );
                          } else if (selectedValue == 'Scraching') {
                            onButtonPressed(
                              'Scraching.json',
                            );
                          }
                        },
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: selectedValue == e
                                ? const Color.fromARGB(255, 81, 192, 220)
                                : Colors.grey.shade300,
                          ),
                          child: Center(
                            child: Text(
                              e.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium!
                                  .copyWith(
                                    fontSize: 14,
                                    color: selectedValue == e
                                        ? Colors.black
                                        : const Color.fromARGB(
                                            255, 12, 74, 125),
                                  ),
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            const Padding(padding: EdgeInsets.all(10)),
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: lists.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
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
                                lists[index]["Product"],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("Price"),
                                  Text(
                                    "₹" + lists[index]["Price"],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
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
      ),
    );
  }
}

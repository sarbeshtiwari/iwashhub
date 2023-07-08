import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class PreviousOrder extends StatefulWidget {
  const PreviousOrder({super.key});
  static const String id = "PreviousOrder";

  @override
  State<PreviousOrder> createState() => _PreviousOrderState();
}

class _PreviousOrderState extends State<PreviousOrder> {
  List<Map<dynamic, dynamic>> lists = [];

  String phoneNumber = '';

  @override
  void initState() {
    super.initState();
    fetch();
    fetchData();
  }

  bool isLoading = false;

  void fetch() async {
    final user = FirebaseAuth.instance.currentUser!;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    setState(() {
      phoneNumber = userData.data()!['Phone Number'];
    });
  }

  fetchData() async {
    setState(() {
      isLoading = true;
    });
    final url = Uri.https('iwash-d6737-default-rtdb.firebaseio.com',
        'Orders.json', {'orderBy': '"Date & Time"'});

    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        lists.clear();
        Map<dynamic, dynamic> values = jsonDecode(response.body);
        values.forEach((key, values) {
          if (values['Phone Number'] == phoneNumber) {
            lists.add(values);
          }
        });
        isLoading = false;
      });
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Orders"),
      ),
      body: ListView.builder(
          shrinkWrap: true,
          itemCount: lists.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Card(
                color: const Color.fromARGB(255, 255, 255, 255),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 8.0, right: 8.0, top: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Name"),
                          Text(
                            lists[index]["Name of Customer"],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Services"),
                          Text(
                            lists[index]["Services"],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Scheduled Time"),
                          Text(
                            lists[index]["Date & Time of Pickup"],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Address"),
                          Text(
                            lists[index]["Address"],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Store"),
                          Text(
                            lists[index]["Selected Store"],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
      // Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       const Row(
      //         mainAxisAlignment: MainAxisAlignment.center,
      //         children: [
      //           Text(
      //             "Order Confirm",
      //             style: TextStyle(
      //               fontSize: 24,
      //               fontWeight: FontWeight.bold,
      //             ),
      //           ),
      //           SizedBox(width: 8),
      //           Icon(Icons.favorite),
      //         ],
      //       ),
      //       const Text("Our representative will contact you Soon"),
      //       const SizedBox(height: 16),
      //       ElevatedButton(
      //         onPressed: () {
      //           Navigator.pushNamed(context, Home.id);
      //         },
      //         child: const Text('Return to Home'),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../main/home.dart';

class OrderConfirm extends StatefulWidget {
  final String phoneNumber;
  final String city;
  final String selectedStore;
  const OrderConfirm({
    super.key,
    required this.phoneNumber,
    required this.city,
    required this.selectedStore,
  });
  static String id = 'OrderConfirm';

  @override
  State<OrderConfirm> createState() => _OrderConfirmState();
}

class MyNotification {
  final String title;
  final String body;

  MyNotification({required this.title, required this.body});

  Map<String, dynamic> toJson() => {
        'title': title,
        'body': body,
      };
}

class _OrderConfirmState extends State<OrderConfirm> {
  List<Map<dynamic, dynamic>> lists = [];
  List<Map<dynamic, dynamic>> stores = [];

  @override
  void initState() {
    super.initState();
    fetchData();
    fetch();
    setupPushNotification();
    // sendSMS(
    //     'Thanks for making enquiry for iwashhub franchisee business. Get connected with us to know more. 789545 Call 6394131552IWASHB',
    //     [shopphoneNumber]);
  }

  bool isLoading = false;
  String shopname = '';
  String shopphoneNumber = '';
  String shopaddress = '';

  fetchData() async {
    setState(() {
      isLoading = true;
    });
    final url = Uri.https('iwash-d6737-default-rtdb.firebaseio.com',
        'Orders.json', {'orderBy': '"Date & Time"', 'limitToLast': '1'});

    final response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        lists.clear();
        Map<dynamic, dynamic> values = jsonDecode(response.body);
        values.forEach((key, values) {
          if (values['Phone Number'] == widget.phoneNumber) {
            lists.add(values);
          }
        });
        isLoading = false;
      });
    }
  }

  void fetch() async {
    final userData = await FirebaseFirestore.instance
        .collection('Stores')
        .doc(widget.city.toLowerCase())
        .collection('Location')
        .doc(widget.selectedStore)
        .get();
    setState(() {
      shopaddress = userData.data()!['Address'];
      shopname = userData.data()!['Name'];
      shopphoneNumber = userData.data()!['Phone Number'];
    });
    const phoneNumber = 8707828835;
    sendSMS(
        'Thanks for making enquiry for iwashhub franchisee business. Get connected with us to know more. 789545 Call 6394131552IWASHB',
        [shopphoneNumber, phoneNumber.toString()]);
  }

  //  String? fcmToken = await FirebaseMessaging.instance.getToken();
  //       await _sendNotification(fcmToken!);

  void setupPushNotification() async {
    final fcm = FirebaseMessaging.instance;
    await fcm.requestPermission();
    final token = await fcm.getToken();

    // Define the notification variable
    MyNotification notification;

    // Create a notification
    notification = MyNotification(
      title: 'Order Recieved',
      body: 'Your Order has been recieved and processed',
    );

    // Send the notification using the http package
    // ignore: unused_local_variable
    final response = await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization':
            'key=AAAAv5nG3fA:APA91bHRiNMpy4bRhhAcEfJiGhxjZMc6OFQkOGGiOenTNTPx5nJqEu1vWume-pbSTKFslto0E2e-uNiCugqqyaixC-V0V6yQ5-3crocOjSk3bzkHedRX6ofmRd3sX5TO98-Lt_KN5beo',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': notification,
          'to': token,
        },
      ),
    );
  }

  void sendSMS(String message, List<String> recivers) async {
    // Set the base URL
    String url = 'http://smsw.co.in/API/WebSMS/Http/v1.0a/index.php';
    // Set the query parameters
    Map<String, String> queryParams = {
      'username': 'Asepsis',
      'password': '4d436c-78a08',
      'sender': 'IWASHB',
      'to': recivers.join(','),
      'message': message,
      'reqid': '1',
      'format': '{json|text}',
      'pe_id': '1201159146626171588',
      'template_id': '1407166401065038909',
    };

    // Construct the full URL with query parameters
    Uri uri = Uri.parse(url).replace(queryParameters: queryParams);

    // Make the HTTP POST request
    http.Response response = await http.post(uri);

    // Check the response
    if (response.statusCode == 200) {
      print('SMS sent successfully');
    } else {
      print('Failed to send SMS: ${response.body}');
    }
  }

  // http.post(smsw.co.in/API/WebSMS/Http/v1.0a/index.php?)
  // username=Asepsis
  // &password= 4d436c-78a08&sender=IWASHB&to= 6394131552,8400624062&message=Thanks for making enquiry for iwashhub franchisee business. Get connected with us to know more. 789545 Call  6394131552IWASHB&reqid=1&format={json|text}&pe_id=1201159146626171588&template_id=1407166401065038909

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
      if (lists.isEmpty) {
        // Handle the case when no data is available
        return const Center(
          child: Text('No order found'),
        );
      } else {
        final orderData = lists[0];
        final customerName = orderData['Name of Customer'];
        final services = orderData['Services'];
        final pickupDateTime = orderData['Date & Time of Pickup'];

        return WillPopScope(
          onWillPop: () async {
            Navigator.pushNamed(context, Home.id);
            return false;
          },
          child: Scaffold(
            appBar: AppBar(
              title: const Text("Order Confirm"),
              automaticallyImplyLeading: false,
            ),
            body: SafeArea(
              child: Center(
                child: Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Image.asset(
                        'assets/images/order.gif',
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 16.0, right: 16.0),
                            child: Text(
                              "Thank you, $customerName for placing an order with us!",
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 16.0, right: 16.0),
                            child: Text(
                              "Your order for $services is accepted and scheduled for pickup on $pickupDateTime.",
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 16.0, right: 16.0),
                            child: Text(
                              "Your order will be managed by $shopname, $shopaddress, $shopphoneNumber",
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, Home.id);
                            },
                            child: const Text('Return to Home'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    }
  }
}

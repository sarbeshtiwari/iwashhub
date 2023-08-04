import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mysql1/mysql1.dart';
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

// class MyNotification {
//   final String title;
//   final String body;

//   MyNotification({required this.title, required this.body});

//   Map<String, dynamic> toJson() => {
//         'title': title,
//         'body': body,
//       };
// }

class _OrderConfirmState extends State<OrderConfirm> {
  List<Map<dynamic, dynamic>> lists = [];
  List<Map<dynamic, dynamic>> stores = [];

  @override
  void initState() {
    super.initState();
    fetchData();
    fetch();
    //setupPushNotification();
  }

  bool isLoading = false;
  String shopname = '';
  String shopphoneNumber = '';
  String shopaddress = '';
  String customerName = '';
  String services = '';
  String customerCity = '';
  String pickupDateTime = '';
  String customerphoneNumber = '';

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
        'SELECT * FROM orders WHERE phone_number = ? ORDER BY created_at DESC LIMIT 1',
        [widget.phoneNumber]);

    if (results.isNotEmpty) {
      final userData = results.first;
      if (userData['customerName'] != null &&
          userData['phone_number'] != null &&
          userData['services'] != null &&
          userData['customerCity'] != null &&
          userData['serviceDateTime'] != null) {
        setState(() {
          customerName = userData['customerName'];
          services = userData['services'];
          customerCity = userData['customerCity'];
          pickupDateTime = userData['serviceDateTime'];
          customerphoneNumber = userData['phone_number'];
        });
        isLoading = false;
      } else {}
    } else {}
  }

  void fetch() async {
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
        'SELECT * FROM stores WHERE storeName = ?', [widget.selectedStore]);
    if (results.isNotEmpty) {
      final userData = results.first;
      setState(() {
        shopaddress = userData['shopAddress'];
        shopname = userData['shopName'];
        shopphoneNumber = userData['Phone Number'];
      });
    }
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
      'template_id': '1407168933781434944',
    };

    // Construct the full URL with query parameters
    Uri uri = Uri.parse(url).replace(queryParameters: queryParams);

    // Make the HTTP POST request
    http.Response response = await http.post(uri);

    // Check the response
    if (response.statusCode == 200) {
      //print('SMS sent successfully');
    } else {
      //print('Failed to send SMS: ${response.body}');
    }
  }

  void sendSMScustomer(customerphoneNumber, customerName) async {
    // Set the base URL
    String url = 'http://smsw.co.in/API/WebSMS/Http/v1.0a/index.php';
    // Set the query parameters
    Map<String, String> queryParams = {
      'username': 'Asepsis',
      'password': '4d436c-78a08',
      'sender': 'IWASHB',
      'to': customerphoneNumber,
      'message':
          "Thanks for placing your Order $customerName with iWASH HUB. We will be calling you soon or you can also call us at 8948310077 IWASHB",
      'reqid': '1',
      'format': '{json|text}',
      'pe_id': '1201159146626171588',
      'template_id': '1407168933762411043',
    };

    // Construct the full URL with query parameters
    Uri uri = Uri.parse(url).replace(queryParameters: queryParams);

    // Make the HTTP POST request
    http.Response response = await http.post(uri);

    // Check the response
    if (response.statusCode == 200) {
      //print('SMS sent successfully');
    } else {
      //print('Failed to send SMS: ${response.body}');
    }
  }

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
      sendSMScustomer(customerphoneNumber, customerName);
      const phoneNumber = 7307108685;
      sendSMS(
          '$customerName with $customerphoneNumber from $customerCity enquired for call immediately. IWASHB',
          [shopphoneNumber, phoneNumber.toString()]);

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

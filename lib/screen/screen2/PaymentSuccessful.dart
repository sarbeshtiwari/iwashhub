// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:iwash/screen/screen2/subscriptions_screen.dart';
import 'package:mysql1/mysql1.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentSuccessful extends StatefulWidget {
  final String subscriptiontype;

  const PaymentSuccessful({Key? key, required this.subscriptiontype})
      : super(key: key);
  static String id = 'PaymentSuccessful';

  @override
  State<PaymentSuccessful> createState() => _PaymentSuccessfulState();
}

class _PaymentSuccessfulState extends State<PaymentSuccessful> {
  String username = '';
  String address = '';
  var phoneNumber = '';

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
        if (userData['name'] != null &&
            userData['address'] != null &&
            userData['email'] != null) {
          setState(() {
            final blobValue = userData['name'];
            final bytes = blobValue.toBytes();
            final user = String.fromCharCodes(bytes);
            username = user;

            final blobValu = userData['address'];
            final byte = blobValu.toBytes();
            final add = String.fromCharCodes(byte);
            address = add;

            phoneNumber = userData['phone_number'];
          });
          _saveItem();
        } else {}
      } else {}
    } else {}
  }

  Future<void> _saveItem() async {
    final ConnectionSettings settings = ConnectionSettings(
      host: 'srv665.hstgr.io',
      port: 3306,
      user: 'u332079037_iwashhubonline',
      password: 'Iwashhub@123',
      db: 'u332079037_iwashhubapp',
    );
    final MySqlConnection conn = await MySqlConnection.connect(settings);
    //change table name here
    await conn.query('''
CREATE TABLE IF NOT EXISTS subscriptions ( 
  id INT AUTO_INCREMENT PRIMARY KEY,
  Customername VARCHAR(100) NOT NULL,
  phoneNumber VARCHAR(100) NOT NULL,
  address VARCHAR(100) NOT NULL,
  Subscriptiontype VARCHAR(100) NOT NULL, 
  userID VARCHAR(100) NOT NULL 
)
''');

    final result = await conn.query(
      'INSERT INTO subscriptions (Customername, phoneNumber, address, Subscriptiontype, userID) VALUES (?, ?, ?, ?, ?)',
      [username, phoneNumber, address, widget.subscriptiontype, userId],
    );
    await conn.close();
    if (result.affectedRows! > 0) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Payment Successful! Enjoy the subscription'),
        ),
      );

      setState(() {
        // Reset form fields
      });
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please try again')),
      );
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushNamed(context, SubscriptionScreen.id);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Payment Successful'),
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 100,
              ),
              SizedBox(height: 16),
              Text(
                'Payment Successful!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                'Thank you for your purchase.',
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

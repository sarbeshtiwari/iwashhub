import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreviousOrder extends StatefulWidget {
  const PreviousOrder({super.key});
  static const String id = "PreviousOrder";

  @override
  State<PreviousOrder> createState() => _PreviousOrderState();
}

class _PreviousOrderState extends State<PreviousOrder> {
  List<Map<dynamic, dynamic>> lists = [];

  int? userId;
  @override
  void initState() {
    super.initState();
    fetchUserId().then((value) {
      setState(() => userId = value);
      fetchData();
    });
  }

  bool isLoading = false;

  Future<int?> fetchUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    return userId;
  }

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
    Results results =
        await conn.query('SELECT * FROM orders WHERE userID = ? ', [userId]);

    if (results.isNotEmpty) {
      // Iterate over the results and add the data to the list
      for (var row in results) {
        lists.add({
          'Name of Customer': row['customerName'],
          'Services': row['services'],
          'Date & Time of Pickup': row['serviceDateTime'],
          'Address': row['customerAddress'],
          'Selected Store': row['selectedStore'],
        });
      }
      setState(() {
        lists = lists;
      });
      isLoading = false;
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
            // In your build method
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
                          Flexible(
                            child: Text(
                              lists[index]["Services"],
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
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
                          Flexible(
                            child: Text(
                              lists[index]["Address"],
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
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
    );
  }
}

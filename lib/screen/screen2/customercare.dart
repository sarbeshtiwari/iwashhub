import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomerCare extends StatelessWidget {
  const CustomerCare({Key? key}) : super(key: key);
  static String id = 'CustomerCare';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Care & Complain'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 40),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 50.0, // container width
                  height: 50.0,
                  decoration: const BoxDecoration(
                    color: Colors.blue, // background color
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.call_outlined,
                    size: 40.0, // icon size
                    color: Colors.white, // foreground color
                  ),
                ),
                const SizedBox(width: 8.0),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Call Us:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text("+918949310077"),
                    Text("| MON - SAT | 10:00 AM - 08:00 PM"),
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 50.0, // container width
                  height: 50.0,
                  decoration: const BoxDecoration(
                    color: Colors.blue, // background color
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.mail_outline,
                    size: 40.0, // icon size
                    color: Colors.white, // foreground color
                  ),
                ),
                const SizedBox(width: 8.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Mail Us:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    InkWell(
                      child: const Text(
                        'info@iwashhub.com',
                      ),
                      onTap: () =>
                          launchUrl(Uri.parse('mailto:info@iwashhub.com')),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 50.0, // container width
                  height: 50.0,
                  decoration: const BoxDecoration(
                    color: Colors.blue, // background color
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.message_outlined,
                    size: 40.0, // icon size
                    color: Colors.white, // foreground color
                  ),
                ),
                const SizedBox(width: 8.0),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Post Us:",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'URHY ASEPSIS SERVICES AND CONSULTANTS PVT LTD, D-217, Vibhuti Khand, Gomti Nagar, Lucknow - 226010',
                      ),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 50.0, // container width
                  height: 50.0,
                  decoration: const BoxDecoration(
                    color: Colors.blue, // background color
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    CupertinoIcons.globe,
                    size: 40.0, // icon size
                    color: Colors.white, // foreground color
                  ),
                ),
                const SizedBox(width: 8.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Website:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    InkWell(
                      child: const Text(
                        'https://www.iwashhub.com',
                      ),
                      onTap: () =>
                          launchUrl(Uri.parse('https://www.iwashhub.com')),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

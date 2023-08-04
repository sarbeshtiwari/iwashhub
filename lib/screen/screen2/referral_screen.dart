import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReferralScreen extends StatefulWidget {
  const ReferralScreen({super.key});
  static String id = 'ReferralScreen';

  @override
  State<ReferralScreen> createState() => _ReferralScreenState();
}

class _ReferralScreenState extends State<ReferralScreen> {
  int? userId;

  @override
  void initState() {
    super.initState();
    fetchUserId().then((value) {
      setState(() => userId = value);
    });
  }

  Future<int?> fetchUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    return userId;
  }

  @override
  Widget build(BuildContext context) {
    // Generate the referral code by appending a prefix to the user ID
    final referralCode = 'REF-$userId-iWashhub';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Referral Program'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Your Referral Code is',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              referralCode,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            const Text(
              "You will get 100 loyalty points and they \nget 50 loyalty points on placing their first order.",
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Use the share package to share the referral code
                Share.share(
                    'Join me on iWashhub! Use my referral code $referralCode to sign up and get offers.');
              },
              child: const Text('Share Referral Code'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:iwash/screen/authentication/signup_screen.dart';
import 'package:iwash/screen/screen2/privacy_policy.dart';
import 'package:iwash/screen/screen2/terms_condition.dart';
import 'package:iwash/screen/starting/initial_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  static const String id = "SettingsScreen";

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        title: const Text(
          "Settings",
          style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
        ),
      ),
      body: Column(
        children: [
          ListTile(
            title: const Text('Privacy Policies'),
            trailing: const Icon(
              Icons.chevron_right,
              color: Colors.orange,
            ),
            onTap: () => {Navigator.pushNamed(context, PrivacyPolicy.id)},
          ),
          const Divider(),
          ListTile(
            title: const Text('Terms & Conditions'),
            trailing: const Icon(
              Icons.chevron_right,
              color: Colors.orange,
            ),
            onTap: () => {Navigator.pushNamed(context, TermsCondition.id)},
          ),
          const Divider(),
          Center(
              child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Alert'),
                          content: const Text('Are you Sure'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                storeLoginState(false);
                                Navigator.pushNamed(context, SignUpScreen.id);
                              },
                              child: const Text('Yes'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Text("Sign Out")))
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:iwash/services/phoneauth_service.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';


//import '../Admin/admin_panel.dart';
import '../screen/starting/add_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static String id = "Login-Screen";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool validate = false;
  var countryCodeController = TextEditingController(text: '+91'); //country code
  var phoneNumberController = TextEditingController(); //Phone number

  final PhoneAuthService _service = PhoneAuthService(); //changed to final

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final ProgressDialog progressDialog = ProgressDialog(
      context,
    );
    progressDialog.style(
        message: 'Please file...',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: const CircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progressTextStyle: const TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: const TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600));
    return SafeArea(
      child: Scaffold(
          body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network("https://i.stack.imgur.com/t51VT.png",
                  height: size.height * 0.3),
              const Text("Welcome,",
                  style: TextStyle(
                    fontSize: 45,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  )),
              Text(
                "Make it work, make it right, make it fast",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Form(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    children: [
                      Row(children: [
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            controller: countryCodeController,
                            enabled: false,
                            decoration: const InputDecoration(
                                counterText: '10', labelText: 'Country Code'),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          flex: 3,
                          child: TextFormField(
                            onChanged: (value) {
                              if (value.length == 10) {
                                setState(() {
                                  validate = true;
                                });
                              }
                              if (value.length < 10) {
                                setState(() {
                                  validate = false;
                                });
                              }
                            },
                            maxLength: 10,
                            keyboardType: TextInputType.phone,
                            controller: phoneNumberController,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.phone_iphone_outlined),
                              labelText: "Phone Number",
                              hintText: "Enter your Phone Number",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ]),
                      const SizedBox(
                        height: 70,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: AbsorbPointer(
                          absorbing: validate ? false : true,
                          child: ElevatedButton(
                            onPressed: () {
                              progressDialog.show();
                              String number =
                                  '${countryCodeController.text}${phoneNumberController.text}';
                              if (number == '+918707828835') {
                                //Navigator.pushNamed(context, AdminPanel.id);
                              } else {
                                _service.verifyPhoneNumber(context, number);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              ),
                              elevation: 0,
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.black,
                              side: const BorderSide(color: Colors.black),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 20.0),
                            ),
                            child: const Text("LOGIN"),
                          ),
                        ),
                      ),
                      const SizedBox(height: 50),
                      SizedBox(
                        width: 100,
                        height: 200,
                        child: Stack(
                          children: [
                            Positioned(
                              bottom: 60.0,
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, AddScreen.id);
                                },
                                style: ElevatedButton.styleFrom(
                                  side: const BorderSide(color: Colors.black26),
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(20),
                                  foregroundColor: Colors.white,
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: const BoxDecoration(
                                      color: Color(0xff272727),
                                      shape: BoxShape.circle),
                                  child: const Icon(Icons.arrow_forward_ios),
                                ),
                              ),
                            ),
                            const Positioned(
                              bottom: 50,
                              right: 30,
                              child: Text(
                                "Skip",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      )),
    );
  }
}

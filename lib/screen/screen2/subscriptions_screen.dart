import 'dart:convert';
import 'dart:ui';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:iwash/screen/main/profile_screen.dart';
import 'package:iwash/screen/screen2/PaymentSuccessful.dart';
import 'package:iwash/screen/screen2/PaymentUnsuccessful.dart';
import 'package:mysql1/mysql1.dart';
import 'package:payu_checkoutpro_flutter/payu_checkoutpro_flutter.dart';
import 'package:payu_checkoutpro_flutter/PayUConstantKeys.dart';
import 'package:http/http.dart' as http;

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});
  static const String id = "Subscriptions-Screen";

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class PayUTestCredentials {
  static const merchantKey = "QZh29fQh"; //TODO: Add Merchant Key
  //Use your success and fail URL's.

  static const iosSurl =
      "https://payu.herokuapp.com/ios_success"; //TODO: Add Success URL.
  static const iosFurl =
      "https://payu.herokuapp.com/ios_failure"; //TODO Add Fail URL.
  static const androidSurl =
      "https://payu.herokuapp.com/success"; //TODO: Add Success URL.
  static const androidFurl =
      "https://payu.herokuapp.com/failure"; //TODO Add Fail URL.
}

class PayUParams {
  static Map createPayUPaymentParams() {
    var siParams = {
      PayUSIParamsKeys.isFreeTrial: true,
      PayUSIParamsKeys.billingAmount: '1', //Required
      PayUSIParamsKeys.billingInterval: 1, //Required
      PayUSIParamsKeys.paymentStartDate: '2023-04-20', //Required
      PayUSIParamsKeys.paymentEndDate: '2023-04-30', //Required
      PayUSIParamsKeys.billingCycle: //Required
          'daily', //Can be any of 'daily','weekly','yearly','adhoc','once','monthly'
      PayUSIParamsKeys.remarks: 'Test SI transaction',
      PayUSIParamsKeys.billingCurrency: 'INR',
      PayUSIParamsKeys.billingLimit: 'ON', //ON, BEFORE, AFTER
      PayUSIParamsKeys.billingRule: 'MAX', //MAX, EXACT
    };

    var additionalParam = {
      PayUAdditionalParamKeys.udf1: "udf1",
      PayUAdditionalParamKeys.udf2: "udf2",
      PayUAdditionalParamKeys.udf3: "udf3",
      PayUAdditionalParamKeys.udf4: "udf4",
      PayUAdditionalParamKeys.udf5: "udf5",
    };

    var spitPaymentDetails = {
      "type": "absolute",
      "splitInfo": {
        PayUTestCredentials.merchantKey: {
          "aggregatorSubTxnId":
              "1234567540099887766650092", //unique for each transaction
          "aggregatorSubAmt": "1"
        },
        /* "qOoYIv": {
          "aggregatorSubTxnId": "12345678",
          "aggregatorSubAmt": "40"
       },*/
      }
    };

    var payUPaymentParams = {
      PayUPaymentParamKey.key: PayUTestCredentials.merchantKey,
      PayUPaymentParamKey.amount: "1",
      PayUPaymentParamKey.productInfo: "Info",
      PayUPaymentParamKey.firstName: "Abc",
      PayUPaymentParamKey.email: "test@gmail.com",
      PayUPaymentParamKey.phone: "9999999999",
      PayUPaymentParamKey.ios_surl: PayUTestCredentials.iosSurl,
      PayUPaymentParamKey.ios_furl: PayUTestCredentials.iosFurl,
      PayUPaymentParamKey.android_surl: PayUTestCredentials.androidSurl,
      PayUPaymentParamKey.android_furl: PayUTestCredentials.androidFurl,
      PayUPaymentParamKey.environment: "1", //0 => Production 1 => Test
      PayUPaymentParamKey.userCredential:
          null, //TODO: Pass user credential to fetch saved cards => A:B - Optional
      PayUPaymentParamKey.transactionId:
          DateTime.now().millisecondsSinceEpoch.toString(),
      PayUPaymentParamKey.additionalParam: additionalParam,
      PayUPaymentParamKey.enableNativeOTP: true,
      // PayUPaymentParamKey.splitPaymentDetails:json.encode(spitPaymentDetails),
      PayUPaymentParamKey.userToken:
          "", //TODO: Pass a unique token to fetch offers. - Optional
    };

    return payUPaymentParams;
  }

  static Map createPayUConfigParams() {
    var paymentModesOrder = [
      {"Wallets": "PHONEPE"},
      {"UPI": "TEZ"},
      {"Wallets": ""},
      {"EMI": ""},
      {"NetBanking": ""},
    ];

    var cartDetails = [
      {"GST": "5%"},
      {"Delivery Date": "25 Dec"},
      {"Status": "In Progress"}
    ];
    var enforcePaymentList = [
      {"payment_type": "CARD", "enforce_ibiboCode": "UTIBENCC"},
    ];

    var customNotes = [
      {
        "custom_note": "Its Common custom note for testing purpose",
        "custom_note_category": [
          PayUPaymentTypeKeys.emi,
          PayUPaymentTypeKeys.card
        ]
      },
      {
        "custom_note": "Payment options custom note",
        "custom_note_category": null
      }
    ];

    var payUCheckoutProConfig = {
      PayUCheckoutProConfigKeys.primaryColor: "#4994EC",
      PayUCheckoutProConfigKeys.secondaryColor: "#FFFFFF",
      PayUCheckoutProConfigKeys.merchantName: "PayU",
      PayUCheckoutProConfigKeys.merchantLogo: "logo",
      PayUCheckoutProConfigKeys.showExitConfirmationOnCheckoutScreen: true,
      PayUCheckoutProConfigKeys.showExitConfirmationOnPaymentScreen: true,
      PayUCheckoutProConfigKeys.cartDetails: cartDetails,
      PayUCheckoutProConfigKeys.paymentModesOrder: paymentModesOrder,
      PayUCheckoutProConfigKeys.merchantResponseTimeout: 30000,
      PayUCheckoutProConfigKeys.customNotes: customNotes,
      PayUCheckoutProConfigKeys.autoSelectOtp: true,
      // PayUCheckoutProConfigKeys.enforcePaymentList: enforcePaymentList,
      PayUCheckoutProConfigKeys.waitingTime: 30000,
      PayUCheckoutProConfigKeys.autoApprove: true,
      PayUCheckoutProConfigKeys.merchantSMSPermission: true,
      PayUCheckoutProConfigKeys.showCbToolbar: true,
    };
    return payUCheckoutProConfig;
  }
}

class _SubscriptionScreenState extends State<SubscriptionScreen>
    implements PayUCheckoutProProtocol {
  //late Razorpay _razorpay;
  late PayUCheckoutProFlutter _checkoutPro;
  int? userId;
  String subscriptiontype = '';
  String selectedState = '';
  String student = '';
  String family01 = '';
  String family02 = '';

  @override
  void initState() {
    super.initState();
    _checkoutPro = PayUCheckoutProFlutter(this);
    fetchstateList();

    //   _razorpay = Razorpay();
    //   _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    //   _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
  }

  //work on line 45 to line 102

  void _startPayment(
      int amount, String subscriptiontype, String description) async {
    var payUPaymentParams = {
      PayUPaymentParamKey.key: "QZh29fQh", //REQUIRED
      PayUPaymentParamKey.amount: "1", //REQUIRED
      PayUPaymentParamKey.productInfo: "Info", //REQUIRED
      PayUPaymentParamKey.firstName: "Abc", //REQUIRED
      PayUPaymentParamKey.email: "test@gmail.com", //REQUIRED
      PayUPaymentParamKey.phone: "9999999999", //REQUIRED
      PayUPaymentParamKey.ios_surl:
          "https://pub.dev/packages/payu_checkoutpro_flutter/example", //REQUIRED
      PayUPaymentParamKey.ios_furl:
          "https://pub.dev/packages/payu_checkoutpro_flutter/example", //REQUIRED
      PayUPaymentParamKey.android_surl:
          "https://pub.dev/packages/payu_checkoutpro_flutter/example", //REQUIRED
      PayUPaymentParamKey.android_furl:
          "https://pub.dev/packages/payu_checkoutpro_flutter/example", //REQUIRED
      PayUPaymentParamKey.environment: "1", //0 => Production 1 => Test

      PayUPaymentParamKey.transactionId: "11", //REQUIRED
    };

    var payUConfigParams = {
      PayUCheckoutProConfigKeys.showExitConfirmationOnPaymentScreen: true,
      PayUCheckoutProConfigKeys.showExitConfirmationOnCheckoutScreen: true,
    };

    _checkoutPro.openCheckoutScreen(
        payUPaymentParams: payUPaymentParams,
        payUCheckoutProConfig: payUConfigParams);
  }

  @override
  generateHash(Map response) async {
    // Pass response param to your backend server
    // Backend will generate the hash which you need to pass to SDK
    // hashResponse: is the response which you get from your server
     // Pass response param to your backend server
  var url = '<YOUR_BACKEND_SERVER_URL>';
  var response1 = await http.post(
    Uri.parse(url),
    body: jsonEncode(response),
    headers: {'Content-Type': 'application/json'},
  );
  // Backend will generate the hash which you need to pass to SDK
  // hashResponse: is the response which you get from your server
  Map hashResponse = jsonDecode(response1.body);
    //Map hashResponse = {};
    print(hashResponse);
    _checkoutPro.hashGenerated(hash: hashResponse);
  }

  @override
  void onPaymentSuccess(dynamic response) {
    print("Success");
    //Handle Success response
  }

  @override
  void onPaymentFailure(dynamic response) {
    print("Failed");
    //Handle Failure response
  }

  @override
  void onPaymentCancel(Map? response) {
    print("Canceled");
    //Handle Payment cancel response
  }

  @override
  void onError(Map? response) {
    print("Error: $response");
    print("Noyt");
    return;
    //Handle on error response
  }

  // void _handlePaymentSuccess(PaymentSuccessResponse response) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) =>
  //           PaymentSuccessful(subscriptiontype: subscriptiontype),
  //     ),
  //   );
  //   //Navigator.pushsubscriptiontyped(context, PaymentSuccessful.id);
  //   // Handle successful payment here
  // }

  // void _handlePaymentError(PaymentFailureResponse response) {
  //   Navigator.pushNamed(context, PaymentUnsuccessful.id);
  //   // Handle payment failure here
  // }
  // void _startPayment(
  //     int amount, String subscriptiontype, String description) async {
  //   final data = await payu.buildPaymentParams(
  //       amount: "400.0",
  //       transactionId: "C2161646224785587",
  //       phone: "8707828835",
  //       productInfo: "Nike shoes",
  //       firstName: "Badal Sharma",
  //       email: "badal@gmail.com",
  //       hash: "DMrNcDBXqUoxo8jhcOypx89aAFmscGYZ0BinJGFeqGc=",
  //       isProduction: false,
  //       userCredentials: "7899395319",
  //       merchantKey: "QZh29fQh",
  //       salt: "Lfn53rLakq",
  //       merchantName: "Siply Services Pvt Ltd.");
  // }
  // void _startPayment(
  //     int amount, String subscriptiontype, String description) async {
  //   // // Every Transaction should have a unique ID. I am using timestamp as transactionid. Because its always unique :)
  //   String orderId = DateTime.now().millisecondsSinceEpoch.toString();
  //   // Amount is in rs. Enter 100 for Rs100.
  //   final String amount = "1";

  // void _startPayment(int amount, String subscriptiontype, String description) {
  //   var options = {
  //     'key': 'rzp_test_xYMEVhzwkXuBN8',
  //     'amount': amount * 100, // in paise
  //     'subscriptiontype': subscriptiontype,
  //     'description': description,
  //   };

  //   _razorpay.open(options);
  // }

  List<String> stateList = [];
  String stateListText = '';
  void fetchstateList() async {
    setState(() {
      selectedState = '';
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
    Results results = await conn.query('SELECT state FROM substate');
    if (results.isNotEmpty) {
      stateList = [];
      for (var userData in results) {
        if (userData['state'] != null) {
          stateList.add(userData['state']);
        }
      }
      setState(() {
        stateListText = stateList.isNotEmpty
            ? 'States: ${stateList.join(', ')}'
            : 'No state located';
      });
    } else {
      setState(() {
        stateList = [];
        stateListText = 'No state located';
      });
    }
  }

  void _showStoreSelectionPopup(BuildContext context) async {
    final result = await showModalBottomSheet<String>(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Choose Your State',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(),
            Expanded(
              child: ListView(
                children: stateList.map((String store) {
                  return ListTile(
                    title: Text(store),
                    onTap: () {
                      Navigator.of(context).pop(store);
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        );
      },
    );

    if (result != null) {
      setState(() {
        selectedState = result;
        fetchprice();
      });
    }
  }

  void fetchprice() async {
    setState(() {
      student = '';
      family01 = '';
      family02 = '';
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
        'SELECT student, family01, family02 FROM substate where state = ?',
        [selectedState]);
    if (results.isNotEmpty) {
      final userData = results.first;
      if (userData['student'] != null &&
          userData['family01'] != null &&
          userData['family02'] != null) {
        setState(() {
          student = userData['student'];
          family01 = userData['family01'];
          family02 = userData['family02'];
        });
      } else {}
    }
  }

  void showStateSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: AlertDialog(
              title: const Text('Please select your state to continue'),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushNamed(context, ProfileScreen.id);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 1,
          centerTitle: true,
          title: const Text(
            "Subscriptions",
            style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
          ),
        ),
        body: ListView(children: [
          const SizedBox(
            height: 20,
          ),
          if (stateList.isNotEmpty)
            OutlinedButton(
              onPressed: () {
                _showStoreSelectionPopup(context);
              },
              child: Text(
                  selectedState.isNotEmpty ? selectedState : 'Select state'),
            ),
          const SizedBox(
            height: 20,
          ),
          Column(
            children: [
              Card(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                elevation: 15,
                color: const Color.fromARGB(255, 120, 213, 249),
                child: Stack(
                  children: [
                    SizedBox(
                      height: 130,
                      child: ListTile(
                        title: const Text('STUDENT LAUNDRY CARD'),
                        subtitle: const Text(
                            'Wash & Iron - 120 pcs Clothes \nDaily wear Only \nMinimum-30 Clothes Per Order \n5% off on other Bills'),
                        leading: const Icon(Icons.card_membership),
                        trailing: Text('Only at ₹$student'),
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: FloatingActionButton(
                        heroTag: 'uniqueTag1',
                        onPressed: () async {
                          if (student == "") {
                            showStateSelectionDialog(context);
                          } else {
                            int amount = int.parse(student); //change in paise
                            subscriptiontype = 'STUDENT LAUNDRY CARD';
                            String description = "STUDENT LAUNDRY CARD";
                            _checkoutPro.openCheckoutScreen(
                              payUPaymentParams:
                                  PayUParams.createPayUPaymentParams(),
                              payUCheckoutProConfig:
                                  PayUParams.createPayUConfigParams(),
                            );
                            // _startPayment(
                            //     amount, subscriptiontype, description);
                          }
                        },
                        backgroundColor: Colors.orange,
                        child: const Text("Buy"),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
              Card(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                elevation: 15,
                color: const Color.fromARGB(255, 120, 213, 249),
                child: Stack(
                  children: [
                    SizedBox(
                      height: 130,
                      child: ListTile(
                        title: const Text('FAMILY SAVER 01'),
                        subtitle: const Text(
                            'Wash & Iron - 30KG Load Topup \nMinimum 6KG Per Order \n5% off on other Bills \nBest For Family of 2 \nSAVE ₹971'),
                        leading: const Icon(Icons.card_membership),
                        trailing: Text('Only at ₹$family01'),
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: FloatingActionButton(
                        heroTag: 'uniqueTag2',
                        onPressed: () {
                          if (student == "") {
                            showStateSelectionDialog(context);
                          } else {
                            int amount = int.parse(family01); //change in paise
                            subscriptiontype = 'FAMILY SAVER 01';
                            String description = "FAMILY SAVER 01";
                            _startPayment(
                                amount, subscriptiontype, description);
                          }
                        },
                        backgroundColor: Colors.orange,
                        child: const Text("Buy"),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
              Card(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                elevation: 15,
                color: const Color.fromARGB(255, 120, 213, 249),
                child: Stack(
                  children: [
                    SizedBox(
                      height: 130,
                      child: ListTile(
                        title: const Text('FAMILY SAVER 02'),
                        subtitle: const Text(
                            'Wash & Iron - 60 KG Load Topup \nMinimum- 6kg Per Order \n5% off on other Bills \nBest For Family of 4 \nSAVE ₹2341'),
                        leading: const Icon(Icons.card_membership),
                        trailing: Text('Only at ₹$family02'),
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: FloatingActionButton(
                        heroTag: 'uniqueTag3',
                        onPressed: () {
                          if (student == "") {
                            showStateSelectionDialog(context);
                          } else {
                            int amount = int.parse(family02); //change in paise
                            subscriptiontype = 'FAMILY SAVER 02';
                            String description = "FAMILY SAVER 02";
                            _startPayment(
                                amount, subscriptiontype, description);
                          }
                        },
                        backgroundColor: Colors.orange,
                        child: const Text("Buy"),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
              // Card(
              //   shape: const RoundedRectangleBorder(
              //     borderRadius: BorderRadius.only(
              //       topLeft: Radius.circular(20),
              //       bottomRight: Radius.circular(20),
              //     ),
              //   ),
              //   elevation: 15,
              //   color: const Color.fromARGB(255, 120, 213, 249),
              //   child: Stack(
              //     children: [
              //       const SizedBox(
              //         height: 130,
              //         child: ListTile(
              //           title: Text('Test'),
              //           subtitle: Text('Pay for testing'),
              //           leading: Icon(Icons.card_membership),
              //           trailing: Text('Only at ₹1'),
              //         ),
              //       ),
              //       Positioned(
              //         bottom: 10,
              //         right: 10,
              //         child: FloatingActionButton(
              //           heroTag: 'uniqueTag4',
              //           onPressed: () {
              //             int amount = 1;
              //             subscriptiontype = 'Test payment';
              //             String description =
              //                 "You are about to make test payment";
              //             _startPayment(amount, subscriptiontype, description);
              //           },
              //           backgroundColor: Colors.orange,
              //           child: const Text("Buy"),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
          const Divider(),
          Container(
            alignment: Alignment.bottomCenter,
            child: const Padding(
              padding: EdgeInsets.all(16),
              // After Buying a Subscription Plan \nContact Nearest Store \nor (Call 8948310077) \n& start using the services
              child: Text(
                'Contact the nearest store after \npurchasing a subscription plan \nand start using the services.',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

class HashService {
  static generateHash(Map<dynamic, dynamic> data) {
    // Convert the data map to a JSON string
    String jsonData = jsonEncode(data);

    // Generate the SHA-256 hash of the JSON data
    Digest hash = sha256.convert(utf8.encode(jsonData));

    // Return the hash as a hexadecimal string
    return hash.toString();
  }
}

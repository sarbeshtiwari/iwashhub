// ignore_for_file: prefer_final_fields, use_build_context_synchronously, non_constant_identifier_names, unnecessary_brace_in_string_interps, prefer_const_constructors_in_immutables, use_key_in_widget_constructors, library_private_types_in_public_api, depend_on_referenced_packages, unused_local_variable, no_leading_underscores_for_local_identifiers, prefer_typing_uninitialized_variables

import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:iwash/screen/main/home.dart';
import 'package:iwash/widgets/Bootombar.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

import 'order_confirm.dart';

class BookingScreen extends StatefulWidget {
  BookingScreen({super.key});
  static String id = "BookingScreen";

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  var countryCodeController = TextEditingController(text: '+91');
  var hour = 0;

  @override
  void initState() {
    super.initState();
    fetch();
    fetchstoreList();

    final DateTime now = DateTime.now();
    formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);
  }

  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _emailController = TextEditingController();

  String username = '';
  String address = '';
  String city = '';
  String phoneNumber = '';
  bool validate = false;
  var formattedDate = '';
  var pickedDate = '';
  var pickedTime = '';
  String selectedItems = '';
  String selectedStore = '';

  // String countryValue = 'India';
  // String stateValue = '';
  // String cityValue = '';

  String shopname = '';
  String shopphoneNumber = '';
  String shopaddress = '';

  TextEditingController _dateController = TextEditingController();
  List<String> itmes = [
    'Dry Clean',
    'Wash & Fold',
    'Wash & Iron',
    'Steam Iron',
    'Scraching',
    'Shoe Cleaning',
    'Toy Cleaning',
    'Car Wash'
  ];

  List<String> selectedOptions = [];
  //added for stores
  List<String> storeList = [];
  String storeListText = '';

  void fetchstoreList() async {
    setState(() {
      selectedStore = '';
    });
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final CollectionReference _storesCollection =
        _firestore.collection('Stores');
    final DocumentReference _storeLocationDocument =
        _storesCollection.doc('storelocation');
    final DocumentSnapshot snapshot = await _storeLocationDocument.get();
    //final List<dynamic> storeArray = snapshot.get(city.toLowerCase());
    final Map<String, dynamic>? dataMap =
        snapshot.data() as Map<String, dynamic>?;

    if (dataMap != null && dataMap.containsKey(city.toLowerCase())) {
      final List<dynamic> storeArray = dataMap[city.toLowerCase()];

      setState(() {
        storeList = List<String>.from(storeArray);
        storeListText = storeList.isNotEmpty
            ? 'Store: ${storeList.toString()}'
            : 'No store located';
      });
    } else {
      setState(() {
        storeList = [];
        storeListText = 'No store located';
      });
    }
  }

  Future<void> fetch() async {
    // Fetch user details from the Firebase database

    final user = FirebaseAuth.instance.currentUser!;
    final userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .snapshots();

    userSnapshot.listen((snapshot) {
      if (snapshot.exists) {
        final userData = snapshot.data();
        if (userData != null) {
          if (userData['name'] != null &&
                  userData['name'].isNotEmpty &&
                  userData['address'] != null &&
                  userData['address'].isNotEmpty &&
                  userData['email'] != null &&
                  userData['email'].isNotEmpty
              //&&
              // userData['city'] != null &&
              // userData['city'].isNotEmpty
              ) {
            setState(() {
              username = userData['name'];
              address = userData['address'];
              //city = userData['city'];
              phoneNumber = userData['Phone Number'];
            });
            fetchstoreList();
          } else {
            _showUpdateDialog(context);
          }
        }
      }
    });
  }

  void _showStoreSelectionPopup(BuildContext context) async {
    final result = await showModalBottomSheet<String>(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Available Stores',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Divider(),
            Expanded(
              child: ListView(
                children: storeList.map((String store) {
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
        selectedStore = result;
      });
    }
  }

  void _showUpdateDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Card(
            color: const Color.fromARGB(0, 0, 0, 0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: AlertDialog(
              title: const Text('Update details to continue'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                  ),
                  TextField(
                    controller: _addressController,
                    decoration: const InputDecoration(labelText: 'Address'),
                  ),
                  // TextField(
                  //   controller: _cityController,
                  //   decoration: const InputDecoration(labelText: 'City'),
                  // ),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, Home.id);
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.blueAccent),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    if (_nameController.text.isNotEmpty &&
                        _addressController.text.isNotEmpty &&
                        //_cityController.text.isNotEmpty &&
                        _emailController.text.isNotEmpty) {
                      _updateValues();
                      Navigator.of(context).pop();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("All fields are Mandatory")));
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.blueAccent),
                  ),
                  child: const Text(
                    'Update',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _updateValues() async {
    // Update the user details in the Firebase database
    final user = FirebaseAuth.instance.currentUser!;
    await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
      'name': _nameController.text,
      'address': _addressController.text,
      'email': _emailController.text,
      //'city': _cityController.text,
    });
    fetch();
  }

  Future<void> _saveItem() async {
    final url =
        Uri.https('iwash-d6737-default-rtdb.firebaseio.com', 'Orders.json');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(
          {
            'Name of Customer': username,
            'Phone Number': phoneNumber,
            'Address': address,
            'Services': selectedItems,
            'Date & Time of Pickup': '$pickedDate $pickedTime',
            'Date & Time': formattedDate,
            'Selected Store': selectedStore,
          },
        ),
      );
      final user = FirebaseAuth.instance.currentUser!;
      await FirebaseFirestore.instance.collection('Orders').doc().set({
        'Name of Customer': username,
        'Phone Number': phoneNumber,
        'Address': address,
        'Services': selectedItems,
        'Date & Time of Pickup': '$pickedDate $pickedTime',
        'Date & Time': formattedDate,
        'Selected Store': selectedStore,
      });

      if (response.statusCode == 200) {
        //Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Order Placed successfully!'),
          ),
        );
        // Send notification to user

        // Rebuild screen
        setState(() {
          // Reset form fields
          selectedOptions;
          pickedDate;
          pickedTime;
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderConfirm(
                phoneNumber: phoneNumber,
                city: city,
                selectedStore: selectedStore),
          ),
        );
      } else {
        // Handle error
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please try again')),
        );
      }
    } catch (error) {
      // Handle error
    }
  }

  Future<void> _selectedDate() async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2040));
    if (picked != null) {
      setState(() {
        _dateController.text = picked.toString().split(" ")[0];
        pickedDate = _dateController.text;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ProgressDialog progressDialog = ProgressDialog(
      context,
    );
    progressDialog.style(
        message: 'Please wait',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: const CircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progressTextStyle: const TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: const TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600));

    var _phoneNumberController;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Place your Order"),
        ),
        body: ListView(children: [
          const SizedBox(
            height: 20,
          ),
          Card(
            color: Colors.white,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListTile(
              title: Text("Phone Number: $phoneNumber"),
              leading: const Icon(Icons.phone),
              trailing: const Icon(
                Icons.chevron_right,
                color: Colors.blueAccent,
              ),
              onTap: () {
                // Use a TextEditingController to retrieve the text entered by the user
                final TextEditingController controller =
                    TextEditingController();
                controller.text = phoneNumber;
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Enter Number'),
                      content: TextField(
                        controller: controller,
                        keyboardType: TextInputType.phone,
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            // Update the phoneNumber variable with the new value
                            setState(() {
                              phoneNumber = controller.text;
                            });
                            Navigator.of(context).pop();
                          },
                          child: const Text('Save'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    const Text(
                      "Address",
                      style: TextStyle(fontSize: 15),
                    ),
                    Card(
                      color: Colors.white,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListTile(
                        title:
                            //Flexible(
                            //child:
                            Text(
                          address,
                          overflow: TextOverflow.ellipsis,
                        ),
                        //),
                        leading: const Icon(Icons.location_city),
                        trailing: const Icon(
                          Icons.chevron_right,
                          color: Colors.blueAccent,
                        ),
                        onTap: () {
                          // Use a TextEditingController to retrieve the text entered by the user
                          final TextEditingController controller =
                              TextEditingController();
                          controller.text = address;
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Present Address'),
                                content: TextField(
                                  controller: controller,
                                  keyboardType: TextInputType.streetAddress,
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      if (address.isNotEmpty) {
                                        setState(() {
                                          address = controller.text;
                                        });
                                        Navigator.of(context).pop();
                                      } else {
                                        if (address.isEmpty) {
                                          address = 'Please enter address';
                                        }
                                      }
                                    },
                                    child: const Text('Save'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    const Text(
                      "City",
                      style: TextStyle(fontSize: 15),
                    ),
                    Card(
                      color: Colors.white,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListTile(
                        title: Text(city),
                        leading: const Icon(Icons.location_city),
                        trailing: const Icon(
                          Icons.chevron_right,
                          color: Colors.blueAccent,
                        ),
                        onTap: () {
                          final TextEditingController controller =
                              TextEditingController();
                          controller.text = city;
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Enter City'),
                                content: TextField(
                                  controller: controller,
                                  keyboardType: TextInputType.streetAddress,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.deny(
                                        RegExp(r"\s")), // Deny space character
                                  ],
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      if (city.isNotEmpty) {
                                        setState(() {
                                          city = controller.text;
                                        });
                                        fetchstoreList();
                                        Navigator.of(context).pop();
                                      } else {
                                        if (city.isEmpty) {
                                          city = 'Please enter city';
                                        }
                                      }
                                    },
                                    child: const Text('Save'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                storeList.isEmpty && city.isEmpty
                    ? 'Enter your City'
                    : (storeList.isEmpty
                        ? 'No store located'
                        : "Select a Store"),
              ),
            ],
          ),

          if (storeList.isNotEmpty)
            OutlinedButton(
              onPressed: () {
                _showStoreSelectionPopup(context);
              },
              child: Text(
                  selectedStore.isNotEmpty ? selectedStore : 'Select a store'),
            ),
          const SizedBox(
            height: 20,
          ),
          Card(
            color: Colors.white,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListTile(
              title: Text('Services: $selectedItems'),
              leading: const Icon(Icons.star_outline),
              trailing: const Icon(
                Icons.chevron_right,
                color: Colors.blueAccent,
              ),
              onTap: () {
                _showFullScreenPopup();
              },
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          // Card(
          //   color: Colors.white,
          //   elevation: 4,
          //   shape: RoundedRectangleBorder(
          //     borderRadius: BorderRadius.circular(8),
          //   ),
          //   child: ListTile(
          //     title: const Text('Apply Coupon'),
          //     leading: const Icon(Icons.card_giftcard),
          //     trailing: const Icon(
          //       Icons.chevron_right,
          //       color: Colors.blueAccent,
          //     ),
          //     onTap: () => {},
          //   ),
          // ),
          // const SizedBox(
          //   height: 10,
          // ),
          Card(
            color: Colors.white,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              controller: _dateController,
              decoration: const InputDecoration(
                labelText: 'Date',
                filled: true,
                prefixIcon: Icon(Icons.calendar_today),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
              readOnly: true,
              onTap: () {
                _selectedDate();
              },
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Card(
            color: Colors.white,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListTile(
              title: Text('Time for Pickup: $pickedTime'),
              leading: const Icon(Icons.lock_clock),
              trailing: const Icon(
                Icons.chevron_right,
                color: Colors.blueAccent,
              ),
              onTap: () {
                _selectTime();
              },
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: () {
                if (selectedItems == '' ||
                    selectedItems.isEmpty ||
                    selectedItems.trim() == ',') {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Alert'),
                        content: const Text('Please Select a service'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                } else if (address == '' || address.isEmpty) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Alert'),
                        content: const Text('Please Enter Address'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                } else if (city == '' || city.isEmpty) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Alert'),
                        content: const Text('Please Enter City value'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                } else if (phoneNumber == '' || phoneNumber.isEmpty) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Alert'),
                        content: const Text('Please Enter Phone Number'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                } else if (selectedStore == '' ||
                    selectedStore.isEmpty ||
                    selectedStore == 'Select a store') {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Alert'),
                        content: const Text('Please Select Store'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  progressDialog.show();
                  _saveItem();
                }
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Place Order'),
            ),
          ),
        ]),
        bottomNavigationBar: const BottomBar(),
      ),
    );
  }

  void _showFullScreenPopup() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            title: const Text('Select Service'),
            content: MultiSelectChip(itmes, onSelectionChanged: (SelectedList) {
              setState(() {
                selectedOptions = SelectedList;
              });
            }),
            actions: [
              TextButton(
                child: const Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                  child: const Text('Add'),
                  onPressed: () {
                    setState(() {
                      selectedItems = selectedOptions.join(', ');
                    });
                    Navigator.pop(context);
                  }),
            ]);
      },
    );
  }

  void _selectTime() {
    final List<TimeOfDay> timeSlots = List.generate(
      17,
      (index) => TimeOfDay(hour: 10 + index ~/ 2, minute: (index % 2) * 30),
    );
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 200,
          child: CupertinoPicker(
            itemExtent: 32,
            onSelectedItemChanged: (int index) {
              setState(() {
                pickedTime = timeSlots[index].format(context);
              });
            },
            children: timeSlots
                .map(
                  (time) => Center(
                    child: Text(time.format(context)),
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }
}

class MultiSelectChip extends StatefulWidget {
  final List<String> items;
  final Function(List<String>) onSelectionChanged;
  MultiSelectChip(this.items, {required this.onSelectionChanged});

  @override
  _MultiSelectChipState createState() => _MultiSelectChipState();
}

class _MultiSelectChipState extends State<MultiSelectChip> {
  List<String> selectedOptions = [];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: widget.items
          .map((item) => ChoiceChip(
                label: Text(item),
                selected: selectedOptions.contains(item),
                selectedColor: Colors.blue,
                onSelected: (selected) {
                  setState(() {
                    selectedOptions.contains(item)
                        ? selectedOptions.remove(item)
                        : selectedOptions.add(item);
                    widget.onSelectionChanged(selectedOptions);
                  });
                },
              ))
          .toList(),
    );
  }
}

class FullScreenDialog extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final List<Widget> actions;

  const FullScreenDialog({
    required this.title,
    required this.children,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

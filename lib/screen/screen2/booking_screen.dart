// ignore_for_file: prefer_final_fields, use_build_context_synchronously, non_constant_identifier_names, unnecessary_brace_in_string_interps, prefer_const_constructors_in_immutables, use_key_in_widget_constructors, library_private_types_in_public_api, depend_on_referenced_packages, unused_local_variable, no_leading_underscores_for_local_identifiers, prefer_typing_uninitialized_variables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:intl/intl.dart';
import 'package:iwash/screen/main/home.dart';
import 'package:iwash/widgets/Bootombar.dart';
import 'package:mysql1/mysql1.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  int? userId;
  @override
  void initState() {
    super.initState();
    fetchUserId().then((value) {
      setState(() => userId = value);
      fetch();
    });

    //fetchstoreList();

    final DateTime now = DateTime.now();
    formattedDate = DateFormat('yyyy-MM-dd - kk:mm').format(now);
  }

  Future<int?> fetchUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    return userId;
  }

  int? user;

  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  // ignore: unused_field
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
  String shopname = '';
  String shopphoneNumber = '';
  String shopaddress = '';

  TextEditingController _dateController = TextEditingController();
  List<String> itmes = [
    'Dry Clean',
    'Wash & Fold',
    'Wash & Iron',
    'Steam Iron',
    'Home Clean',
    'Spotting',
    'Shoe Cleaning',
    'Toy Cleaning',
    'Car Wash'
  ];

  List<String> selectedOptions = [];
  //added for stores
  List<String> storeList = [];
  String storeListText = '';

  //working correctly no need to change
  void fetchstoreList() async {
    setState(() {
      selectedStore = '';
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
        'SELECT store FROM storelocation WHERE city = ?', [city.toLowerCase()]);
    if (results.isNotEmpty) {
      storeList = [];
      for (var userData in results) {
        if (userData['store'] != null) {
          storeList.add(userData['store']);
        }
      }
      setState(() {
        storeListText = storeList.isNotEmpty
            ? 'Stores: ${storeList.join(', ')}'
            : 'No store located';
      });
    } else {
      setState(() {
        storeList = [];
        storeListText = 'No store located';
      });
    }
  }

  //working correctly no change needed
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
          //fetchstoreList();
        } else {
          _showUpdateDialog(context);
        }
      } else {}
    } else {}
  }

  //working correctly no change needed
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
                'Available Stores',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(),
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

  //working correctly no change needed
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

  //working correctly no change needed
  void _updateValues() async {
    final ConnectionSettings settings = ConnectionSettings(
      host: 'srv665.hstgr.io',
      port: 3306,
      user: 'u332079037_iwashhubonline',
      password: 'Iwashhub@123',
      db: 'u332079037_iwashhubapp',
    );
    final MySqlConnection conn = await MySqlConnection.connect(settings);
    await conn.query('ALTER TABLE users ADD COLUMN IF NOT EXISTS name TEXT');
    await conn.query('ALTER TABLE users ADD COLUMN IF NOT EXISTS address TEXT');
    await conn.query('ALTER TABLE users ADD COLUMN IF NOT EXISTS email TEXT');
    final result = await conn.query(
      'UPDATE users SET name = ?, address = ?, email = ? WHERE id = ?',
      [
        _nameController.text,
        _addressController.text,
        _emailController.text,
        userId
      ],
    );
    if (result.affectedRows! > 0) {
      fetch();
    } else {}
  }

  //no need to change but have to take a look here
  Future<void> _saveItem() async {
    final ConnectionSettings settings = ConnectionSettings(
      host: 'srv665.hstgr.io',
      port: 3306,
      user: 'u332079037_iwashhubonline',
      password: 'Iwashhub@123',
      db: 'u332079037_iwashhubapp',
    );
    final MySqlConnection conn = await MySqlConnection.connect(settings);
    await conn.query('''
CREATE TABLE IF NOT EXISTS orders (
  id INT AUTO_INCREMENT PRIMARY KEY,
  phone_number VARCHAR(255) NOT NULL, 
  customerName VARCHAR(255) NOT NULL, 
  customerAddress VARCHAR(500) NOT NULL,
  customerCity VARCHAR(255) NOT NULL,
  services VARCHAR(255) NOT NULL,
  serviceDateTime VARCHAR(300),
  selectedStore VARCHAR(250),
  created_at TIMESTAMP NOT NULL,
  userID VARCHAR(255) NOT NULL
)
''');
    String Pickup = '$pickedDate $pickedTime';
    final result = await conn.query(
      'INSERT INTO orders (phone_number, customerName, customerAddress, customerCity, services, serviceDateTime, selectedStore, created_at, userID) VALUES (?, ?,?, ?,?, ?,?, ?,?)',
      [
        phoneNumber,
        username,
        address,
        city,
        selectedItems,
        Pickup,
        selectedStore,
        formattedDate,
        userId
      ],
    );
    await conn.close();
    if (result.affectedRows! > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Order Placed successfully!'),
        ),
      );
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please try again')),
      );
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
      isDismissible: false,
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
                                title: const Text('Enter your current City'),
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
            ],
          ),
          const SizedBox(
            height: 20,
          ),

          //may have to make changes
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                storeList.isEmpty && city.isEmpty
                    ? 'Enter your City'
                    : (storeList.isEmpty ? 'No store located' : ""),
                style: const TextStyle(fontSize: 20),
              ),
            ],
          ),
          if (storeList.isNotEmpty)
            OutlinedButton(
              onPressed: () {
                _showStoreSelectionPopup(context);
              },
              child: Text(
                selectedStore.isNotEmpty ? selectedStore : 'Select a Store',
                style: const TextStyle(fontSize: 20),
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
                        content: const Text('Please Enter your Address'),
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
                        content: const Text('Please Enter your City'),
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
                        content: const Text('Please Select a Store'),
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
        bottomNavigationBar: const BottomBar(
          selectedIndex: 3,
        ),
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

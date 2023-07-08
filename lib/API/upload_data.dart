// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UploadData extends StatefulWidget {
  const UploadData({super.key});
  static String id = 'UploadData';

  @override
  State<UploadData> createState() {
    return _UploadDataState();
  }
}

class _UploadDataState extends State<UploadData> {
  // @override
  // void initState() {
  //   super.initState();
  //   // final DateTime now = DateTime.now();
  //   // formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);
  //   // _datetime = formattedDate;
  // }

  bool validate = false;
  //var countryCodeController = TextEditingController(text: '+91');
  final _formKey = GlobalKey<FormState>();
  // var formattedDate = '';
  var _enteredName = '';
  var _enteredPhoneNumber = '';
  var _enteredAddress;
  var _enteredcity;
  // var _enteredEmail = '';
  final List<String> imageUrls = [
    'https://picsum.photos/200?1',
    'https://picsum.photos/200?2',
    'https://picsum.photos/200?3',
    'https://picsum.photos/200?4',
    'https://picsum.photos/200?5',
  ];

  Future<void> _saveItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final url =
          Uri.https('iwash-d6737-default-rtdb.firebaseio.com', 'stores.json');
      try {
        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode(
            {
              'Name': _enteredName,
              'Phone Number': _enteredPhoneNumber,
              'Address': _enteredAddress,
              'City': _enteredcity,
              // 'Email': _enteredEmail,
              // 'Date & Time': formattedDate,
            },
          ),
        );
        if (response.statusCode == 200) {
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Data sent successfully!')),
          );
          // Rebuild screen
          setState(() {
            // Reset form fields
            _enteredName = '';
            _enteredPhoneNumber = '';
            _enteredAddress = '';
            _enteredcity = '';
            // _enteredEmail = '';
            _formKey.currentState!.reset();
          });
        } else {
          // Handle error
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please try again')),
          );
          // Rebuild screen
          setState(() {
            // Reset form fields
            _enteredName = '';
            _enteredPhoneNumber = '';
            // _enteredEmail = '';
            _formKey.currentState!.reset();
          });
        }
      } catch (error) {
        // Handle error
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Data'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                maxLength: 50,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person_outline_outlined),
                  labelText: "Name",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1 ||
                      value.trim().length > 50) {
                    return 'Must be between 1 and 50 characters.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _enteredName = value!;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.trim().length <= 1 ||
                            value.trim().length > 10) {
                          return 'Please Enter Correct phone number';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _enteredPhoneNumber = value!;
                      },
                      maxLength: 10,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.phone_iphone_outlined),
                        labelText: 'Phone',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              TextFormField(
                maxLength: 50,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person_outline_outlined),
                  labelText: "Address",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1 ||
                      value.trim().length > 50) {
                    return 'Must be between 1 and 50 characters.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _enteredAddress = value!;
                },
              ),
              TextFormField(
                maxLength: 50,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person_outline_outlined),
                  labelText: "City",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1 ||
                      value.trim().length > 50) {
                    return 'Must be between 1 and 50 characters.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _enteredcity = value!;
                },
              ),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _saveItem();
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    elevation: 0,
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.black,
                    side: const BorderSide(color: Colors.black),
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                  ),
                  child: const Text("Submit"),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              // Expanded(
              //   child: CarouselSlider(
              //     options: CarouselOptions(
              //       height: MediaQuery.of(context).size.height * 0.18,
              //       autoPlay: true,
              //       enlargeCenterPage: true,
              //     ),
              //     items: imageUrls.map((imageUrl) {
              //       return Builder(
              //         builder: (BuildContext context) {
              //           return Container(
              //             width: MediaQuery.of(context).size.width,
              //             margin: const EdgeInsets.symmetric(horizontal: 5.0),
              //             child: Image.network(imageUrl, fit: BoxFit.cover),
              //           );
              //         },
              //       );
              //     }).toList(),
              //   ),
              // ),
              // const SizedBox(
              //   height: 10,
              // ),
              // const Text(
              //   "Contact Us:- 8948310077\n Mail:- mailid@mail.com",
              //   style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              // ),
              // const SizedBox(
              //   height: 10,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

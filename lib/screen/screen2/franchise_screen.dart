// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';


class FranchiseScreen extends StatefulWidget {
  const FranchiseScreen({Key? key}) : super(key: key);

  static String id = 'FranchiseScreen';

  @override
  State<FranchiseScreen> createState() {
    return _FranchiseScreenState();
  }
}

class _FranchiseScreenState extends State<FranchiseScreen> {
  @override
  void initState() {
    super.initState();
    final DateTime now = DateTime.now();
    formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);
  }

  bool validate = false;
  var countryCodeController = TextEditingController(text: '+91');
  final _formKey = GlobalKey<FormState>();
  var formattedDate = '';
  var _enteredName = '';
  var _enteredPhoneNumber = '';
  var _enteredEmail = '';
  var _profession = '';
  var _city = '';

  Future<void> _saveItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final url = Uri.https(
          'iwash-d6737-default-rtdb.firebaseio.com', 'franchise-list.json');
      try {
        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode(
            {
              'Name': _enteredName,
              'Phonenumber': _enteredPhoneNumber,
              'Email': _enteredEmail,
              'Date & Time': formattedDate,
              'Profession': _profession,
              'City': _city,
            },
          ),
        );
        if (response.statusCode == 200) {
          
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Data sent successfully!')),
          );
          setState(() {
            _enteredName = '';
            _enteredPhoneNumber = '';
            _enteredEmail = '';
            _profession = '';
            _city = '';
            _formKey.currentState!.reset();
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please try again')),
          );
          setState(() {
            _enteredName = '';
            _enteredPhoneNumber = '';
            _enteredEmail = '';
            _profession = '';
            _city = '';
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
        title: const Text('Become a Store Partner'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        maxLength: 50,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.person_outline_outlined),
                          labelText: "Name",
                          hintText: "Enter your Name",
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
                        height: 10,
                      ),
                      TextFormField(
                        maxLength: 50,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.person_outline_outlined),
                          labelText: "Job Title",
                          hintText: "Profession/ Job Title",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a value.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _profession = value!;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        maxLength: 50,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.location_city),
                          labelText: "City",
                          hintText: "City",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a value.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _city = value!;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.trim().length <= 1 ||
                              value.trim().length > 10) {
                            return 'Please enter a valid phone number.';
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
                          labelText: 'Phone Number',
                          hintText: 'Enter Your Phone number',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.email_outlined),
                          labelText: "Email",
                          hintText: "Enter your Email",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a valid email.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _enteredEmail = value!;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _saveItem,
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
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Contact Us:- 8948310077\n Mail:- info@iwashhub.com",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}

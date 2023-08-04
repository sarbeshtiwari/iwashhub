// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

import 'package:mysql1/mysql1.dart';

class UploadData extends StatefulWidget {
  const UploadData({super.key});
  static String id = 'UploadData';

  @override
  State<UploadData> createState() {
    return _UploadDataState();
  }
}

class _UploadDataState extends State<UploadData> {
  bool validate = false;
  final _formKey = GlobalKey<FormState>();

  var _enteredName = '';
  var _enteredPhoneNumber = '';

  Future<void> _saveItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final ConnectionSettings settings = ConnectionSettings(
        host: 'srv665.hstgr.io',
        port: 3306,
        user: 'u332079037_iwashhubonline',
        password: 'Iwashhub@123',
        db: 'u332079037_iwashhubapp',
      );
      final MySqlConnection conn = await MySqlConnection.connect(settings);
      //change table name here
      await conn.query('''
CREATE TABLE IF NOT EXISTS houseclean ( 
  id INT AUTO_INCREMENT PRIMARY KEY,
  Product VARCHAR(255) NOT NULL, 
  Price VARCHAR(255) NOT NULL  
)
''');

      final result = await conn.query(
        'INSERT INTO houseclean (Product, Price) VALUES (?, ?)',
        [
          _enteredName,
          _enteredPhoneNumber,
        ],
      );
      await conn.close();
      if (result.affectedRows! > 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Order Placed successfully!'),
          ),
        );
        setState(() {
          // Reset form fields
          _enteredName = '';
          _enteredPhoneNumber = '';
          _formKey.currentState!.reset();
        });
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
                  labelText: "Product",
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
                        labelText: 'Price',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
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
            ],
          ),
        ),
      ),
    );
  }
}

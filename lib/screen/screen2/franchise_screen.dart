// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mysql1/mysql1.dart';
import 'package:http/http.dart' as http;

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
    formattedDate = DateFormat('yyyy-MM-dd - kk:mm').format(now);
  }

  bool validate = false;
  bool _value1 = false;
  bool _value2 = false;
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
CREATE TABLE IF NOT EXISTS franchise ( 
  id INT AUTO_INCREMENT PRIMARY KEY,
  Name VARCHAR(255) NOT NULL, 
  PhoneNumber VARCHAR(255) NOT NULL,  
  Email VARCHAR(255) NOT NULL,
  Profession VARCHAR(255) NOT NULL,  
  City VARCHAR(255) NOT NULL,
  Eco VARCHAR(7), 
  Elite VARCHAR(7),  
  Date_Time VARCHAR(255) NOT NULL  
)
''');

      final result = await conn.query(
        'INSERT INTO franchise (Name, PhoneNumber, Email, Profession, City, Eco, Elite, Date_Time) VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
        [
          _enteredName,
          _enteredPhoneNumber,
          _enteredEmail,
          _profession,
          _city,
          _value1,
          _value2,
          formattedDate,
        ],
      );
      await conn.close();
      if (result.affectedRows! > 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Data sent successfully!'),
          ),
        );
        sendSMS(
            'Thanks for making enquiry for iwashhub franchisee business. Get connected with us to know more. Call 7307108685 IWASHB',
            _enteredPhoneNumber);
        setState(() {
          // Reset form fields
          _enteredName = '';
          _enteredPhoneNumber = '';
          _enteredEmail = '';
          _profession = '';
          _city = '';
          _value1 = false;
          _value2 = false;
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
          _value1;
          _value2;
          _formKey.currentState!.reset();
        });
      }
    }
  }

  // ignore: no_leading_underscores_for_local_identifiers
  void sendSMS(String message, _enteredPhoneNumber) async {
    // Set the base URL
    String url = 'http://smsw.co.in/API/WebSMS/Http/v1.0a/index.php';
    // Set the query parameters
    Map<String, String> queryParams = {
      'username': 'Asepsis',
      'password': '4d436c-78a08',
      'sender': 'IWASHB',
      'to': _enteredPhoneNumber,
      'message': message,
      'reqid': '1',
      'format': '{json|text}',
      'pe_id': '1201159146626171588',
      'template_id': '1407166401065038909',
    };

    // Construct the full URL with query parameters
    Uri uri = Uri.parse(url).replace(queryParameters: queryParams);

    // Make the HTTP POST request
    http.Response response = await http.post(uri);

    // Check the response
    if (response.statusCode == 200) {
    } else {
      //print('Failed to send SMS: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Become a Store Partner'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
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
                        decoration: const InputDecoration(
                          labelText: "Full Name",
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.trim().length <= 1 ||
                              value.trim().length > 50) {
                            return 'Please Enter correct name.';
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
                        decoration: const InputDecoration(
                          labelText: "Job Title",
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter your Profession';
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
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: "Email",
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
                        height: 10,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: "Intrested City",
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter City.';
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
                            return 'Please enter a valid mobile number.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _enteredPhoneNumber = value!;
                        },
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: 'Mobile Number',
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text("Choose a option"),
                      CheckboxListTile(
                        title: const Text('Eco'),
                        value: _value1,
                        onChanged: (bool? value) {
                          setState(() {
                            _value1 = value ?? false;
                          });
                        },
                      ),
                      CheckboxListTile(
                        title: const Text('Elite'),
                        value: _value2,
                        onChanged: (bool? value) {
                          setState(() {
                            _value2 = value ?? false;
                          });
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: _saveItem,
                            style: ElevatedButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                              ),
                              elevation: 0,
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.orange,
                            ),
                            child: const Text(
                              "Raise Your Query",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

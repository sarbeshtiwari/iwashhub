// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<bool> showFeedbackForm(BuildContext context) async {
  int rating = 0;
  var Comment = '';
  bool submitted = false;
  TextEditingController _commentController = TextEditingController();

  // Check if a rating already exists for the current user
  final user = FirebaseAuth.instance.currentUser!;
  final doc = await FirebaseFirestore.instance
      .collection('feedback')
      .doc(user.uid)
      .get();
  if (doc.exists && doc.data()!.containsKey('rating')) {
    // Rating already exists, show a message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('You have already submited')),
    );
    return false;
  }

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Rate our app'),
              const SizedBox(height: 16),
              StatefulBuilder(
                builder: (context, setState) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        onPressed: () {
                          setState(() {
                            rating = index + 1;
                          });
                        },
                        icon: Icon(
                          index < rating ? Icons.star : Icons.star_border,
                          color: Colors.orange,
                        ),
                      );
                    }),
                  );
                },
              ),
              const Text("Comments"),
              TextField(
                autocorrect: true,
                autofocus: false,
                controller: _commentController,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  // Submit the rating
                  Comment = _commentController.text;
                  submitted = true;

                  // Update the rating in Firebase
                  FirebaseFirestore.instance
                      .collection('feedback')
                      .doc(user.uid)
                      .set({
                    'rating': rating,
                    'comment': Comment,
                    'Created At': FieldValue.serverTimestamp(),
                    // Add other fields as necessary
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Thanks for your feedback')),
                  );

                  // Redirect to the app's Play Store page
                  // final url = Uri.parse(
                  //     'https://play.google.com/store/apps/details?id=com.example.myapp');
                  // if (await canLaunchUrl(url)) {
                  //   await launchUrl(url);
                  // } else {
                  //   throw 'Could not launch $url';
                  // }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      );
    },
  );

  return submitted;
}



// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';

// Future<bool> showFeedbackForm(BuildContext context) async {
//   int rating = 0;
//   bool submitted = false;

//   await showModalBottomSheet(
//     context: context,
//     isScrollControlled: true,
//     builder: (context) {
//       return Padding(
//         padding: EdgeInsets.only(
//           bottom: MediaQuery.of(context).viewInsets.bottom,
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const Text('Rate our app'),
//               const SizedBox(height: 16),
//               StatefulBuilder(
//                 builder: (context, setState) {
//                   return Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: List.generate(5, (index) {
//                       return IconButton(
//                         onPressed: () {
//                           setState(() {
//                             rating = index + 1;
//                           });
//                         },
//                         icon: Icon(
//                           index < rating ? Icons.star : Icons.star_border,
//                           color: Colors.orange,
//                         ),
//                       );
//                     }),
//                   );
//                 },
//               ),
//               const SizedBox(height: 16),
//               ElevatedButton(
//                 onPressed: () async {
//                   // Check if a rating already exists for the current user
//                   final doc = await FirebaseFirestore.instance
//                       .collection('feedback')
//                       .doc('users')
//                       .get();
//                   if (doc.exists && doc.data()!.containsKey('rating')) {
//                     // Rating already exists, show a message
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(content: Text('You have already rated')),
//                     );
//                   } else {
//                     // Submit the rating
//                     print('Rating: $rating');
//                     submitted = true;

//                     // Update the rating in Firebase
//                     FirebaseFirestore.instance
//                         .collection('feedback')
//                         .doc('users')
//                         .set({
//                       'rating': rating,
//                       // Add other fields as necessary
//                     });

//                     // Redirect to the app's Play Store page
//                     // final url = Uri.parse(
//                     //     'https://play.google.com/store/apps/details?id=com.example.myapp');
//                     // if (await canLaunchUrl(url)) {
//                     //   await launchUrl(url);
//                     // } else {
//                     //   throw 'Could not launch $url';
//                     // }
//                   }
//                 },
//                 child: const Text('Submit'),
//               ),
//             ],
//           ),
//         ),
//       );
//     },
//   );

//   return submitted;
// }

// // Future<void> fetch() async {
// //     // Fetch user details from the Firebase database

// //     final user = FirebaseAuth.instance.currentUser!;
// //     final userSnapshot = await FirebaseFirestore.instance
// //         .collection('feedback')
// //         .doc(user.uid)
// //         .snapshots();

// //     userSnapshot.listen((snapshot) {
// //       if (snapshot.exists) {
// //         final userData = snapshot.data();
// //         if (userData != null) {
// //           if (userData['name'] != null &&
// //                   userData['name'].isNotEmpty &&
// //                   userData['address'] != null &&
// //                   userData['address'].isNotEmpty &&
// //                   userData['email'] != null &&
// //                   userData['email'].isNotEmpty
// //               //&&
// //               // userData['city'] != null &&
// //               // userData['city'].isNotEmpty
// //               ) {
// //             setState(() {
// //               username = userData['name'];
// //               var address = userData['address'];
// //               //city = userData['city'];
// //               var phoneNumber = userData['Phone Number'];
// //             });
            
// //           } else {
            
// //           }
// //         }
// //       }
// //     });
// //   }

// // void updatefeedback() async{
// //   final user = FirebaseAuth.instance.currentUser!;
// //   final userDoc = await FirebaseFirestore.instance
// //             .collection('users')
// //             .doc(user.uid)
// //             .get();
// //         if (!userDoc.exists) {
// //           // If the document doesn't exist, create a new one
// //           await FirebaseFirestore.instance
// //               .collection('users')
// //               .doc(user.uid)
// //               .set({
// //             'Phone Number': phoneNumber,
// //             'Created At': FieldValue.serverTimestamp(),
// //           });
// //         }
// // }
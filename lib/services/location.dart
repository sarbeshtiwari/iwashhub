// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:iwash/screen/screen2/booking_screen.dart';
// import 'package:location/location.dart' as loc;

// class LocationSc extends StatefulWidget {
//   const LocationSc({Key? key}) : super(key: key);
//   static const String id = "location-sc";

//   @override
//   State<LocationSc> createState() => _LocationScState();
// }

// class _LocationScState extends State<LocationSc> {
//   final loc.Location location = loc.Location();
//   loc.LocationData? _location;
//   String? _error;
//   String? _address;

//   Future<void> _getLocation() async {
//     try {
//       final loc.LocationData _locationResult = await location.getLocation();
//       setState(() {
//         _location = _locationResult;
//       });
//       final String address = await getAddressFromLatLng(
//           _locationResult.latitude!, _locationResult.longitude!);
//       setState(() {
//         _address = address;
//       });
//     } on PlatformException catch (err) {
//       setState(() {
//         _error = err.code;
//       });
//     }
//   }

//   Future<String> getAddressFromLatLng(double latitude, double longitude) async {
//     List<Placemark> placemarks =
//         await placemarkFromCoordinates(latitude, longitude);
//     Placemark place = placemarks[0];

//     String address =
//         "${place.name}, ${place.locality}, ${place.postalCode}, ${place.country}";
//     return address;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.map,
//               size: 100,
//             ),
//             SizedBox(height: 16),
//             Text('Allow us to locate you'),
//             SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () async {
//                 await _getLocation();
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => BookingScreen(location: _address!),
//                   ),
//                 );
//               },
//               child: Text('Fetch Location'),
//             ),
//             Spacer(),
//             TextButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => BookingScreen(location: ''),
//                   ),
//                 );
//               },
//               child: Text('Enter location manually'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

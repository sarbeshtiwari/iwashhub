import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:iwash/screen/screen2/coupons.dart';
import 'package:iwash/screen/screen2/previous_order.dart';
import 'package:iwash/services/Chat.dart';

import 'firebase_options.dart';

import 'package:iwash/API/fetch_data.dart';

import 'package:iwash/screen/main/home.dart';
import 'package:iwash/unused/login_screen.dart';
import 'package:iwash/screen/screen2/booking_screen.dart';
import 'package:iwash/screen/screen2/franchise_screen.dart';
import 'package:iwash/screen/screen2/order_confirm.dart';
import 'package:iwash/screen/starting/add_screen.dart';

import 'package:iwash/screen/starting/board_screen.dart';
import 'package:iwash/screen/screen2/help_support.dart';
import 'package:iwash/screen/screen2/notification_screen.dart';
import 'package:iwash/screen/screen2/privacy_policy.dart';
import 'package:iwash/screen/screen2/terms_condition.dart';
import 'package:iwash/screen/screen2/settings_screen.dart';
import 'package:iwash/screen/screen2/subscriptions_screen.dart';

import 'package:iwash/screen/main/price_screen.dart';
import 'package:iwash/screen/main/profile_screen.dart';
import 'package:iwash/screen/starting/splash_screen.dart';
import 'package:iwash/API/upload_data.dart';
import 'package:iwash/screen/authentication/signup_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      //Replace the 3 second delay with your initialization code:
      future: Future.delayed(const Duration(seconds: 5)),
      builder: (context, AsyncSnapshot snapshot) {
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                primaryColor: Colors.cyan.shade900, fontFamily: 'Latin'),
            home: StreamBuilder(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (ctx, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SplashScreen();
                  }

                  if (snapshot.hasData) {
                    return const SplashScreen();
                  }

                  return const SplashScreen();
                }),
            routes: {
              //we will add the screens here for easy navigation
              //parts of main screen
              Home.id: (context) => const Home(),
              ProfileScreen.id: (context) => const ProfileScreen(),
              PriceScreen.id: (context) => const PriceScreen(),

              //backend
              //LocationSc.id: (context) => const LocationSc(),

              //Screen 2 parts
              SubscriptionScreen.id: (context) => const SubscriptionScreen(),
              SettingsScreen.id: (context) => const SettingsScreen(),
              PrivacyPolicy.id: (context) => const PrivacyPolicy(),
              TermsCondition.id: (context) => const TermsCondition(),
              HelpSupport.id: (context) => const HelpSupport(),
              NotificationScreen.id: (context) => const NotificationScreen(),
              FranchiseScreen.id: (context) => const FranchiseScreen(),
              BookingScreen.id: (context) => BookingScreen(),
              OrderConfirm.id: (context) => const OrderConfirm(
                    phoneNumber: '',
                    city: '',
                    selectedStore: '',
                  ),
              PreviousOrder.id: (context) => const PreviousOrder(),
              Coupons.id: (context) => const Coupons(),

              //Inititials
              LoginScreen.id: (context) => const LoginScreen(),
              BoardScreen.id: (context) => const BoardScreen(),
              AddScreen.id: (context) => const AddScreen(),

              //to upload data and fetch data
              UploadData.id: (context) => const UploadData(),
              FetchData.id: (context) => const FetchData(
                    userDefinedValue: '',
                  ),

              //Authentication
              SignUpScreen.id: (context) => const SignUpScreen(),
              ChatbotApp.id: (context) => ChatbotApp(),
            });
      },
    );
  }
}

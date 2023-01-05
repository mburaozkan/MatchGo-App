import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/screens/home/home_screen.dart';
import 'package:shop_app/screens/sign_in/sign_in_screen.dart';
import 'package:shop_app/screens/splash/components/body.dart';
import 'package:shop_app/size_config.dart';
import 'package:shop_app/screens/splash/splash_screen.dart' as Path;

void main() {
  log("kmsdfdsf");
  runApp(SplashScreen());
}

class SplashScreen extends StatelessWidget {
  static String routeName = "/splash";
  @override
  Widget build(BuildContext context) {
    // You have to call it on your starting screen
    SizeConfig().init(context);

    return FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(body: Text('An Erorr Has Been Occured'));
          }

          if (snapshot.connectionState == ConnectionState.done) {
            return FutureBuilder<User>(builder: (context, snapshot) {
              print(FirebaseAuth.instance.currentUser);
              if (FirebaseAuth.instance.currentUser != null) {
                return HomeScreen();
              }

              return Scaffold(body: Body());
            });
          }

          return Scaffold(
            body: Column(
              children: [
                Body(),
              ],
            ),
          );
        });
  }
}

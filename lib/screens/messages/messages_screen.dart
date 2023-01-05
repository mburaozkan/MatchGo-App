import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/components/coustom_bottom_nav_bar.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/enums.dart';
import 'package:shop_app/screens/messages/components/body.dart';

class MessagesScreen extends StatelessWidget {
  static String routeName = "/messages";
  final User? crntUser;
  const MessagesScreen({Key? key, required this.crntUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Messages",
            textAlign: TextAlign.start,
            style: TextStyle(
                color: kPrimaryColor,
                fontFamily: "Montserrat",
                fontWeight: FontWeight.bold),
          ),
        ),
        body: Body(),
        bottomNavigationBar:
            CustomBottomNavBar(selectedMenu: MenuState.message));
  }
}

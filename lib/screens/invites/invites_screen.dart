import 'package:flutter/material.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/screens/invites/components/body.dart';

class InvitesScreen extends StatelessWidget {
  final int len;
  const InvitesScreen({Key? key, required this.len}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Invites",
          style: TextStyle(color: kPrimaryColor),
        ),
      ),
      body: Body(length: len),
    );
  }
}

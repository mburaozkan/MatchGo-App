import 'package:flutter/material.dart';

import 'components/body.dart';

class CompleteProfileScreen extends StatelessWidget {
  final String email;
  final String password;
  const CompleteProfileScreen(
      {Key? key, required this.email, required this.password});
  static String routeName = "/complete_profile";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Body(
        email: email,
        password: password,
      ),
    );
  }
}

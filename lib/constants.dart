import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xFF8D81D9);
const kPrimaryPurple = Color(0xFF8D81D9);
const kPrimaryPink = Color(0xFFF9999D);
const kprimaryGrey = Color(0xFFd3D3D3);
const kTextFieldGray = Color(0xFFE2E2E2);
const kprimaryWhite = Color(0xF2F2F2);
const kPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFFFA53E), Color(0xFFFF7643)],
);
const kSecondaryColor = Color(0xFF979797);
const kTextColor = Color(0xFF757575);

const kAnimationDuration = Duration(milliseconds: 200);

final headingStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: kPrimaryPurple,
    height: 1.5,
    fontFamily: 'Montserrat');

const defaultDuration = Duration(milliseconds: 250);

// Form Error
final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
const String kEmailNullError = "Please Enter your email";
const String kInvalidEmailError = "Please Enter Valid Email";
const String kPassNullError = "Please Enter your password";
const String kShortPassError = "Password is too short";
const String kMatchPassError = "Passwords don't match";
const String kNamelNullError = "Please Enter your name";
const String kPhoneNumberNullError = "Please Enter your phone number";
const String kAddressNullError = "Please Enter your address";

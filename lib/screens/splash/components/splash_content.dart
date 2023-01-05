import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class SplashContent extends StatelessWidget {
  const SplashContent({
    Key? key,
    this.text,
    this.image,
  }) : super(key: key);
  final String? text, image;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: SizeConfig.screenWidth * 0.8,
          child: Text(
            text!,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: kPrimaryPurple,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold),
          ),
        ),
        Padding(padding: EdgeInsets.all(20)),
        Image.asset(
          image!,
          width: SizeConfig.screenWidth * 0.8,
        ),
      ],
    );
  }
}

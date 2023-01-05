import 'package:flutter/material.dart';
import 'package:shop_app/constants.dart';

class TextItemField extends StatelessWidget {
  TextEditingController controller = new TextEditingController();
  late String text;
  final String labelText;
  final String hintText;
  final int maxLines;
  TextItemField({
    Key? key,
    required this.labelText,
    required this.hintText,
    required this.maxLines,
  }) : super(key: key);

  String getText() {
    return text;
  }

  void setText(String newText) {
    text = newText;
  }

  get getController => controller;

  void setNull() {
    controller.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(color: kPrimaryPurple),
      controller: controller,
      maxLines: maxLines,
      onSaved: (newValue) {},
      onChanged: (value) {
        setText(value);
      },
      validator: (value) {},
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }
}

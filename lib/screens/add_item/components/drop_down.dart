import 'package:flutter/material.dart';

class DropDown extends StatefulWidget {
  late String text = text;
  final List dropDownItemList;
  final String hint;
  DropDown(
      {Key? key,
      required this.dropDownItemList,
      required this.hint,
      String? text})
      : super(key: key);

  String getText() {
    return text == "" ? "All" : text;
  }

  void setText(newText) {
    text = newText;
  }

  @override
  State<DropDown> createState() => _DropDownState();
}

class _DropDownState extends State<DropDown> {
  var dropDownValue;
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade600),
            borderRadius: BorderRadius.circular(25.0)),
        child: Padding(
          padding: EdgeInsets.fromLTRB(40.0, 5.0, 20.0, 5.0),
          child: DropdownButton(
              value: dropDownValue,
              hint: Text(widget.hint),
              icon: Icon(Icons.arrow_drop_down),
              iconSize: 30,
              isExpanded: true,
              style: TextStyle(color: Colors.black, fontSize: 16),
              items: widget.dropDownItemList.map((valueItem) {
                return DropdownMenuItem(
                  value: valueItem,
                  child: Text(valueItem),
                );
              }).toList(),
              onChanged: (newValue) {
                widget.setText(newValue);
                setState(() {
                  dropDownValue = newValue;
                });
              }),
        ));
  }
}

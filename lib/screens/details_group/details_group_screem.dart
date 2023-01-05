import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/components/default_button.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/screens/details_group/components/body.dart';
import 'package:shop_app/screens/sign_in/components/text_item_field.dart';

class GroupDetailScreen extends StatelessWidget {
  final String url;
  final String name;
  final String description;
  final String category;
  const GroupDetailScreen(
      {Key? key,
      required this.url,
      required this.name,
      required this.description,
      required this.category})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var addUsers = TextItemField(
        labelText: "Add Users",
        hintText: "Notation for adding @user_name1,@user_name2..",
        maxLines: 3);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              name,
              style: TextStyle(color: kPrimaryColor),
            ),
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: SingleChildScrollView(
                            child: Container(
                              child: Column(
                                children: [
                                  addUsers,
                                  Padding(padding: EdgeInsets.all(20)),
                                  DefaultButton(
                                    text: "Click me",
                                    press: () {
                                      var userNameMap = addUsers
                                          .getText()
                                          .split(",")
                                          .map((e) {
                                        return e;
                                      });
                                      userNameMap.forEach((element) {
                                        FirebaseFirestore.instance
                                            .collection("collection")
                                            .doc("invites")
                                            .collection(element)
                                            .add({
                                          "name": name,
                                          "description": description,
                                          "category": category,
                                          "url": url
                                        });
                                      });
                                    },
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                },
                icon: Icon(Icons.plus_one))
          ],
        ),
      ),
      body: Body(
          url: url, name: name, description: description, category: category),
    );
  }
}

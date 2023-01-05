import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/components/default_button.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/screens/add_item/components/drop_down.dart';
import 'package:shop_app/size_config.dart';

List dropDownItemList = [
  "All",
  "Electronics",
  "Home & Life",
  "Clothings",
  "Hobbies",
  "Book & Magazine",
  "Others"
];

class Body extends StatefulWidget {
  final int length;
  const Body({Key? key, required this.length}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String searchText = "";
  bool clicked = false;
  bool returned = false;
  DropDown dropDown = DropDown(
    dropDownItemList: dropDownItemList,
    hint: "Category for Group",
    text: "All",
  );

  @override
  Widget build(BuildContext context) {
    dropDown.setText("All");

    TextEditingController controller = new TextEditingController();
    return Container(
        child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: TextField(
            controller: controller,
          ),
        ),
        dropDown,
        Padding(padding: EdgeInsets.all(10)),
        DefaultButton(
          text: "Click",
          press: () {
            setState(() {
              searchText = controller.text;
              clicked = true;
            });
          },
        ),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('collection')
              .doc('groups')
              .collection('userGroups')
              .orderBy('name')
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                  child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
              ));
            } else {
              return Flexible(
                child: Container(
                  height: SizeConfig.screenHeight * 0.8,
                  child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    padding: EdgeInsets.all(8.0),
                    itemBuilder: (context, index) {
                      return FutureBuilder(
                          future: FirebaseFirestore.instance
                              .collection('collection')
                              .doc('groups')
                              .collection('userGroups')
                              .orderBy('name')
                              .get()
                              .then((querySnapshot) {
                            return {
                              'name': querySnapshot.docs[index].data()['name'],
                              'description': querySnapshot.docs[index]
                                  .data()['description'],
                              // ignore: equal_keys_in_map
                              'category':
                                  querySnapshot.docs[index].data()['category'],
                              'url': querySnapshot.docs[index].data()['url'],
                              'adminId':
                                  querySnapshot.docs[index].data()['adminId']
                            };
                          }),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Text("Something Went Wrong");
                            }

                            if (snapshot.connectionState ==
                                    ConnectionState.done &&
                                snapshot.data != null) {
                              Map<String, dynamic> map =
                                  snapshot.data as Map<String, dynamic>;

                              String name = map['name'];
                              String description = map['description'];
                              String category = map['category'];
                              String url = map['url'];
                              String adminId = map['adminId'];

                              if (dropDown.text == category) {
                                if (name
                                        .toLowerCase()
                                        .contains(searchText.toLowerCase()) &&
                                    searchText != "") {
                                  return GroupCard(
                                    url: url,
                                    name: name,
                                    description: description,
                                    category: category,
                                    adminId: adminId,
                                  );
                                } else if (searchText == "") {
                                  return GroupCard(
                                    url: url,
                                    name: name,
                                    description: description,
                                    category: category,
                                    adminId: adminId,
                                  );
                                } else {
                                  return Container();
                                }
                              } else if (dropDown.text == "All") {
                                if (name
                                        .toLowerCase()
                                        .contains(searchText.toLowerCase()) &&
                                    searchText != "") {
                                  return GroupCard(
                                    url: url,
                                    name: name,
                                    description: description,
                                    category: category,
                                    adminId: adminId,
                                  );
                                } else if (searchText == "") {
                                  return GroupCard(
                                    url: url,
                                    name: name,
                                    description: description,
                                    category: category,
                                    adminId: adminId,
                                  );
                                } else {
                                  return Container();
                                }
                              }
                            }

                            return Container();
                          });
                    },
                  ),
                ),
              );
            }
          },
        ),
      ],
    ));
  }
}

class GroupCard extends StatelessWidget {
  final String url;
  final String name;
  final String description;
  final String category;
  final String adminId;
  const GroupCard(
      {Key? key,
      required this.url,
      required this.name,
      required this.description,
      required this.category,
      required this.adminId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = TextStyle(
      color: Colors.white,
    );
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
              color: kPrimaryColor,
              borderRadius: BorderRadius.all(Radius.circular(8.0))),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              children: [
                Container(
                  height: 90,
                  width: 90,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.all(Radius.circular(45.0))),
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(40.0)),
                          image:
                              DecorationImage(image: NetworkImage(this.url))),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        this.name,
                        textAlign: TextAlign.left,
                        style: textStyle,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        this.category,
                        textAlign: TextAlign.right,
                        style: textStyle,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
      onTap: () {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Container(
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(image: NetworkImage(url))),
                      ),
                      Text(name),
                      Text(category),
                      Text(description),
                      DefaultButton(
                        text: "Send Request",
                        press: () {
                          FirebaseFirestore.instance
                              .collection("collection")
                              .doc("requests")
                              .collection(name)
                              .add({
                            "userId": FirebaseAuth.instance.currentUser!.uid,
                            "userName": FirebaseAuth.instance.currentUser!.email
                          });
                        },
                      )
                    ],
                  ),
                ),
              );
            });
      },
    );
  }
}

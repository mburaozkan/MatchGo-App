import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/size_config.dart';

class Body extends StatefulWidget {
  final int length;
  const Body({Key? key, required this.length}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    var currnetUser = FirebaseAuth.instance.currentUser;
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('collection')
            .doc('invites')
            .collection("@${currnetUser!.email}")
            .snapshots(),
        builder: (context, snapshots) {
          if (!snapshots.hasData) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
              ),
            );
          } else {
            return Container(
              child: ListView.builder(
                  itemCount: 2,
                  itemBuilder: (context, index) {
                    return FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection('collection')
                            .doc('invites')
                            .collection("@${currnetUser.email}")
                            .get()
                            .then((querySnapshots) {
                          return {
                            'id': querySnapshots.docs[index].id,
                            'name': querySnapshots.docs[index].data()['name'],
                            'description': querySnapshots.docs[index]
                                .data()['description'],
                            'category':
                                querySnapshots.docs[index].data()['category'],
                            'url': querySnapshots.docs[index].data()['url'],
                          };
                        }),
                        builder: (context, snaphot) {
                          if (snaphot.hasError) {
                            return Container(
                              child: Text("Something went wrong"),
                            );
                          }

                          if (snaphot.connectionState == ConnectionState.done) {
                            Map<String, dynamic> map =
                                snaphot.data as Map<String, dynamic>;
                            log(map['url']);
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                    color: kPrimaryColor,
                                    borderRadius: BorderRadius.circular(15)),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 80,
                                          height: 80,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(40),
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                      map['url']))),
                                        ),
                                        Padding(
                                            padding: EdgeInsets.only(
                                                left: SizeConfig.screenWidth *
                                                    0.05)),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              map['name'],
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15),
                                            ),
                                            Padding(
                                                padding:
                                                    EdgeInsets.only(top: 10)),
                                            Text(
                                              map['category'],
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 13),
                                            )
                                          ],
                                        ),
                                        Padding(
                                            padding: EdgeInsets.only(
                                                left: SizeConfig.screenWidth *
                                                    0.05)),
                                        IconButton(
                                            onPressed: () async {
                                              log("in");
                                              await FirebaseFirestore.instance
                                                  .collection("collection")
                                                  .doc("users")
                                                  .collection(FirebaseAuth
                                                      .instance
                                                      .currentUser!
                                                      .uid)
                                                  .doc("chats")
                                                  .collection("groups")
                                                  .add({
                                                "name": map['name'],
                                                "url": map['url'],
                                                "category": map['category'],
                                                "description":
                                                    map["description"]
                                              });
                                              log("1");
                                              await FirebaseFirestore.instance
                                                  .collection("collection")
                                                  .doc("usersInGroups")
                                                  .collection(map['name'])
                                                  .add({
                                                "name": FirebaseAuth.instance
                                                    .currentUser!.email,
                                                "id": FirebaseAuth
                                                    .instance.currentUser!.uid
                                              });
                                              log("2");
                                              log(map["userCount"].toString());
                                              await FirebaseFirestore.instance
                                                  .collection("collection")
                                                  .doc("groups")
                                                  .collection("userGroups")
                                                  .doc(map['name'])
                                                  .update({
                                                "name": map['name'],
                                                "description":
                                                    map["description"],
                                                "category": map["category"],
                                                "url": map["url"]
                                              });
                                              log("3");

                                              await FirebaseFirestore.instance
                                                  .collection('collection')
                                                  .doc('invites')
                                                  .collection(
                                                      "@${currnetUser.email}")
                                                  .doc(map['id'])
                                                  .delete();
                                              log("4");
                                            },
                                            icon: Icon(Icons.check)),
                                        IconButton(
                                            onPressed: () {
                                              FirebaseFirestore.instance
                                                  .collection('collection')
                                                  .doc('invites')
                                                  .collection(
                                                      "@${currnetUser.email}")
                                                  .doc(map['id'])
                                                  .delete();
                                            },
                                            icon: Icon(Icons.close))
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }

                          return Center(
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(kPrimaryColor),
                            ),
                          );
                        });
                  }),
            );
          }
        });
  }
}

class InviteCard extends StatelessWidget {
  final String name;
  final String url;
  const InviteCard({Key? key, required this.name, required this.url})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(),
    );
  }
}

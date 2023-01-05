import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/screens/messages/components/group_chat.dart';
import '../../../size_config.dart';
import 'swipeable_cards.dart';

String plus =
    "https://upload.wikimedia.org/wikipedia/commons/thumb/9/9e/Plus_symbol.svg/1200px-Plus_symbol.svg.png";
String search =
    "https://upload.wikimedia.org/wikipedia/commons/thumb/0/0b/Search_Icon.svg/500px-Search_Icon.svg.png";

Future<int> getCountGroup() async {
  QuerySnapshot productCollection = await FirebaseFirestore.instance
      .collection('collection')
      .doc("groups")
      .collection("userGroups")
      .get();
  int length = productCollection.size;

  return length;
}

int lengthGroup = 0;

class Body extends StatelessWidget {
  GestureDetector buildElement(String s, String url, BuildContext buildContext,
      String groupName, String category, String description) {
    return GestureDetector(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: kPrimaryPurple),
                borderRadius:
                    BorderRadius.circular(SizeConfig.screenHeight * 0.07),
              ),
              width: SizeConfig.screenHeight * 0.075,
              height: SizeConfig.screenHeight * 0.075,
              child: Padding(
                  padding: EdgeInsets.all(2),
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(url), fit: BoxFit.fill),
                      borderRadius: BorderRadius.circular(
                        SizeConfig.screenHeight * 0.6,
                      ),
                    ),
                  )),
            ),
          ),
          Text(
            s,
            maxLines: 1,
            style: TextStyle(color: kPrimaryPurple),
          )
        ],
      ),
      onTap: () {
        Navigator.push(
            buildContext,
            new MaterialPageRoute(
              builder: (context) => new GroupChat(
                url: url,
                name: s,
                description: description,
                currentUserId: FirebaseAuth.instance.currentUser!.uid,
                groupName: groupName,
                category: category,
              ),
            ));
      },
    );
  }

  Future<int> getCount() async {
    QuerySnapshot productCollection = await FirebaseFirestore.instance
        .collection('collection')
        .doc("users")
        .collection(FirebaseAuth.instance.currentUser!.uid)
        .doc("chats")
        .collection("groups")
        .get();
    int length = productCollection.size;

    return length;
  }

  @override
  Widget build(BuildContext context) {
    getCountGroup().then((value) {
      lengthGroup = value;
    });
    int length = 0;
    getCount().then((value) => length = value);
    return Container(
      decoration: BoxDecoration(
          border: Border(top: BorderSide(color: kPrimaryPurple, width: 0.5))),
      height: SizeConfig.screenHeight * 0.78 - 0.617 - 0.000143,
      child: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Container(
              child: Row(
                children: [
                  StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('collection')
                          .doc("users")
                          .collection(FirebaseAuth.instance.currentUser!.uid)
                          .doc("chats")
                          .collection("groups")
                          .limit(10)
                          .snapshots(),
                      builder: (context, s) {
                        return Flexible(
                          child: Container(
                            width: SizeConfig.screenWidth,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return FutureBuilder(
                                    future: FirebaseFirestore.instance
                                        .collection('collection')
                                        .doc("users")
                                        .collection(FirebaseAuth
                                            .instance.currentUser!.uid)
                                        .doc("chats")
                                        .collection("groups")
                                        .get()
                                        .then((querySnapshots) {
                                      length = querySnapshots.docs.length;

                                      return {
                                        "name": querySnapshots.docs[index]
                                            .data()['name'],
                                        "url": querySnapshots.docs[index]
                                            .data()['url'],
                                        "category": querySnapshots.docs[index]
                                            .data()['category'],
                                        "description": querySnapshots
                                            .docs[index]
                                            .data()['description'],
                                      };
                                    }),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasError) {
                                        return Text("Something Went Wrong");
                                      }

                                      if (snapshot.connectionState ==
                                              ConnectionState.done &&
                                          snapshot.data != null) {
                                        Map<String, dynamic> list = snapshot
                                            .data as Map<String, dynamic>;

                                        return buildElement(
                                            list["name"],
                                            list["url"],
                                            context,
                                            list["name"],
                                            list["category"],
                                            list["description"]);
                                      } else {
                                        return Center(
                                            child: CircularProgressIndicator(
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                        Color>(kPrimaryColor)));
                                      }
                                    });
                              },
                              itemCount: s.data!.docs.length,
                            ),
                          ),
                        );
                      }),
                ],
              ),
            ),
          ),
          Container(
            child: Padding(
                padding: EdgeInsets.fromLTRB(
                    MediaQuery.of(context).size.width * 0.000,
                    MediaQuery.of(context).size.height * 0.00,
                    MediaQuery.of(context).size.width * 0.0,
                    MediaQuery.of(context).size.height * 0.00),
                child: SwipableCards()),
          )
        ],
      )),
    );
  }
}

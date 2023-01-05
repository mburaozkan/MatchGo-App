import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_swipable/flutter_swipable.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/screens/messages/messages_screen.dart';
import 'package:shop_app/size_config.dart';

class CardBuilder extends StatelessWidget {
  final String title;
  final int priceInterval;
  final String name;
  final String hastags;
  final String userId;
  final String uploadId;
  const CardBuilder(
      {Key? key,
      required this.imageLink,
      required this.title,
      required this.priceInterval,
      required this.name,
      required this.hastags,
      required this.userId,
      required this.uploadId})
      : super(key: key);

  final String imageLink;

  @override
  Widget build(BuildContext context) {
    User? crntUser = FirebaseAuth.instance.currentUser;
    CollectionReference _firestore =
        FirebaseFirestore.instance.collection('collection');

    builder(TextStyle textStyle, String text) {
      return Text(name, style: textStyle);
    }

    hastagBuilder(TextStyle textStyle) {
      return Text(
        hastags,
        style: textStyle,
      );
    }

    Color intervalToColor(priceInterval) {
      switch (priceInterval) {
        case 0:
          return Colors.green;
        case 1:
          return Colors.yellow;
        case 2:
          return Colors.orange;
        case 3:
          return Colors.red;
        default:
          return Colors.white;
      }
    }

    const snackBar = SnackBar(
      content: Text('MATCHED'),
    );

// Find the ScaffoldMessenger in the widget tree
// and use it to show a SnackBar.
    return Swipable(
        onSwipeRight: (finalPosition) async {
          await _firestore
              .doc("users")
              .collection(crntUser!.uid)
              .doc("likes")
              .collection(userId)
              .doc("item")
              .collection(userId)
              .doc(uploadId)
              .set({uploadId: 1});

          await _firestore
              .doc("users")
              .collection(userId)
              .doc("liked_by")
              .collection(crntUser.uid)
              .doc("item")
              .collection(crntUser.uid)
              .doc(uploadId)
              .set({uploadId: 1});

          await _firestore
              .doc("users")
              .collection(userId)
              .doc("likes")
              .collection(crntUser.uid)
              .doc("item")
              .collection(crntUser.uid)
              .doc(uploadId)
              .get()
              .then((value) async {
            if (value.data() != null) {
              await _firestore
                  .doc("users")
                  .collection(userId)
                  .doc("chats")
                  .collection("users")
                  .add({
                userId: crntUser.uid,
                "name": crntUser.email,
                "url": ""
              });

              await _firestore
                  .doc("users")
                  .collection(crntUser.uid)
                  .doc("chats")
                  .collection("users")
                  .add({'userId': userId, "name": name, "url": ""});

              _firestore
                  .doc("chats")
                  .collection("userChat")
                  .doc("${crntUser.uid}")
                  .collection(userId)
                  .add({
                'message': "hello",
                "by": crntUser.uid,
                // ignore: todo
                // TODO: DO IT AS USERNME LATER
                "time": DateTime.now()
              });

              _firestore
                  .doc("chats")
                  .collection("userChat")
                  .doc(userId)
                  .collection("${crntUser.uid}")
                  .add({
                'message': "hello",
                "by": userId,
                "time": DateTime.now()
              });

              ScaffoldMessenger.of(context).showSnackBar(snackBar);

              Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (context) => new MessagesScreen(
                      crntUser: FirebaseAuth.instance.currentUser,
                    ),
                  ));
            }
          });
        },
        onSwipeLeft: (finalPosition) async {
          await _firestore
              .doc("users")
              .collection(crntUser!.uid)
              .doc("dislikes")
              .collection(userId)
              .doc("item")
              .set({uploadId: -1});
        },
        onSwipeUp: (finalPosition) async {
          await _firestore
              .doc("users")
              .collection(crntUser!.uid)
              .doc("passes")
              .collection(userId)
              .doc("item")
              .set({uploadId: 0});
        },
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      alignment: Alignment.center,
                      height: MediaQuery.of(context).size.height * 0.6,
                      width: MediaQuery.of(context).size.width * 0.8,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          gradient: LinearGradient(
                              colors: [kPrimaryPurple, kPrimaryPink])),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 3, 8, 3),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15.0)),
                                    color: Colors.white),
                                height:
                                    MediaQuery.of(context).size.height * 0.06,
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Container(
                                        width: SizeConfig.screenWidth * 0.1,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                                SizeConfig.screenWidth * 0.05),
                                            border: Border.all(
                                                color: kPrimaryPurple),
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    "https://mpchsschool.in/wp-content/uploads/2019/10/default-profile-picture.png"))),
                                      ),
                                    ),
                                    Container(
                                      width: SizeConfig.screenWidth * 0.60,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              builder(
                                                  TextStyle(
                                                      fontFamily: "Montserrat",
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: kPrimaryColor,
                                                      fontSize: 14),
                                                  "username"),
                                              Text(
                                                "Playstation 5",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    fontFamily: "Montserrat",
                                                    fontStyle: FontStyle.italic,
                                                    color: kPrimaryColor,
                                                    fontSize: 15),
                                              )
                                            ],
                                          ),
                                          Icon(Icons.ac_unit)
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15.0)),
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.50,
                                    width: MediaQuery.of(context).size.width *
                                        0.78,
                                    decoration: BoxDecoration(
                                        color: Colors.black,
                                        image: DecorationImage(
                                            image: NetworkImage(imageLink),
                                            fit: BoxFit.fitHeight),
                                        borderRadius:
                                            BorderRadius.circular(15.0)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.0)),
                                              child: Column(
                                                children: [],
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ])),
                ),
              ],
            ),
            Positioned(
                left: 0,
                bottom: 20,
                child: Container(
                  width: SizeConfig.screenWidth * 0.84,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                                color: kprimaryGrey,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            child: IconButton(
                                onPressed: () {},
                                icon: SvgPicture.asset(
                                    "assets/icons/pass_button.svg"))),
                        Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                                color: kprimaryGrey,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30))),
                            child: IconButton(
                                onPressed: () {},
                                color: kPrimaryColor,
                                icon: SvgPicture.asset(
                                    "assets/icons/cross_button.svg"))),
                        Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                                color: kprimaryGrey,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30))),
                            child: IconButton(
                                onPressed: () {},
                                icon: SvgPicture.asset(
                                    "assets/icons/liked_button.svg"))),
                        Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                                color: kprimaryGrey,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            child: IconButton(
                                onPressed: () {},
                                icon: SvgPicture.asset(
                                    "assets/icons/question_button.svg")))
                      ],
                    ),
                  ),
                )),
          ],
        ));
  }
}

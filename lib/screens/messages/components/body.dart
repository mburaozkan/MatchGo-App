import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/screens/messages/components/chat.dart';
import 'package:shop_app/size_config.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

Future<int> getCountMessages(
    String currentUserId, String oppositeUserId) async {
  QuerySnapshot productCollection = await FirebaseFirestore.instance
      .collection("collection")
      .doc("chats")
      .collection("userChat")
      .doc(currentUserId)
      .collection(oppositeUserId)
      .orderBy("time")
      .get();
  int length = productCollection.size;

  return length;
}

Future<int> getCount() async {
  QuerySnapshot productCollection = await FirebaseFirestore.instance
      .collection('collection')
      .doc("users")
      .collection(FirebaseAuth.instance.currentUser!.uid)
      .doc("chats")
      .collection("users")
      .get();
  int length = productCollection.size;

  return length;
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    int length = 0;
    getCount().then((value) => length = value);
    return Column(
      children: [
        Container(
            width: SizeConfig.screenWidth * 0.9,
            child: TextField(
              textAlign: TextAlign.left,
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                  hintText: "Search",
                  suffixIcon: Icon(Icons.search),
                  iconColor: kPrimaryColor),
            )),
        Container(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('collection')
                .doc("users")
                .collection(FirebaseAuth.instance.currentUser!.uid)
                .doc("chats")
                .collection(FirebaseAuth.instance.currentUser!.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
                  ),
                );
              } else {
                return Flexible(
                  child: Container(
                    height: SizeConfig.screenHeight * 0.8,
                    child: ListView.builder(
                      itemCount: length,
                      padding: EdgeInsets.all(10.0),
                      itemBuilder: (context, index) {
                        return FutureBuilder(
                            future: FirebaseFirestore.instance
                                .collection('collection')
                                .doc("users")
                                .collection(
                                    FirebaseAuth.instance.currentUser!.uid)
                                .doc("chats")
                                .collection("users")
                                .get()
                                .then((querySnapshot) {
                              return {
                                'name':
                                    querySnapshot.docs[index].data()['name'],
                                'url': querySnapshot.docs[index].data()['url'],
                                'userId':
                                    querySnapshot.docs[index].data()['userId']
                              };
                            }),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return Text("Something Went Wrong");
                              }

                              if (snapshot.connectionState ==
                                      ConnectionState.done &&
                                  snapshot.data != null) {
                                Map<String, dynamic> list =
                                    snapshot.data as Map<String, dynamic>;

                                return ChatCard(
                                    url: list['url'],
                                    name: list['name'],
                                    userId: list['userId']);
                              }

                              return Text("Loading");
                            });
                      },
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}

class ChatCard extends StatelessWidget {
  final String url;
  final String name;
  final String userId;
  const ChatCard(
      {Key? key, required this.url, required this.name, required this.userId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            child: GestureDetector(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: kPrimaryColor),
                          borderRadius: BorderRadius.circular(30)),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(3, 3, 3, 3),
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              color: kPrimaryColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25.0)),
                              image: DecorationImage(
                                  image: NetworkImage(this.url))),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    this.name,
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
              onTap: () {
                getCountMessages(FirebaseAuth.instance.currentUser!.uid, userId)
                    .then((value) {
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                      builder: (context) => new Chat(
                        url: this.url,
                        name: this.name,
                        incoming: {},
                        currentUserId: FirebaseAuth.instance.currentUser!.uid,
                        userId: userId,
                        len: value,
                      ),
                    ),
                  );
                });
              },
            ),
          ),
          Padding(padding: EdgeInsets.all(10.0)),
        ],
      ),
    );
  }
}

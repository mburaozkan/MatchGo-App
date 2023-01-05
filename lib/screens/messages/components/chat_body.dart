import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/size_config.dart';

class ChatBody extends StatefulWidget {
  final String currentUserId;
  final String oppositeUserId;
  int length;
  ChatBody(
      {Key? key,
      required this.currentUserId,
      required this.oppositeUserId,
      required this.length})
      : super(key: key);

  @override
  State<ChatBody> createState() => _ChatBodyState();
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

class _ChatBodyState extends State<ChatBody> {
  var _firestore = FirebaseFirestore.instance.collection("collection");
  var _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.screenHeight * 0.8,
      child: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .doc("chats")
                  .collection("userChat")
                  .doc("${widget.currentUserId}")
                  .collection("${widget.oppositeUserId}")
                  .snapshots(),
              builder: (context, snapshots) {
                if (!snapshots.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
                    ),
                  );
                } else {
                  return Flexible(
                    child: Container(
                      child: ListView.builder(
                        itemCount: snapshots.data!.docs.length,
                        padding: EdgeInsets.all(10.0),
                        itemBuilder: (context, index) {
                          return FutureBuilder(
                              future: FirebaseFirestore.instance
                                  .collection("collection")
                                  .doc("chats")
                                  .collection("userChat")
                                  .doc(widget.currentUserId)
                                  .collection(widget.oppositeUserId)
                                  .orderBy("time")
                                  .get()
                                  .then((querySnapshot) {
                                return {
                                  'message': querySnapshot.docs[index]
                                      .data()['message'],
                                  'type':
                                      querySnapshot.docs[index].data()['type'],
                                  'by': querySnapshot.docs[index].data()['by'],
                                  'time':
                                      querySnapshot.docs[index].data()['time'],
                                };
                              }),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return Text("");
                                }

                                if (snapshot.connectionState ==
                                        ConnectionState.done &&
                                    snapshot.data != null) {
                                  Map<String, dynamic> list =
                                      snapshot.data as Map<String, dynamic>;

                                  CrossAxisAlignment crossAxisAlignment;
                                  BorderRadius borderRadius;
                                  Color boxColor;
                                  Alignment boxAlignment;

                                  if (list['by'] == widget.currentUserId) {
                                    crossAxisAlignment = CrossAxisAlignment.end;
                                    borderRadius = BorderRadius.only(
                                        topLeft: Radius.circular(5),
                                        topRight: Radius.circular(5),
                                        bottomLeft: Radius.circular(5));
                                    boxColor = kPrimaryColor;
                                    boxAlignment = Alignment.centerRight;
                                  } else {
                                    crossAxisAlignment =
                                        CrossAxisAlignment.start;

                                    borderRadius = BorderRadius.only(
                                        topLeft: Radius.circular(5),
                                        topRight: Radius.circular(5),
                                        bottomRight: Radius.circular(5));
                                    boxColor = kPrimaryPink;
                                    boxAlignment = Alignment.centerLeft;
                                  }

                                  if (list['type'] == "image") {
                                    return Container(
                                      alignment: boxAlignment,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          constraints: BoxConstraints(
                                              minWidth: 100, maxWidth: 300),
                                          child: Column(
                                            crossAxisAlignment:
                                                crossAxisAlignment,
                                            children: [
                                              Padding(
                                                  padding:
                                                      const EdgeInsets.all(3.0),
                                                  child: Image.network(
                                                      list['message'])),
                                            ],
                                          ),
                                          decoration: BoxDecoration(
                                              color: boxColor,
                                              borderRadius: borderRadius),
                                        ),
                                      ),
                                    );
                                  } else {
                                    return Container(
                                      alignment: boxAlignment,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          constraints: BoxConstraints(
                                              minWidth: 100, maxWidth: 300),
                                          child: Column(
                                            crossAxisAlignment:
                                                crossAxisAlignment,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(3.0),
                                                child: Text(
                                                  list['message'],
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 15),
                                                ),
                                              ),
                                            ],
                                          ),
                                          decoration: BoxDecoration(
                                              color: boxColor,
                                              borderRadius: borderRadius),
                                        ),
                                      ),
                                    );
                                  }
                                }

                                return Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        kPrimaryColor),
                                  ),
                                );
                              });
                        },
                      ),
                    ),
                  );
                }
              }),
        ],
      ),
    );
  }
}

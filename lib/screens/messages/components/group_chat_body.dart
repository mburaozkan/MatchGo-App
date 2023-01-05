import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/constants.dart';

class GroupChatBody extends StatefulWidget {
  final String currentUserId;
  final String groupName;
  const GroupChatBody(
      {Key? key, required this.currentUserId, required this.groupName})
      : super(key: key);

  @override
  State<GroupChatBody> createState() => _GroupChatBodyState();
}

Future<int> getCount(String groupName) async {
  QuerySnapshot productCollection = await FirebaseFirestore.instance
      .collection("collection")
      .doc("chats")
      .collection(groupName)
      .orderBy("time")
      .get();
  int length = productCollection.size;

  return length;
}

class _GroupChatBodyState extends State<GroupChatBody> {
  var _firestore = FirebaseFirestore.instance.collection("collection");
  var _controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    int length = 0;
    getCount(widget.groupName).then((value) => length = value);

    return StreamBuilder(
        stream: _firestore
            .doc("chats")
            .collection(widget.groupName)
            .limit(1)
            .snapshots(),
        builder: (context, snapshots) {
          if (!snapshots.hasData) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: length,
              controller: _controller,
              padding: EdgeInsets.all(10.0),
              itemBuilder: (context, index) {
                return FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection("collection")
                        .doc("chats")
                        .collection(widget.groupName)
                        .orderBy("time")
                        .get()
                        .then((querySnapshot) {
                      return {
                        'message': querySnapshot.docs[index].data()['message'],
                        'by': querySnapshot.docs[index].data()['by'],
                        'time': querySnapshot.docs[index].data()['time'],
                      };
                    }),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text("");
                      }

                      if (snapshot.connectionState == ConnectionState.done &&
                          snapshot.data != null) {
                        Map<String, dynamic> list =
                            snapshot.data as Map<String, dynamic>;

                        CrossAxisAlignment crossAxisAlignment;
                        BorderRadius borderRadius;

                        if (list['by'] == widget.currentUserId) {
                          crossAxisAlignment = CrossAxisAlignment.end;
                          borderRadius = BorderRadius.only(
                              topLeft: Radius.circular(5),
                              topRight: Radius.circular(5),
                              bottomLeft: Radius.circular(5));
                        } else {
                          crossAxisAlignment = CrossAxisAlignment.start;

                          borderRadius = BorderRadius.only(
                              topLeft: Radius.circular(5),
                              topRight: Radius.circular(5),
                              bottomRight: Radius.circular(5));
                        }

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            child: Column(
                              crossAxisAlignment: crossAxisAlignment,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Text(
                                    list['by'],
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 10),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Text(
                                    list['message'],
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 15),
                                  ),
                                ),
                              ],
                            ),
                            decoration: BoxDecoration(
                                color: kPrimaryColor,
                                borderRadius: borderRadius),
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
              },
            );
          }
        });
  }
}

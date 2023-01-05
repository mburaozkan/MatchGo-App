import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/screens/details_group/details_group_screem.dart';
import 'package:shop_app/screens/messages/components/group_chat_body.dart';
import 'package:shop_app/size_config.dart';

int i = 0;

class GroupChat extends StatefulWidget {
  final String name;
  final String url;
  final String category;
  final String description;
  final String currentUserId;
  final String groupName;
  const GroupChat(
      {Key? key,
      required this.name,
      required this.url,
      required this.category,
      required this.description,
      required this.currentUserId,
      required this.groupName})
      : super(key: key);

  @override
  State<GroupChat> createState() => _ChatState();
}

class _ChatState extends State<GroupChat> {
  late List<Widget> messages = [];

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = new TextEditingController();

    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          titleSpacing: 0,
          automaticallyImplyLeading: false,
          title: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => new GroupDetailScreen(
                            url: widget.url,
                            name: widget.groupName,
                            description: widget.description,
                            category: widget.category,
                          )));
            },
            child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(color: Colors.orange.shade100),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => Navigator.of(context).pop()),
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25.0),
                        image: DecorationImage(
                            image: NetworkImage(this.widget.url))),
                  ),
                  Padding(
                      padding:
                          EdgeInsets.only(left: SizeConfig.screenWidth * 0.1)),
                  Text(
                    "${this.widget.name}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomSheet: Row(
          children: [
            Flexible(
              child: TextFormField(
                controller: controller,
              ),
            ),
            IconButton(
                onPressed: () {
                  FirebaseFirestore.instance
                      .collection("collection")
                      .doc("chats")
                      .collection(widget.groupName)
                      .add({
                    'message': controller.text,
                    'by': widget.currentUserId,
                    'time': DateTime.now()
                  });

                  controller.text = "";
                },
                icon: Icon(Icons.send))
          ],
        ),
        body: GroupChatBody(
          currentUserId: widget.currentUserId,
          groupName: widget.groupName,
        ));
  }
}

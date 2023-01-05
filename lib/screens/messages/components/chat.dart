import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/screens/messages/components/chat_body.dart';

int i = 0;

class Chat extends StatefulWidget {
  final String name;
  final String url;
  final Map<String, String> incoming;
  final String currentUserId;
  final String userId;
  final int len;
  const Chat(
      {Key? key,
      required this.name,
      required this.url,
      required this.incoming,
      required this.currentUserId,
      required this.userId,
      required this.len})
      : super(key: key);

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  late List<Widget> messages = [];

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = new TextEditingController();

    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          titleSpacing: 0,
          automaticallyImplyLeading: false,
          title: Container(
            height: 60,
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
                color: kprimaryWhite,
                border:
                    Border(bottom: BorderSide(color: kPrimaryColor, width: 3))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                    icon: Icon(Icons.arrow_back, color: kPrimaryColor),
                    onPressed: () => Navigator.of(context).pop()),
                Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: kPrimaryColor),
                        borderRadius: BorderRadius.circular(25)),
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.0),
                            image: DecorationImage(
                                image: NetworkImage(this.widget.url))),
                      ),
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.all(5)),
                Text(
                  "${this.widget.name}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: "Montserrat",
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        bottomSheet: Container(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 5),
          child: TextFormField(
            decoration: InputDecoration(
                filled: true,
                fillColor: kTextFieldGray,
                hintText: "Message...",
                hintStyle: TextStyle(
                    color: kPrimaryColor,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.bold),
                suffixIcon: IconButton(
                    onPressed: () {
                      FirebaseFirestore.instance
                          .collection("collection")
                          .doc("chats")
                          .collection("userChat")
                          .doc(widget.currentUserId)
                          .collection(widget.userId)
                          .add({
                        'message': controller.text,
                        'type': "text",
                        'by': widget.currentUserId,
                        'time': DateTime.now()
                      });

                      FirebaseFirestore.instance
                          .collection("collection")
                          .doc("chats")
                          .collection("userChat")
                          .doc(widget.userId)
                          .collection(widget.currentUserId)
                          .add({
                        'message': controller.text,
                        'type': "text",
                        'by': widget.currentUserId,
                        'time': DateTime.now()
                      });

                      controller.text = "";
                    },
                    icon: SvgPicture.asset(
                        "assets/icons/send_message_button.svg")),
                prefixIcon: Padding(
                  padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        color: kPrimaryColor,
                        borderRadius: BorderRadius.circular(25)),
                    child: IconButton(
                      onPressed: () async {
                        ImagePicker _picker = new ImagePicker();
                        XFile? image = await _picker.pickImage(
                            source: ImageSource.gallery, imageQuality: 50);

                        User? currentUser = FirebaseAuth.instance.currentUser;
                        Reference ref = FirebaseStorage.instance
                            .ref("uploads/" + currentUser!.uid)
                            .child(DateTime.now().toString());

                        await ref.putFile(File(image!.path));

                        String url = await ref.getDownloadURL();

                        FirebaseFirestore.instance
                            .collection("collection")
                            .doc("chats")
                            .collection("userChat")
                            .doc(widget.currentUserId)
                            .collection(widget.userId)
                            .add({
                          'message': url,
                          'type': "image",
                          'by': widget.currentUserId,
                          'time': DateTime.now()
                        });

                        FirebaseFirestore.instance
                            .collection("collection")
                            .doc("chats")
                            .collection("userChat")
                            .doc(widget.userId)
                            .collection(widget.currentUserId)
                            .add({
                          'message': url,
                          'type': "image",
                          'by': widget.currentUserId,
                          'time': DateTime.now()
                        });
                      },
                      icon: SvgPicture.asset(
                          "assets/icons/send_image_button.svg"),
                    ),
                  ),
                )),
            controller: controller,
          ),
        ),
        body: ChatBody(
          currentUserId: widget.currentUserId,
          oppositeUserId: widget.userId,
          length: widget.len,
        ));
  }
}

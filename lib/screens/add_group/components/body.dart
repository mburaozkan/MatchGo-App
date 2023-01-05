import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shop_app/components/default_button.dart';
import 'package:shop_app/screens/add_item/components/drop_down.dart';
import 'package:shop_app/screens/sign_in/components/text_item_field.dart';
import 'package:shop_app/size_config.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;

String camera =
    "https://w7.pngwing.com/pngs/639/614/png-transparent-computer-icons-camera-camera-photography-rectangle-camera-icon.png";

const snackBar = SnackBar(
  content: Text('This Group Name Already Taken!'),
);

List dropDownItemList = [
  "Electronics",
  "Home & Life",
  "Clothings",
  "Hobbies",
  "Book & Magazine",
  "Others"
];

CollectionReference _firebase =
    FirebaseFirestore.instance.collection("collection");

var name =
    TextItemField(labelText: "Name", hintText: "Ex: TechNerds", maxLines: 1);

var description = TextItemField(
    labelText: "Description",
    hintText: "Declare a description for the group. (optional) ",
    maxLines: 2);

var addUsers = TextItemField(
    labelText: "Add Users",
    hintText: "Notation for adding @user_name1,@user_name2..",
    maxLines: 3);

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  File imageFile = new File(camera);

  Object getChild() {
    if (imageFile == File(camera)) {
      return NetworkImage(camera);
    } else {
      return imageFile;
    }
  }

  @override
  Widget build(BuildContext context) {
    _getFromGallery() async {
      // ignore: deprecated_member_use
      PickedFile? pickedFile = await ImagePicker().getImage(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
        setState(() {
          imageFile = File(pickedFile.path);
        });
      }
    }

    DropDown dropDown = DropDown(
        dropDownItemList: dropDownItemList, hint: "Category for Group");

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(10),
            ),
            Row(
              children: [
                GestureDetector(
                  child: Container(
                    height: SizeConfig.screenWidth * 0.2,
                    width: SizeConfig.screenWidth * 0.2,
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(50),
                        image: DecorationImage(image: FileImage(imageFile))),
                  ),
                  onTap: () async {
                    _getFromGallery();
                    setState(() {});
                  },
                ),
                Padding(padding: EdgeInsets.all(10)),
                Container(width: SizeConfig.screenWidth * 0.66, child: name)
              ],
            ),
            Padding(
              padding: EdgeInsets.all(20),
            ),
            dropDown,
            Padding(
              padding: EdgeInsets.all(20),
            ),
            description,
            Padding(
              padding: EdgeInsets.all(20),
            ),
            addUsers,
            Padding(
              padding: EdgeInsets.all(20),
            ),
            DefaultButton(
              text: "Create Group",
              press: () async {
                try {
                  await firebase_storage.FirebaseStorage.instance
                      .ref('uploads/${name.getText()}/GroupPhoto')
                      .putFile(imageFile);
                } on firebase_core.FirebaseException catch (e) {
                  // e.g, e.code == 'canceled'
                }

                String url = await firebase_storage.FirebaseStorage.instance
                    .ref('uploads/${name.getText()}/GroupPhoto')
                    .getDownloadURL();

                var nameTaken = false;

                await FirebaseFirestore.instance
                    .collection("collection")
                    .doc('groups')
                    .collection("userGroups")
                    .get()
                    .then((QuerySnapshot querySnapshot) {
                  querySnapshot.docs.forEach((doc) {
                    if (doc['name'] == name.getText()) {
                      nameTaken = true;

                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  });
                });

                if (name.getText() != "" &&
                    description.getText() != "" &&
                    !nameTaken &&
                    dropDown.text != "") {
                  _firebase
                      .doc("groups")
                      .collection("userGroups")
                      .doc(name.getText())
                      .set({
                    "name": name.getText(),
                    "description": description.getText(),
                    "category": dropDown.text,
                    "url": url,
                    "adminId": FirebaseAuth.instance.currentUser!.uid,
                    "userCount": 1
                  });

                  _firebase
                      .doc("usersInGroups")
                      .collection(name.getText())
                      .add({
                    "name": FirebaseAuth.instance.currentUser!.email,
                    "id": FirebaseAuth.instance.currentUser!.uid
                  });

                  _firebase.doc("chats").collection(name.getText()).add({
                    "by": "SYSTEM",
                    "message":
                        "This is a message that confirms you create group succsesfully.",
                    "time": DateTime.now()
                  });

                  _firebase
                      .doc("users")
                      .collection(FirebaseAuth.instance.currentUser!.uid)
                      .doc("chats")
                      .collection("groups")
                      .add({
                    "name": name.getText(),
                    "url": url,
                    "category": dropDown.text,
                    "description": description.getText(),
                    "admin": true
                  });

                  var userNameMap = addUsers.getText().split(",").map((e) {
                    return e;
                  });

                  userNameMap.forEach((element) {
                    _firebase.doc("invites").collection(element).add({
                      "name": name.getText(),
                      "description": description.getText(),
                      "category": dropDown.getText(),
                      "url": url
                    });
                  });

                  name.text = "";
                  description.text = "";
                  dropDown.text = "";

                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

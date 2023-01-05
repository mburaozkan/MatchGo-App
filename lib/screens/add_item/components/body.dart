import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shop_app/components/default_button.dart';
import 'package:shop_app/screens/add_item/components/add_photo.dart';
import 'package:shop_app/screens/add_item/components/drop_down.dart';
import 'package:shop_app/screens/sign_in/components/text_item_field.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

Future<void> uploadFile(String filePath, String dbPath) async {
  File file = File(filePath);

  try {
    await firebase_storage.FirebaseStorage.instance
        .ref('uploads/$dbPath')
        .putFile(file);
  } on firebase_core.FirebaseException catch (e) {
    // e.g, e.code == 'canceled'
  }
}

class _BodyState extends State<Body> {
  final User? user = FirebaseAuth.instance.currentUser;
  final CollectionReference _firestore =
      FirebaseFirestore.instance.collection('collection');

  List dropDownItemList = [
    "Electronics",
    "Home & Life",
    "Clothings",
    "Hobbies",
    "Book & Magazine",
    "Others"
  ];

  List dropDownPriceList = [
    // 0 Düşük 500 Orta 2500 Yüksek  -  Çok Yüksek
    // İSİM , TL/DOLAR İCON , ---- (MEDIUM)
    "0 - 500 (LOW)",
    "500- 2500 (MEDIUM)",
    "2500 - 7500 (HIGH)",
    "7500+ (TOO HIGH LOL)"
  ];

  @override
  Widget build(BuildContext context) {
    AddPhoto addPhoto = new AddPhoto();

    TextItemField title = new TextItemField(
      labelText: "Item Name",
      hintText: "Enter Item Name",
      maxLines: 1,
    );

    TextItemField description = new TextItemField(
      labelText: "Description",
      hintText: "Enter Item Description",
      maxLines: 1,
    );

    DropDown category = new DropDown(
      dropDownItemList: dropDownItemList,
      hint: "Select An Category",
    );

    DropDown priceInterval = new DropDown(
      dropDownItemList: dropDownPriceList,
      hint: "Enter Price Interval",
    );

    return SingleChildScrollView(
        child: Padding(
      padding: EdgeInsets.fromLTRB(30.0, 5.0, 25.0, 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          addPhoto,
          Text("Tip: add at least 3 photos"),
          Padding(padding: EdgeInsets.all(15.0)),
          category,
          Padding(padding: EdgeInsets.all(15.0)),
          title,
          Padding(padding: EdgeInsets.all(15.0)),
          priceInterval,
          Padding(padding: EdgeInsets.all(15.0)),
          description,
          Padding(padding: EdgeInsets.all(15.0)),
          Container(
              child: Padding(
            padding: EdgeInsets.fromLTRB(1, 15, 1, 15),
            child: DefaultButton(
              text: "Post",
              press: () async {
                List<XFile?> list = addPhoto.getList();

                // ignore: unnecessary_null_comparison
                if (title.getText() != "" &&
                    description.getText() != "" &&
                    category.getText() != "" &&
                    priceInterval.getText() != "") {
                  String uploadId = "";

                  await _firestore.doc("uploads").collection("userUploads").add(
                    {
                      'id': "1",
                      'title': title.getText(),
                      'category': category.getText(),
                      'priceInterval': priceInterval.getText(),
                      'description': description.getText(),
                      'imageCount': list.length.toString(),
                      'imagePath': "${user!.uid}/$uploadId",
                      'uploadId': "",
                      'hastags': "HASTAGS",
                      'by': user!.uid,
                      'byUserName': user!.email
                    },
                  ).then((value) {
                    uploadId = value.id;
                    // ignore: invalid_return_type_for_catch_error
                  }).catchError((erors) => log("some error occured"));

                  await _firestore
                      .doc("uploads")
                      .collection("userUploads")
                      .doc(uploadId)
                      .set({
                    'id': "1",
                    'title': title.getText(),
                    'category': category.getText(),
                    'priceInterval': priceInterval.getText(),
                    'description': description.getText(),
                    'imageCount': list.length.toString(),
                    'imagePath': "${user!.uid}/$uploadId",
                    'uploadId': uploadId,
                    'hastags': "HASTAGS",
                    'by': user!.uid,
                    'byUserName': user!.email
                  });

                  await _firestore
                      .doc("users")
                      .collection("uploadedItemIDs")
                      .doc(uploadId)
                      .set({
                    'id': "1",
                    'title': title.getText(),
                    'category': category.getText(),
                    'priceInterval': priceInterval.getText(),
                    'description': description.getText(),
                    'imageCount': list.length.toString(),
                    'imagePath': "${user!.uid}/$uploadId",
                    'uploadId': uploadId,
                    'hastags': "HASTAGS",
                    'by': user!.uid,
                    'byUserName': user!.email
                  });

                  int i = 0;
                  var imagePathList = [];
                  var imageLinkList = [];

                  list.forEach((element) async {
                    if (element != null) {
                      i++;
                      await uploadFile(
                              element.path, "${user!.uid}/$uploadId/$i")
                          .then((value) {
                        imagePathList.add("uploads/${user!.uid}/$uploadId/$i");
                      });
                    }
                  });

                  imagePathList.forEach((element) async {
                    //TODOOOOOOO THERE IS A FUCKING PROBLEM THT FUCKS THE SYSTEM FIX IT BITCH
                    String url = await firebase_storage.FirebaseStorage.instance
                        .ref(element)
                        .getDownloadURL();
                    imageLinkList.add(url);
                    log(imageLinkList.toString());
                  });

                  await _firestore
                      .doc("uploads")
                      .collection("userUploads")
                      .doc(uploadId)
                      .update({
                    'id': "1",
                    'title': title.getText(),
                    'category': category.getText(),
                    'priceInterval': priceInterval.getText(),
                    'description': description.getText(),
                    'imageCount': list.length.toString(),
                    'imageLinks': imageLinkList,
                    'uploadId': uploadId,
                    'hastags': "HASTAGS",
                    'by': user!.uid,
                    'byUserName': user!.email
                  }).then((value) {
                    Navigator.pop(context);
                  });
                } else {
                  // fill the fields
                }
              },
            ),
          )),
        ],
      ),
    ));
  }
}

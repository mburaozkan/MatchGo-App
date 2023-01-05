import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/screens/invites/invites_screen.dart';
import 'package:shop_app/screens/search_group/components/body.dart';

class GroupSearchScreen extends StatelessWidget {
  final int len;
  const GroupSearchScreen({Key? key, required this.len}) : super(key: key);

  Future<int> getCountInvites() async {
    var currnetUser = FirebaseAuth.instance.currentUser;
    QuerySnapshot productCollection = await FirebaseFirestore.instance
        .collection('collection')
        .doc("invites")
        .collection(currnetUser!.email.toString())
        .get();
    int length = productCollection.size;

    return length;
  }

  @override
  Widget build(BuildContext context) {
    var length;

    getCountInvites().then((value) {
      length = value;

      if (length == null) {
        length = 1;
      }
    });

    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Search",
                style: TextStyle(color: kPrimaryColor),
              ),
              IconButton(
                icon: Icon(Icons.person_add_alt_1),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              new InvitesScreen(len: length)));
                },
              )
            ],
          ),
        ),
        body: Body(length: len));
  }
}

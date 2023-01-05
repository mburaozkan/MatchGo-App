import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/size_config.dart';

class Body extends StatelessWidget {
  final String url;
  final String name;
  final String description;
  final String category;
  const Body(
      {Key? key,
      required this.url,
      required this.name,
      required this.description,
      required this.category})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(color: kPrimaryColor),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.bottomRight,
              width: SizeConfig.screenWidth,
              height: SizeConfig.screenHeight * 0.36,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.fitWidth, image: NetworkImage(url))),
              child: Padding(
                padding: EdgeInsets.only(right: 20),
                child: Text(
                  name,
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
            Container(
              child: Column(
                children: [
                  Padding(padding: EdgeInsets.all(5)),
                  Container(
                    width: SizeConfig.screenWidth,
                    decoration: BoxDecoration(color: Colors.orange),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 20),
                    width: SizeConfig.screenWidth,
                    child: Text(
                      description,
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                  Container(
                    width: SizeConfig.screenWidth,
                    decoration: BoxDecoration(color: Colors.orange),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 20),
                    width: SizeConfig.screenWidth,
                    child: Text(
                      category,
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                  Container(
                    width: SizeConfig.screenWidth,
                    decoration: BoxDecoration(color: Colors.orange),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(5)),
                ],
              ),
              decoration: BoxDecoration(),
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('collection')
                  .doc('usersInGroups')
                  .collection(name)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  // hastag topluluk ++
                  return Center(
                      child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
                  ));
                } else {
                  return Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(15)),
                        height: SizeConfig.screenHeight * 0.8,
                        width: SizeConfig.screenWidth,
                        child: ListView.builder(
                          itemCount: 1,
                          padding: EdgeInsets.all(8.0),
                          itemBuilder: (context, index) {
                            return FutureBuilder(
                                future: FirebaseFirestore.instance
                                    .collection('collection')
                                    .doc('usersInGroups')
                                    .collection(name)
                                    .get()
                                    .then((querySnapshot) {
                                  return {
                                    'name': querySnapshot.docs[index]
                                        .data()['name'],
                                    'id':
                                        querySnapshot.docs[index].data()['id'],
                                  };
                                }),
                                builder: (context, snapshot) {
                                  Map<String, dynamic> map =
                                      snapshot.data as Map<String, dynamic>;
                                  if (snapshot.hasError) {
                                    return Text("Something Went Wrong");
                                  }

                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    return Container(
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(25)),
                                          ),
                                          Padding(padding: EdgeInsets.all(10)),
                                          Container(
                                            child: Text(
                                              map['name'],
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  }

                                  return Container(
                                    child: Text("hello"),
                                  );
                                });
                          },
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

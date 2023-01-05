import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:image_picker/image_picker.dart';
import 'package:shop_app/models/Product.dart';
import 'package:shop_app/screens/details/details_screen.dart';
import 'package:shop_app/screens/home/components/card_builder.dart';
import 'package:shop_app/size_config.dart';

final List data = [
  {
    'link':
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQkJAv9XuANuIgB0dKGXMAaI0BdlalvPHBoFg&usqp=CAU"
  },
  {
    'link':
        "https://cdn.e-bebek.com/mnresize/1600/1600/y.ebebek/prod/productImage/8682766000108_1.jpg"
  },
  {
    'link':
        "https://cdn.cimri.io/image/480x480/arnica-prokit-444-mini-600-w-2-kademeli-1-lt-hazneli-mutfak-robotu-beyaz_439242844.jpg"
  },
  {
    'link':
        "https://floimages.mncdn.com/mnpadding/600/900/FFFFFF/media/catalog/product/21-09/29/101118385_f2.JPG?w=600"
  },
  {
    'link':
        "https://laco.akinoncdn.com/products/2021/11/22/162715/b903fcf9-3d8b-47e5-b4f2-799f89cf67e0_size2000x2000_cropCenter.jpg"
  },
  {
    'link':
        "https://m.media-amazon.com/images/I/61K+ZXG6XkL._AC_SY300_SX300_.jpg"
  },
  {
    'link':
        "https://koctas-img.mncdn.com/mnresize/300/300/productimages/2000030832/2000030832_1_MC/8810151051314_1564672331355.jpg"
  },
  {
    'link':
        "https://cdn.saatvesaat.com.tr/media/catalog/product/w/w/wwc2001-03_1_3.jpg"
  },
  {'link': "https://cdn.bkmkitap.com/beyin-187584-9500582-18-O.jpg"},
  {
    'link':
        "https://samsung-akinon.b-cdn.net/products/2021/10/26/10759/2d294633-9080-46e4-917c-b3c464f62d3e_size375x375.jpg"
  }
];

class SwipableCards extends StatefulWidget {
  const SwipableCards({Key? key}) : super(key: key);

  @override
  _SwipableCardsState createState() => _SwipableCardsState();
}

class _SwipableCardsState extends State<SwipableCards> {
  bool dataIn = false;
  List<CardBuilder> cardsList = [];

  Future<void> getData() async {
    dataIn = true;
    int i = 1;
    List<Map<String, dynamic>> threeData = [];
    // Get docs from collection reference
    QuerySnapshot querySnapshot =
        await _firestore.doc("uploads").collection("userUploads").get();

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    allData.forEach((element) {
      var item = element as Map<String, dynamic>;
      if (i < 3 && item["by"] != FirebaseAuth.instance.currentUser!.uid) {
        threeData.add(item);
        i++;
      } else if (i == 3 || element == allData.last) {
        addToCardList(threeData);
        i++;
      } else {
        addToCardList(threeData);
      }
    });
  }

  void addToCardList(List<Map<String, dynamic>> data) {
    log("here");
    CardBuilder card = new CardBuilder(
      imageLink: "",
      title: "",
      priceInterval: 0,
      name: "Something Went Wrong",
      hastags: "",
      userId: "",
      uploadId: "",
    );

    data.forEach((value) {
      bool dataBool = false;
      Map<String, dynamic> item = value;

      String category = item["category"];
      String description = item["description"];
      String hastags = item["hastags"];
      String id = item["id"];
      String imageCount = item["imageCount"];
      String imagePath = item["imagePath"];
      String uploadId = item["uploadId"];
      String title = item["title"];
      String userId = item["by"];
      String userName = item["byUserName"];

      var imageLinks = "";

      card = new CardBuilder(
        imageLink: imageLinks,
        title: title,
        priceInterval: 0,
        name: userName,
        hastags: hastags,
        userId: userId,
        uploadId: uploadId,
      );

      if (!dataBool) {
        setState(() {
          cardsList.add(card);

          dataBool = true;
        });
      }
    });
  }

  CollectionReference _firestore =
      FirebaseFirestore.instance.collection("collection");

  Product demoProduct = new Product(
      id: 1,
      images: [
        XFile("assets/images/ps4_console_white_1.png"),
        XFile("assets/images/ps4_console_white_2.png"),
        XFile("assets/images/ps4_console_white_3.png"),
        XFile("assets/images/ps4_console_white_4.png")
      ],
      title: "ITEM NAME",
      category: "Hobbies",
      priceInterval: "too high lol",
      description: "DESCRIPTION OF THIS ITEM WILL BE SEEN HERE");

  @override
  Widget build(BuildContext context) {
    if (!dataIn) {
      getData();
    }

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          DetailsScreen.routeName,
          arguments: ProductDetailsArguments(product: demoProduct),
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 1,
        height: MediaQuery.of(context).size.height * 0.66,
        child: Padding(
            padding:
                EdgeInsets.fromLTRB(SizeConfig.screenWidth * 0.075, 0, 0, 0),
            child: Stack(
              children: cardsList,
            )),
      ),
    );
  }
}

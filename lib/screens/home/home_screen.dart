import 'package:flutter/material.dart';
import 'package:shop_app/components/coustom_bottom_nav_bar.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/enums.dart';
import 'package:shop_app/screens/add_item/add_item_screen.dart';

import 'components/body.dart';

class HomeScreen extends StatelessWidget {
  static String routeName = "/home";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: kprimaryWhite,
          titleSpacing: 0,
          title: Container(
            width: 500,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Container(
                      width: 150,
                      child: Image(
                          image: AssetImage(
                              "assets/images/matchingoods_home.png"))),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    buildTopToolbarItem(
                        40,
                        Image(
                            image: AssetImage("assets/images/add_group.png"))),
                    Padding(padding: EdgeInsets.all(5)),
                    buildTopToolbarItem(
                        30,
                        Image(
                            image:
                                AssetImage("assets/images/notification.png"))),
                    Padding(padding: EdgeInsets.all(5)),
                  ],
                )
              ],
            ),
          )),
      body: Body(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            new MaterialPageRoute(
              builder: (context) => new AddItemScreen(),
            ),
          );
        },
        backgroundColor: kprimaryGrey,
        child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/add_item.png")))),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.home),
    );
  }

  // HASHTAG + --  USER NAME ALTINA
  // NEW ITEM -- LIKED YOUR ITEM -- ANOTHER CHANCE DONE

  GestureDetector buildTopToolbarItem(double width, Image image) {
    return GestureDetector(child: Container(width: width, child: image));
  }
}

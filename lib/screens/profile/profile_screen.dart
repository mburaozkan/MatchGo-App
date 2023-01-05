import 'package:flutter/material.dart';
import 'package:shop_app/components/coustom_bottom_nav_bar.dart';
import 'package:shop_app/enums.dart';
import 'package:shop_app/screens/settings/settings_screen.dart';

class ProfileScreen extends StatelessWidget {
  TextStyle textStyle =
      new TextStyle(color: Colors.orange, fontWeight: FontWeight.bold);

  static String routeName = "/profile";
  @override
  Widget build(BuildContext context) => DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('TRADINGS', style: textStyle),
          bottom: TabBar(
            tabs: [
              Tab(
                child: Text(
                  'FAVORED',
                  style: textStyle,
                ),
              ),
              Tab(
                child: Text(
                  'UPLOADED',
                  style: textStyle,
                ),
              ),
              Tab(
                child: Text(
                  'TRADED',
                  style: textStyle,
                ),
              )
            ],
          ),
          actions: [
            Padding(
                padding: EdgeInsets.all(15.0),
                child: GestureDetector(
                    child: Icon(Icons.settings),
                    onTap: () {
                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                          builder: (context) => new SettingsScreen(),
                        ),
                      );
                      ;
                    }))
          ],
        ),
        body: TabBarView(children: [
          itemView("FAVORITE ITEMS"),
          itemView("UPLOADED ITEMS"),
          itemView("TRADED ITEMS"),
        ]),
        bottomNavigationBar:
            CustomBottomNavBar(selectedMenu: MenuState.profile),
      ));

  Container itemView(text) {
    return Container(
      alignment: Alignment.center,
      child: Text(text, style: textStyle),
    );
  }
}

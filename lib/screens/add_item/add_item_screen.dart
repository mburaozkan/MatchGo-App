import 'package:flutter/material.dart';
import 'package:shop_app/screens/add_item/components/body.dart';

class AddItemScreen extends StatelessWidget {
  static String routeName = "/add_item";
  const AddItemScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "LISTING DETAILS",
          style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
        ),
      ),
      body: Body(),
    );

    // 0 Düşük 500 Orta 2500 Yüksek  -  Çok Yüksek
    // İSİM , TL/DOLAR İCON , ---- (MEDIUM)  DONE
  }
}

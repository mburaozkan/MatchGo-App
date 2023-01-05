import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shop_app/size_config.dart';

class AddPhoto extends StatefulWidget {
  static List<XFile?> list = [];

  const AddPhoto({Key? key}) : super(key: key);

  @override
  State<AddPhoto> createState() => _AddPhotoState();

  void setList(setter) {
    list = setter;
  }

  List<XFile?> getList() {
    return list;
  }
}

class _AddPhotoState extends State<AddPhoto> {
  static XFile? _image1;
  static XFile? _image2;
  static XFile? _image3;
  static XFile? _image4;
  static XFile? _image5;

  @override
  Widget build(BuildContext context) {
    Image plusRect = Image.asset(
      "assets/images/plus_sign.png",
      height: MediaQuery.of(context).size.height * 0.05,
      width: MediaQuery.of(context).size.width * 0.05,
    );

    List<Image> _imageList = [
      _image1 == null ? plusRect : Image.file(File(_image1!.path)),
      _image2 == null ? plusRect : Image.file(File(_image2!.path)),
      _image3 == null ? plusRect : Image.file(File(_image3!.path)),
      _image4 == null ? plusRect : Image.file(File(_image4!.path)),
      _image5 == null ? plusRect : Image.file(File(_image5!.path))
    ];

    Padding childMaker(index) {
      return Padding(padding: EdgeInsets.all(2), child: _imageList[index]);
    }

    BoxDecoration boxDecoration = new BoxDecoration(
      border: Border.all(),
      borderRadius: BorderRadius.circular(5.0),
    );

    void tapped(holder) async {
      ImagePicker _picker = new ImagePicker();
      XFile? image = await _picker.pickImage(
          source: ImageSource.gallery, imageQuality: 50);

      setState(() {
        switch (holder) {
          case "1":
            {
              _image1 = image;
              break;
            }
          case "2":
            {
              _image2 = image;
              break;
            }

          case "3":
            {
              _image3 = image;
              break;
            }

          case "4":
            {
              _image4 = image;
              break;
            }

          case "5":
            {
              _image5 = image;
              break;
            }
        }

        widget.setList([_image1, _image2, _image3, _image4, _image5]);
      });
    }

    GestureDetector child(index, holder) {
      return GestureDetector(
        child: Container(
          height: SizeConfig.screenHeight * 0.1,
          width: SizeConfig.screenWidth * 0.2,
          decoration: boxDecoration,
          child: childMaker(index),
        ),
        onTap: () {
          tapped(holder);
        },
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          child(0, "1"),
          Padding(padding: EdgeInsets.all(5.0)),
          child(1, "2"),
          Padding(padding: EdgeInsets.all(5.0)),
          child(2, "3"),
          Padding(padding: EdgeInsets.all(5.0)),
          child(3, "4"),
          Padding(padding: EdgeInsets.all(5.0)),
          child(4, "5"),
        ],
      ),
    );
  }
}

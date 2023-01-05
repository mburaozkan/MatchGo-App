import 'package:image_picker/image_picker.dart';

class Product {
  final int id;
  final String title, description, category;
  final List<XFile?> images;
  final String priceInterval;

  Product({
    required this.id,
    required this.images,
    required this.title,
    required this.priceInterval,
    required this.description,
    required this.category,
  });

  get getId => this.id;

  get getCategory => this.category;

  get getImages => this.images;

  get getPriceInterval => this.priceInterval;

  get getTitle => this.title;

  get getDescription => this.description;
}

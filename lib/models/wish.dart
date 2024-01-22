

import 'package:wishes_app/models/categories.dart';

class Wish {
  final String id;
  final String imageUrl;
  final String title;
  final int price;
  final String? itemUrl;
  final Category category;
  final String? creatorAvatarUrl;


  const Wish({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.category,
    this.creatorAvatarUrl,
    this.itemUrl,
  });
}
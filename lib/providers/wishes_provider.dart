import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishes_app/data/categories.dart';
import 'package:wishes_app/models/categories.dart';
import 'package:wishes_app/models/wish.dart';
import 'package:wishes_app/services/api_service.dart';

class WishesNotifier extends StateNotifier<List<Wish>> {
  WishesNotifier() : super(const []);

  final api_service = ApiService();

  Future<void> loadWishes() async {
    final wishes = await api_service.getWishes();

    final Map<String, dynamic> listData = json.decode(wishes.body);
    final List<Wish> loadedItems = [];
    for (final item in listData.entries) {
      final category = categories.entries
          .firstWhere(
              (catItem) => catItem.value.title == item.value['category'])
          .value;
      loadedItems.add(
        Wish(
          id: item.key,  
          title: item.value['title'],
          price: item.value['price'],
          category: category,
          itemUrl: item.value['itemUrl'],
          imageUrl: item.value['imageUrl'],
        ),
      );
    }
    state = loadedItems;
  }

  void addWish(
    String title,
    int price,
    Category category,
    String itemUrl,
    String selectedImage,
  ) async {
    final createdWish = await api_service.createWish(
      title: title,
      price: price,
      category: category.title,
      itemUrl: itemUrl,
      selectedImage: selectedImage,
    );

    final wishResponse = json.decode(createdWish.body);

    final newWish = Wish(
        id: wishResponse['name'],
        imageUrl: selectedImage,
        title: title,
        price: price,
        itemUrl: itemUrl,
        category: category);

    state = [newWish, ...state];
  }
}

final wishesProvider = StateNotifierProvider<WishesNotifier, List<Wish>>(
  (ref) => WishesNotifier(),
);

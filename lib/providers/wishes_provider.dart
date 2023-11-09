import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishes_app/data/categories.dart';
import 'package:wishes_app/models/categories.dart';
import 'package:wishes_app/models/wish.dart';
import 'package:wishes_app/services/api_service.dart';

class WishesNotifier extends StateNotifier<List<Wish>> {
  WishesNotifier() : super(const []);

  final pocketbaseApiService = ApiServicePocketBase();

  void pocketAddWish(
    String title,
    int price,
    Category category,
    String itemUrl,
    String selectedImage,
  ) async {
    final createdWish = await pocketbaseApiService.createWish(
      title: title,
      price: price,
      category: category.title,
      itemUrl: itemUrl,
      selectedImage: selectedImage,
    );

    final newWish = Wish(
        id: createdWish['id'],
        imageUrl: selectedImage,
        title: title,
        price: price,
        itemUrl: itemUrl,
        category: category);

    state = [newWish, ...state];
  }

  Future<void> pocketLoadWishes() async {
    final wishes = await pocketbaseApiService.getWishes();

    final List<Wish> loadedItems = [];
    for (final item in wishes) {
      final category = categories.entries
          .firstWhere(
              (catItem) => catItem.value.title == item.data['category'])
          .value;
  
      loadedItems.add(
        Wish(
          id: item.id,  
          title: item.data['title'],
          price: item.data['price'],
          category: category,
          itemUrl: item.data['itemUrl'],
          imageUrl: item.data['imageUrl'],
        ),
      );
    }
    state = loadedItems;
  }

}

final wishesProvider = StateNotifierProvider<WishesNotifier, List<Wish>>(
  (ref) => WishesNotifier(),
);

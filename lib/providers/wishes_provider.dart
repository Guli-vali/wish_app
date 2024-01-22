import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wishes_app/data/categories.dart';
import 'package:wishes_app/models/categories.dart';
import 'package:wishes_app/models/pref_keys.dart';
import 'package:wishes_app/models/wish.dart';
import 'package:wishes_app/services/api_service.dart';

class WishesNotifier extends Notifier<List<Wish>> {
  @override
  List<Wish> build() => const [];

  Future<void> pocketAddWish(
    String title,
    int price,
    Category category,
    String? itemUrl,
    File? selectedPhoto,
  ) async {
      final prefs = await SharedPreferences.getInstance();
      final creatorModelId = prefs.getString(PrefKeys.accessModelPrefsKey)!;
      final createdWish = await pocketbaseApiService.createWish(
        title: title,
        price: price,
        category: category.title,
        itemUrl: itemUrl,
        selectedPhoto: selectedPhoto,
        creator: creatorModelId,
      );

      final newWish = Wish(
          id: createdWish['id'],
          imageUrl: createdWish['imageUrl'],
          title: title,
          price: price,
          itemUrl: itemUrl,
          category: category);

      state = [newWish, ...state];
  }

  Future<void> pocketLoadWishes({bool currentUserOnly = true}) async {
    final wishes = await pocketbaseApiService.getWishes(currentUserOnly: currentUserOnly);

    final List<Wish> loadedItems = [];
    for (final item in wishes) {
      final category = categories.entries
          .firstWhere((catItem) => catItem.value.title == item['category'])
          .value;

      loadedItems.add(
        Wish(
          id: item['id'],
          title: item['title'],
          price: item['price'],
          category: category,
          itemUrl: item['itemUrl'],
          imageUrl: item['imageUrl'],
          creatorAvatarUrl: item['avatarUrlFull'],
        ),
      );
    }
    state = loadedItems;
  }
}

final wishesProvider =
    NotifierProvider<WishesNotifier, List<Wish>>(WishesNotifier.new);

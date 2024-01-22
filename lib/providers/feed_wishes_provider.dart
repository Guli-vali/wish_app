import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wishes_app/data/categories.dart';
import 'package:wishes_app/models/categories.dart';
import 'package:wishes_app/models/pref_keys.dart';
import 'package:wishes_app/models/wish.dart';
import 'package:wishes_app/services/api_service.dart';

class FeedWishesNotifier extends Notifier<List<Wish>> {
  // @override
  // Future<List<Wish>> build() async => _fetchWishes(currentUserOnly: false);

  @override
  List<Wish> build() => const [];

  Future<void> fetchWishes({bool currentUserOnly = false}) async {
    final wishes =
        await pocketbaseApiService.getWishes(currentUserOnly: currentUserOnly);

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

final feedWishesProvider =
    NotifierProvider<FeedWishesNotifier, List<Wish>>(FeedWishesNotifier.new);

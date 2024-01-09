import 'dart:core';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishes_app/models/profile.dart';
import 'package:wishes_app/providers/friend_requests_provider.dart';
import 'package:wishes_app/providers/friends_provider.dart';
import 'package:wishes_app/services/api_service.dart';

class UserNotifier extends Notifier<List<userProfile>> {
  @override
  List<userProfile> build() => const [];

  Future<void> getUsersForSearch() async {

    final fRequests = ref.watch(friendRequestsProvider);
    final requestedUserIds = [];
    for (final fR in fRequests) {
      requestedUserIds.add(fR.fromUser.id);
      requestedUserIds.add(fR.toUser.id);
    }

    final stateFriends = ref.watch(friendsProvider);
    for (final fr in stateFriends) {
      requestedUserIds.add(fr.id);
    }

    final searchQury = ref.read(searchQueryProvider);
    final friends = await pocketbaseApiService.getUsers(searchQury);

    final List<userProfile> loadedItems = [];
    for (final item in friends) {
      loadedItems.add(
        userProfile(
          id: item['id'],
          avatarUrl: item['avatar_url_full'],
          name: item['name'],
          email: item['email'],
        ),
      );
    }
    // state = loadedItems;
    state = [
      for (final user in loadedItems)
        if (!requestedUserIds.contains(user.id)) user,
    ];
  }
}
final usersProvider =
    NotifierProvider<UserNotifier, List<userProfile>>(UserNotifier.new);


class UserSearchNotifier extends Notifier<String> {
  @override
  String build() => '';

  void update(String value) {
    state = value;
  }
}
final searchQueryProvider =
    NotifierProvider<UserSearchNotifier, String>(UserSearchNotifier.new);

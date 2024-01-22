import 'dart:core';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishes_app/models/friend_request.dart';
import 'package:wishes_app/models/profile.dart';
import 'package:wishes_app/providers/friend_requests_provider.dart';
import 'package:wishes_app/services/api_service.dart';

class FriendsNotifier extends Notifier<List<UserProfile>> {
  @override
  List<UserProfile> build() => const [];

  Future<void> getAuthUserFriends() async {
    final friends = await pocketbaseApiService.getAuthenticatedUserFriends();

    final List<UserProfile> loadedItems = [];
    for (final item in friends) {
      loadedItems.add(
        UserProfile(
          id: item['id'],
          avatarUrl: item['avatar_url_full'],
          name: item['name'],
          email: item['email'],
        ),
      );
    }
    state = loadedItems;
  }

  Future<void> addFriend(FriendRequestWithID fRequest) async {
    final createdUser = await pocketbaseApiService.acceptFriendRequestWorkflow(
      fRequest.toJson(),
    );

    final addedFriend = UserProfile(
      id: createdUser['id'],
      avatarUrl: createdUser['avatarUrl'],
      name: createdUser['name'],
      email: createdUser['email'],
    );

    ref.read(friendRequestsProvider.notifier).removeFriendRequestBySender(fRequest.fromUser.id);
    state = [addedFriend, ...state];
  }
}

final friendsProvider =
    NotifierProvider<FriendsNotifier, List<UserProfile>>(FriendsNotifier.new);

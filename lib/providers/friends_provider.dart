import 'dart:core';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishes_app/models/friend_request.dart';
import 'package:wishes_app/models/profile.dart';
import 'package:wishes_app/providers/friend_requests_provider.dart';
import 'package:wishes_app/services/api_service.dart';

class FriendsNotifier extends Notifier<List<userProfile>> {
  @override
  List<userProfile> build() => const [];

  Future<void> getAuthUserFriends() async {
    final friends = await pocketbaseApiService.getAuthenticatedUserFriends();

    final List<userProfile> loadedItems = [];
    for (final item in friends) {
      if (item['id'] != await pocketbaseApiService.pb.authStore.model.id) {
        loadedItems.add(
          userProfile(
            id: item['id'],
            avatarUrl: item['avatar_url_full'],
            name: item['name'],
            email: item['email'],
          ),
        );
      }
    }
    state = loadedItems;
  }

  Future<void> addFriend(FriendRequestWithID fRequest) async {
    final createdUser = await pocketbaseApiService.acceptFriendRequestWorkflow(
      fRequest.toJson(),
    );

    final addedFriend = userProfile(
      id: createdUser['id'],
      avatarUrl: createdUser['avatarUrl'],
      name: createdUser['name'],
      email: createdUser['email'],
    );

    ref.read(friendRequestsProvider.notifier).removeFriendRequest(fRequest.id);
    state = [addedFriend, ...state];
  }
}

final friendsProvider =
    NotifierProvider<FriendsNotifier, List<userProfile>>(FriendsNotifier.new);

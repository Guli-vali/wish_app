import 'dart:core';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishes_app/models/friend_request.dart';
import 'package:wishes_app/models/profile.dart';
import 'package:wishes_app/services/api_service.dart';

class FriendRequestsNotifier extends Notifier<List<FriendRequestWithID>> {
  @override
  List<FriendRequestWithID> build() => const [];

  Future<void> getRecords() async {
    final friends = await pocketbaseApiService.getFriendRequests();

    final List<FriendRequestWithID> loadedItems = [];
    for (final item in friends) {
      loadedItems.add(
        FriendRequestWithID(
          id: item['id'],
          fromUser: userProfile(
            id: item['from_user']['id'],
            avatarUrl: item['from_user']['avatarUrl'],
            name: item['from_user']['name'],
            email: item['from_user']['email'],
          ),
          toUser: userProfile(
            id: item['to_user']['id'],
            avatarUrl: item['to_user']['avatarUrl'],
            name: item['to_user']['name'],
            email: item['to_user']['email'],
          ),
        ),
      );
    }
    state = loadedItems;
  }

  Future<void> addFriendRequest(FriendRequest fRequest) async {
    final createdFriendRequest = await pocketbaseApiService.sendFriendRequest(
      fRequest.toJson(),
    );

    final addedFriendRequest = FriendRequestWithID(
      id: createdFriendRequest['id'],
      fromUser: userProfile(
        id: createdFriendRequest['from_user']['id'],
        avatarUrl: createdFriendRequest['from_user']['avatarUrl'],
        name: createdFriendRequest['from_user']['name'],
        email: createdFriendRequest['from_user']['email'],
      ),
      toUser: userProfile(
        id: createdFriendRequest['to_user']['id'],
        avatarUrl: createdFriendRequest['to_user']['avatarUrl'],
        name: createdFriendRequest['to_user']['name'],
        email: createdFriendRequest['to_user']['email'],
      ),
    );

    state = [addedFriendRequest, ...state];
  }

  removeFriendRequest(String fRequestId) async {
    // Again, our state is immutable. So we're making a new list instead of
    // changing the existing list.
    state = [
      for (final fRequest in state)
        if (fRequest.id != fRequestId) fRequest,
    ];
  }
}

final friendRequestsProvider =
    NotifierProvider<FriendRequestsNotifier, List<FriendRequestWithID>>(
        FriendRequestsNotifier.new);

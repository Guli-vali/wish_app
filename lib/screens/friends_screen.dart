
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wishes_app/models/friend_request.dart';
import 'package:wishes_app/models/profile.dart';
import 'package:wishes_app/providers/friend_requests_provider.dart';
import 'package:wishes_app/providers/friends_provider.dart';
import 'package:wishes_app/providers/users_provider.dart';
import 'package:wishes_app/services/api_service.dart';
import 'package:wishes_app/widgets/friend_request_tile.dart';
import 'package:wishes_app/widgets/profile_tile.dart';

class FriendsScreen extends ConsumerStatefulWidget {
  const FriendsScreen({super.key});

  @override
  ConsumerState<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends ConsumerState<FriendsScreen> {
  int activePage = 0;
  final List<bool> _selectedPresentationMode = <bool>[true, false];

  late Future<void> _friendsFuture;
  late Future<void> _friendRequestsFuture;
  final _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _friendsFuture = ref.read(friendsProvider.notifier).getAuthUserFriends();
    _friendRequestsFuture =
        ref.read(friendRequestsProvider.notifier).getRecords();
  }

  void _navigateToAddFriend(
    BuildContext context,
    List<UserProfile> profiles,
  ) {
    Widget friendsList(
      List<UserProfile> profiles,
    ) {
      return ListView.separated(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return FriendRequestModalTile(
            profile: profiles[index],
            friendRequest: FriendRequest(
                fromUserId: pocketbaseApiService.pb.authStore.model.id,
                toUserId: profiles[index].id),
            onSendFRequest:
                ref.read(friendRequestsProvider.notifier).addFriendRequest,
          );
        },
        separatorBuilder: (context, index) => const SizedBox(
          height: 20,
        ),
        itemCount: profiles.length,
      );
    }

    showModalBottomSheet(
      isScrollControlled: true,
      constraints:
          BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.85),
      context: context,
      builder: (context) {
        return Consumer(
            builder: (BuildContext context, WidgetRef ref, Widget? child) {
          final users = ref.watch(usersProvider);
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                SearchBar(
                  hintText: 'Search by name...',
                  leading: Icon(
                    Icons.search,
                    color: Colors.black.withOpacity(0.8),
                  ),
                  controller: _textEditingController,
                  onSubmitted: (String value) {
                    if (value.isNotEmpty) {
                      ref.read(searchQueryProvider.notifier).update(value);
                      ref.read(usersProvider.notifier).getUsersForSearch();
                    }
                  },
                ),
                const SizedBox(height: 30),
                friendsList(users),
              ],
            ),
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final friends = ref.watch(friendsProvider);
    final friendRequests = ref.watch(friendRequestsProvider);
    final users = ref.watch(usersProvider);

    Widget friendsList(
      List<UserProfile> profiles,
    ) {
      return ListView.separated(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return ProfileTile(profile: profiles[index]);
        },
        separatorBuilder: (context, index) => const SizedBox(
          height: 10,
        ),
        itemCount: profiles.length,
      );
    }

    Widget friendsSection() {
      if (friends.isEmpty) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                'Add some friends to see them here 😊',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .copyWith(color: Colors.black.withOpacity(0.25)),
              ),
            ),
          ],
        );
      } else {
        return Expanded(
          child: FutureBuilder(
            future: _friendsFuture,
            builder: (context, snapshot) =>
                snapshot.connectionState == ConnectionState.waiting
                    ? const Center(child: CircularProgressIndicator())
                    : friendsList(
                        friends,
                      ),
          ),
        );
      }
    }

    Widget friendRequestsList(
      List<FriendRequestWithID> fRequests,
    ) {
      return ListView.separated(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return FriendRequestTile(
            friendRequest: fRequests[index],
            currentUserId: pocketbaseApiService.pb.authStore.model.id,
            onAcceptFRequest: ref.read(friendsProvider.notifier).addFriend,
          );
        },
        separatorBuilder: (context, index) => const SizedBox(
          height: 10,
        ),
        itemCount: fRequests.length,
      );
    }

    Widget friendRequestsSection() {
      if (friendRequests.isEmpty) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                'Send some requests to see them here 😊',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .copyWith(color: Colors.black.withOpacity(0.25)),
              ),
            ),
          ],
        );
      } else {
        return Expanded(
          child: FutureBuilder(
            future: _friendRequestsFuture,
            builder: (context, snapshot) =>
                snapshot.connectionState == ConnectionState.waiting
                    ? const Center(child: CircularProgressIndicator())
                    : friendRequestsList(
                        friendRequests,
                      ),
          ),
        );
      }
    }

    Widget swichWidget(selectedPresentationMode) {
      if (selectedPresentationMode[1] == true) {
        return friendRequestsSection();
      }

      return friendsSection();
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text("Friends"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          _navigateToAddFriend(context, users),
        },
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        child: const Icon(Icons.person_add),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              const SizedBox(height: 15),
              ToggleButtons(
                direction: Axis.horizontal,
                onPressed: (int index) {
                  setState(() {
                    // The button that is tapped is set to true, and the others to false.
                    for (int i = 0; i < _selectedPresentationMode.length; i++) {
                      _selectedPresentationMode[i] = i == index;
                    }
                  });
                },
                constraints: BoxConstraints(
                    minWidth: (MediaQuery.of(context).size.width - 50) / 2),
                isSelected: _selectedPresentationMode,
                children: const [
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('friends'),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('friend requests'),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 15),
              swichWidget(_selectedPresentationMode),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:wishes_app/models/friend_request.dart';
import 'package:wishes_app/models/profile.dart';

class FriendRequestModalTile extends StatelessWidget {
  const FriendRequestModalTile({
    super.key,
    required this.profile,
    required this.friendRequest,
    required this.onSendFRequest,
  });

  final UserProfile profile;
  final FriendRequest friendRequest;
  final Function onSendFRequest;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: CircleAvatar(
                backgroundImage: NetworkImage(profile.avatarUrl),
                maxRadius: 35.0,
              ),
            ),
            const SizedBox(width: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 5,
                ),
                Text(
                  profile.name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ],
        ),
        ElevatedButton(
          onPressed: () {
            var snackBar = const SnackBar(
              content: Text('Friend request sent!'),
              behavior: SnackBarBehavior.floating,
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            onSendFRequest(friendRequest);
            Navigator.pop(context);
          },
          child: const Text(
            'Send',
            style: TextStyle(color: Colors.white),
          ),
        )
      ],
    );
  }
}

class FriendRequestTile extends StatelessWidget {
  const FriendRequestTile({
    super.key,
    required this.friendRequest,
    required this.currentUserId,
    required this.onAcceptFRequest,
  });

  final FriendRequestWithID friendRequest;
  final String currentUserId;
  final Function onAcceptFRequest;

  @override
  Widget build(BuildContext context) {
    Widget getPreparedTile(UserProfile user, String btnText, bool disabled) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(user.avatarUrl),
                  maxRadius: 35.0,
                ),
              ),
              const SizedBox(width: 20),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    user.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ],
          ),
          ElevatedButton(
            onPressed: disabled
                ? () {}
                : () {
                    onAcceptFRequest(friendRequest);
                    var snackBar = const SnackBar(
                        content: Text('Friend request accepted!'));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
            child: Text(
              btnText,
              style: const TextStyle(color: Colors.white),
            ),
          )
        ],
      );
    }

    if (friendRequest.fromUser.id == currentUserId) {
      return getPreparedTile(friendRequest.toUser, 'Sent', true);
    }
    return getPreparedTile(friendRequest.fromUser, 'Accept', false);
  }
}
